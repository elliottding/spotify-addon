//
//  AdminMemberTests.m
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Admin.h"
#import "Member.h"

@interface AdminMemberTests : XCTestCase
{

    Admin *testAdmin;
    Member *testMember;
    SongRoom *testSongRoom;
}
@end

// this is designed to test the methods in memember and admin since they rely on a connection between
// each other we will test them together
// We only test the public methods of both of these classes because the private methods so closely
// linked with the public that it would be impractial to try to seperate these
// Keep in mind when looking at these tests that we currently plan for the member class to absorb
// the client class and just implent all of that in the background and we plan for the admin to
// hold a server and use that to carry out all of the operations

@implementation AdminMemberTests

- (void)setUp {
    [super setUp];
    testAdmin = [[Admin alloc] initWithUsername:@"test admin"];
    testMember = [[Member alloc] initWithUsername:@"test user"];
    testSongRoom = [[SongRoom alloc] initWithName:@"test songroom"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [testAdmin stopServer];
    testAdmin = nil;
    testMember = nil;
    testSongRoom = nil;
    
}

- (void)testAdminServerStart {
    // This is an example of a functional test case.
    [testAdmin startServer:@"start test"];
    XCTAssert(testAdmin.serverIsRunning, @"Server did not start properly");
}

- (void)testAdminServerStop {
    // This is an example of a functional test case.
    [testAdmin startServer:@"stop test"];
    [testAdmin stopServer];
    XCTAssertFalse(testAdmin.serverIsRunning, @"Server did not stop properly");
}

- (void)testMemberBrowse{
    [testAdmin startServer:@"Browser Find Test"];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    BOOL serverFound = false;
    for(NSNetService *it in testMember.services){
        if([it.name isEqualToString: @"Browser Find Test"]){
            serverFound = true;
        }
    }
    XCTAssert(serverFound, @"Browser did not find server");
}

- (void)testMemberConnectToService{
    [testAdmin startServer:@"ConnectionTest"];
    testMember = [[Member alloc] init];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    for(NSNetService *it in testMember.services){
        if([it.name isEqualToString: @"ConnectionTest"]){
            [testMember openStreamsToNetService: it];
        }
    }
    [NSThread sleepForTimeInterval: 4.0];
    XCTAssert([testMember.songRoom.name isEqualToString:@"test songroom"], @"songroom not sent over correctly");
    XCTAssert([testAdmin.songRoom containsUsername:@"test user"], @"User was not added to the songroom");
    XCTAssert([testMember.songRoom containsUsername:@"test user"], @"Did not add user to Songroom before sending back");
}

// These tests cannot be written until we have a better idea of what we will be using to queue songs
// at the moment we think it will be spotify URIs which we need to have a functional spotify frame work
// to find
// aditionally the vote for song and update song rely on creating song objects that rely on info from spotify
// We will not have this info until 
/*
- (void)testQueueSong{
    [testAdmin startServer:@"ConnectionTest"];
    testMember = [[Member alloc] init];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    for(NSNetService *it in testMember.services){
        if([it.name isEqualToString: @"ConnectionTest"]){
            [testMember openStreamsToNetService: it];
        }
    }
    [NSThread sleepForTimeInterval: 4.0];
    [testMember QueueSong:
    XCTAssert([testMember.songRoom.name isEqualToString:@"test songroom"], @"songroom not sent over correctly");
    XCTAssert([testMember.songRoom containsUsername:@"test user"], @"Did not add user to Songroom before sending back");
}
 
 
 -testVoteSong{
 
 }
 
 -tetsUpdateCurrentSongPlaying{
 }
*/







- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end