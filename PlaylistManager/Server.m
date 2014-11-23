//
//  Server.m
//  ClientServer
//
//  Created by Zachary Jenkins on 11/9/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
//
// THIS SHOULD BE YOUR WORKING COPY
#import "Server.h"

#import "ServerConnection.h"

#include <sys/socket.h>

#include <netinet/in.h>

#include <unistd.h>

@interface Server () <NSStreamDelegate>

@property (nonatomic, assign, readwrite) NSUInteger port;

@property (nonatomic, strong, readwrite) NSNetService *netService;

@property (nonatomic, strong, readonly ) NSMutableSet *connections;

@end

@implementation Server
{
    CFSocketRef _ipv4socket;
    CFSocketRef _ipv6socket;
}

@synthesize port = _port;

@synthesize netService = _netService;

@synthesize connections = _connections;

- (id)init
{
    self = [super init];
    self.name = @"";
    if (self != nil)
    {
        _connections = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self stop];
}

- (void)ConnectionDidCloseNotification:(NSNotification *)note
{
    ServerConnection *connection = [note object];
    assert([connection isKindOfClass:[ServerConnection class]]);
    [(NSNotificationCenter *)[NSNotificationCenter defaultCenter] removeObserver:self
                                                                            name:ConnectionDidCloseNotification
                                                                          object:connection];
    [self.connections removeObject:connection];
    NSLog(@"Server: Connection closed.");
}

- (void)acceptConnection:(CFSocketNativeHandle)nativeSocketHandle
{
    CFReadStreamRef readStream = NULL;
    CFWriteStreamRef writeStream = NULL;
    CFStreamCreatePairWithSocket(kCFAllocatorDefault, nativeSocketHandle, &readStream, &writeStream);
    if (readStream && writeStream)
    {
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        ServerConnection * connection = [[ServerConnection alloc] initWithInputStream:(__bridge NSInputStream *)readStream outputStream:(__bridge NSOutputStream *)writeStream];
        connection.Host = self.host;
        [self.connections addObject:connection];
        [connection open];
        [(NSNotificationCenter *)[NSNotificationCenter defaultCenter] addObserver:self
                                                                         selector:@selector(ConnectionDidCloseNotification:)
                                                                             name:ConnectionDidCloseNotification
                                                                           object:connection];
        NSLog(@"Server: Added connection.");
    }
    else
    {
        // On any failure, we need to destroy the CFSocketNativeHandle
        // since we are not going to use it any more.
        (void) close(nativeSocketHandle);
    }
    if (readStream)
    {
        CFRelease(readStream);
    }
    if (writeStream)
    {
        CFRelease(writeStream);
    }
}

// This function is called by CFSocket when a new connection comes in.
// We gather the data we need, and then convert the function call to a method
// invocation on EchoServer.
static void EchoServerAcceptCallBack(CFSocketRef socket,
                                     CFSocketCallBackType type,
                                     CFDataRef address,
                                     const void *data,
                                     void *info)
{
    assert(type == kCFSocketAcceptCallBack);
#pragma unused(type)
#pragma unused(address)
    
    Server *echoServer = (__bridge Server *)info;
    assert(socket == echoServer->_ipv4socket || socket == echoServer->_ipv6socket);
#pragma unused(socket)
    
    // For an accept callback, the data parameter is a pointer to a CFSocketNativeHandle.
    [echoServer acceptConnection:*(CFSocketNativeHandle *)data];
}

// this is a wrapper function to start the server
- (BOOL)startWithName:(NSString *)name WithHost:(User *)host{
    self.name = name;
    self.host = host;
    [NSThread detachNewThreadSelector:@selector(start) toTarget:self withObject:nil];
    return true;
    
    
    
}


