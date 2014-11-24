//
//  ServerConnection.m
//  ClientServer
//
//  Created by Zachary Jenkins on 11/12/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
//
// THIS SHOULD BE YOUR WORKING COPY

#import "ServerConnection.h"

NSString *const ConnectionDidCloseNotification = @"ConnectionDidCloseNotification";

@interface ServerConnection () <NSStreamDelegate>


@property (nonatomic, strong, readwrite) NSMutableData *        inputBuffer;
@property (nonatomic, strong, readwrite) NSMutableData *        outputBuffer;
// this method should send a buffer to the client

- (BOOL) sendBytes:(NSString *) bytesToSend;


@end

@implementation ServerConnection

@synthesize inputStream  = _inputStream;

@synthesize outputStream = _outputStream;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream
{
    self = [super init];
    if (self != nil)
    {
        self->_inputStream = inputStream;
        self->_outputStream = outputStream;
    }
    return self;
}

- (BOOL)open
{
    [self.inputStream  setDelegate:self];
    [self.outputStream setDelegate:self];
    [self.inputStream  scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.inputStream  open];
    [self.outputStream open];
    self.inputBuffer = [[NSMutableData alloc] init];
    self.outputBuffer = [[NSMutableData alloc] init];
    return YES;
}

- (void)close
{
    [self.inputStream  setDelegate:nil];
    [self.outputStream setDelegate:nil];
    [self.inputStream  close];
    [self.outputStream close];
    [self.inputStream  removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [(NSNotificationCenter *)[NSNotificationCenter defaultCenter] postNotificationName:ConnectionDidCloseNotification
                                                                                object:self];
}

- (void)startOutput
{
    NSLog(@"server: sending buffer");
    assert([self.outputBuffer length] != 0);
    
    NSInteger actuallyWritten = [self.outputStream write:[self.outputBuffer bytes] maxLength:[self.outputBuffer length]];
    if (actuallyWritten > 0) {
        //  [self.outputBuffer replaceBytesInRange:NSMakeRange(0, (NSUInteger) actuallyWritten) withBytes:NULL length:0];
        // If we didn't write all the bytes we'll continue writing them in response to the next
        // has-space-available event.
    } else {
        // A non-positive result from -write:maxLength: indicates a failure of some form; in this
        // simple app we respond by simply closing down our connection.
        //[self closeStreams];
    }
}

- (void)outputText:(NSString *)text
{
    NSLog(@"server sending string: %@", text);
    NSData * dataToSend = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (self.outputBuffer != nil) {
        
        BOOL wasEmpty = ([self.outputBuffer length] == 0);
        //NSLog(@"%d", wasEmpty);
        [self.outputBuffer appendData:dataToSend];
        if (wasEmpty) {
            NSLog(@"starting output");
            [self startOutput];
        }
    }
}


- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)streamEvent
{
    assert(aStream == self.inputStream || aStream == self.outputStream);
#pragma unused(aStream)
    
    switch (streamEvent)
    {
        case NSStreamEventHasBytesAvailable:
        {
            
            NSLog(@"server stream event Bytes available");
            
            uint8_t buffer[2048];
            NSInteger actuallyRead = [self.inputStream read:(uint8_t *)buffer maxLength:sizeof(buffer)];
            
            
            if (actuallyRead > 0)
            {
                [self.inputBuffer appendBytes:buffer length: (NSUInteger)actuallyRead];
                NSString *string = [[NSString alloc] initWithData:self.inputBuffer encoding:NSUTF8StringEncoding];
                [self.inputBuffer setLength: 0];
                
                // [self outputText: string];
                // CFRunLoopStop(CFRunLoopGetCurrent());
                
                //NSLog(@"writing");
                NSDictionary* userInfo = @{@"string": string};
                
                NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
                [nc postNotificationName:@"TestNotification" object:self userInfo:userInfo];
                
                //NSInteger actuallyWritten = [self.outputStream write:buffer maxLength:(NSUInteger)actuallyRead];
                /* NSLog(@"wrote");
                 
                 if (actuallyWritten != actuallyRead)
                 {
                 // -write:maxLength: may return -1 to indicate an error or a non-negative
                 // value less than maxLength to indicate a 'short write'.  In the case of an
                 // error we just shut down the connection.  The short write case is more
                 // interesting.  A short write means that the client has sent us data to echo but
                 // isn't reading the data that we send back to it, thus causing its socket receive
                 // buffer to fill up, thus causing our socket send buffer to fill up.  Again, our
                 // response to this situation is that we simply drop the connection.
                 NSLog(@"short write");
                 
                 [self close];
                 }
                 else
                 {
                 [NSThread sleepForTimeInterval:1.0];
                 //[self outputText:@"client recieved echo \r\n"];
                 NSLog(@"Echoed %zd bytes.", (ssize_t) actuallyWritten);
                 } */
            }
            else
            {
                // A non-positive value from -read:maxLength: indicates either end of file (0) or
                // an error (-1).  In either case we just wait for the corresponding stream event
                // to come through.
            }
        } break;
        case NSStreamEventEndEncountered:
            NSLog(@"server stream event event end");
            
        case NSStreamEventErrorOccurred:
        {
            NSLog(@"server stream event error");
            
            [self close];
        } break;
        case NSStreamEventHasSpaceAvailable:
            NSLog(@"space available");
            
        case NSStreamEventOpenCompleted:
        default:
        {
            // do nothing
        } break;
    }
}

@end