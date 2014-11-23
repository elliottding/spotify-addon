//
//  ServerTests.m
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/12/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Client.h"
#import "Server.h"
#import "ServerConnection.h"

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Client.h"
#import "Server.h"
#import "ServerConnection.h"
#import "User.h"
#import "Admin.h"

@interface ServerTests : XCTestCase
{
    // hold the server so it can be broken down between tests
    Server *currentServer;
    Client *otherClient;
    User *testuser;
    Admin *testAdmin;
}

- (void)serverThread;

@end

///////////////////////////////////////////////////////////////////////////////////////////////
// THESE TESTS ARE TEMPORARY:
// These tests are currently designed solely for the first iteration
// to show that our server can currently create a connection with a client(or clients) and
// communicate bytes over that connection in both directions
// Currently it does this by sending an echo from the client to the server and expecting
// the proper response back
// this is the basic infrastructure that we will leverage in the next iteration to allow
// users to connect to a songroom, vote for songs, queue song, and potentially more
////////////////////////////////////////////////////////////////////////////////////////////

@implementation ServerTests

- (void)serverThread
{
    currentServer = [[Server alloc] init];
    if ([currentServer startWithName:@"songroom" WithHost:testuser])
    {
        NSLog(@"Started server on port %zu.", (size_t) [currentServer port]);
        [[NSRunLoop currentRunLoop] run];
    }
    else
    {
        NSLog(@"Error starting server");
    }
}

- (void)startAnotherClientThread
{
    otherClient = [[Client alloc] init];
    otherClient.message = @"single client\r\n";
    otherClient.connectTo = @"songroom"; // the name of our server thread
    [otherClient startBrowser];
    [NSThread sleepForTimeInterval:2.0];
    [otherClient connect];
    /*
     for(NSNetService *it in otherClient.services){
     if([it.name isEqualToString: @"songroom"]){
     [otherClient openStreamsToNetService: it];
     // [[NSRunLoop currentRunLoop] run];
     
     }
     }
     */
    NSLog(@"probably shouldn't be here");
    [NSThread sleepForTimeInterval: 5.0];
    
}

// This implementation
- (void)setUp
{
    [super setUp];
    // we start a 2nd thread to manage the server. The thread here will act as a client and send
    // a string to the server and expect a response
    //[NSThread detachNewThreadSelector:@selector(serverThread) toTarget:self withObject:nil];
    // [NSThread detachNewThreadSelector:@selector(startAnotherClientThread) toTarget:self withObject:nil];
    testAdmin = [[Admin alloc] initWithUsername:@"test admin"];
    
}

- (void)tearDown
{
    // server must be stopped between tests otherwise is will cause the creation of 2 servers
    // which will fail
    [currentServer stop];
    [super tearDown];
}

// NOTE: This test will fail if data was not transferred within 10 seconds.
- (void)test_singleClient
{
    [NSThread detachNewThreadSelector:@selector(startAnotherClientThread) toTarget:self withObject:nil];
    /*
     currentServer = [[Server alloc] init];
     
     // Set server run loop to terminate after 10 seconds
     NSDate *loopEndDate = [NSDate dateWithTimeInterval:10 sinceDate:[NSDate date]];
     
     if ([currentServer startWithName:@"songroom" WithHost:testuser])
     {
     NSLog(@"Started server on port %zu.", (size_t) [currentServer port]);
     // [[NSRunLoop currentRunLoop] run];
     [[NSRunLoop currentRunLoop] runUntilDate:loopEndDate];
     }
     else
     {
     NSLog(@"Error starting server");
     }
     */
    [testAdmin startServer:@"songroom"];
    [NSThread sleepForTimeInterval:8.0];
    XCTAssert([otherClient.response isEqualToString:@"single client\r\n"], @"bytes not transferred successfully");
}

@end