- (BOOL)start
{
    assert(_ipv4socket == NULL && _ipv6socket == NULL);       // don't call -start twice!
    
    
    CFSocketContext socketCtxt = {0, (__bridge void *) self, NULL, NULL, NULL};
    _ipv4socket = CFSocketCreate(kCFAllocatorDefault, AF_INET,  SOCK_STREAM, 0, kCFSocketAcceptCallBack, &EchoServerAcceptCallBack, &socketCtxt);
    _ipv6socket = CFSocketCreate(kCFAllocatorDefault, AF_INET6, SOCK_STREAM, 0, kCFSocketAcceptCallBack, &EchoServerAcceptCallBack, &socketCtxt);
    
    if (NULL == _ipv4socket || NULL == _ipv6socket)
    {
        [self stop];
        return NO;
    }
    
    static const int yes = 1;
    (void) setsockopt(CFSocketGetNative(_ipv4socket), SOL_SOCKET, SO_REUSEADDR, (const void *) &yes, sizeof(yes));
    (void) setsockopt(CFSocketGetNative(_ipv6socket), SOL_SOCKET, SO_REUSEADDR, (const void *) &yes, sizeof(yes));
    
    // Set up the IPv4 listening socket; port is 0, which will cause the kernel to choose a port for us.
    struct sockaddr_in addr4;
    memset(&addr4, 0, sizeof(addr4));
    addr4.sin_len = sizeof(addr4);
    addr4.sin_family = AF_INET;
    addr4.sin_port = htons(0);
    addr4.sin_addr.s_addr = htonl(INADDR_ANY);
    if (kCFSocketSuccess != CFSocketSetAddress(_ipv4socket, (__bridge CFDataRef) [NSData dataWithBytes:&addr4 length:sizeof(addr4)]))
    {
        [self stop];
        return NO;
    }
    
    // Now that the IPv4 binding was successful, we get the port number
    // -- we will need it for the IPv6 listening socket and for the NSNetService.
    NSData *addr = (__bridge_transfer NSData *)CFSocketCopyAddress(_ipv4socket);
    assert([addr length] == sizeof(struct sockaddr_in));
    self.port = ntohs(((const struct sockaddr_in *)[addr bytes])->sin_port);
    
    // Set up the IPv6 listening socket.
    struct sockaddr_in6 addr6;
    memset(&addr6, 0, sizeof(addr6));
    addr6.sin6_len = sizeof(addr6);
    addr6.sin6_family = AF_INET6;
    addr6.sin6_port = htons(self.port);
    memcpy(&(addr6.sin6_addr), &in6addr_any, sizeof(addr6.sin6_addr));
    if (kCFSocketSuccess != CFSocketSetAddress(_ipv6socket, (__bridge CFDataRef) [NSData dataWithBytes:&addr6 length:sizeof(addr6)]))
    {
        [self stop];
        return NO;
    }
    
    // Set up the run loop sources for the sockets.
    CFRunLoopSourceRef source4 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _ipv4socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source4, kCFRunLoopCommonModes);
    CFRelease(source4);
    
    CFRunLoopSourceRef source6 = CFSocketCreateRunLoopSource(kCFAllocatorDefault, _ipv6socket, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source6, kCFRunLoopCommonModes);
    CFRelease(source6);
    
    assert(self.port > 0 && self.port < 65536);
    
    // Settings that define how and where the server is published using bonjour
    // Name will be what the client sees the service advertised as. Must be set before published
    
    self.netService = [[NSNetService alloc] initWithDomain:@"local."
                                                      type:@"_PlayLister._tcp."
                                                      name: self.name
                                                      port:(int) self.port];
    [self.netService publishWithOptions:0];
    //
    self.running = true;
    
    [[NSRunLoop currentRunLoop] run];
    return YES;
}

- (void)stop
{
    self.running = false;
    NSLog(@"stopped server");
    [self.netService stop];
    self.netService = nil;
    
    // Closes all the open connections.  The ConnectionDidCloseNotification notification will ensure
    // that the connection gets removed from the self.connections set.  To avoid mututation under iteration
    // problems, we make a copy of that set and iterate over the copy.
    for (ServerConnection * connection in [self.connections copy])
    {
        [connection close];
    }
    if (_ipv4socket != NULL)
    {
        CFSocketInvalidate(_ipv4socket);
        CFRelease(_ipv4socket);
        _ipv4socket = NULL;
    }
    if (_ipv6socket != NULL)
    {
        CFSocketInvalidate(_ipv6socket);
        CFRelease(_ipv6socket);
        _ipv6socket = NULL;
    }
}

@end