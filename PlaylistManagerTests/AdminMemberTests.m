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

// RUN TESTS INDEPENDENTLY
// BECAUSE ALL OF THE TESTS START A NEW SERVER THERE CAN BE PROBLEMS
// ASSOCIATED WITH THREADS NOT CLEARING IF THE TESTS QUICKLY ENOUGH
// IF TESTS ARE RUN BACK TO BACK

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
    testAdmin.songRoom = testSongRoom;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    [testAdmin stopServer];
    testAdmin = nil;
    testMember = nil;
    testSongRoom = nil;
    
}

-(void)memberThread{
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    /*for(NSNetService *it in testMember.services){
     if([it.name isEqualToString: @"ConnectionTest"]){
     [testMember openStreamsToNetService: it];
     [[NSRunLoop currentRunLoop] run];
     }
     }*/
    testMember.connectTo = @"songroom";
    [testMember connect];
    NSLog(@"thread exited");
}

//NOTE: tests my fail due to concurrency. That is the other thread has not been given enough time to complete
// its assigned task. before assuming coding error increase the amount of time the current thread sleeps while
// the operation occurs in the other thread/threads

- (void)testAdminServerStart {
    [testAdmin startServer:@"start test"];
    [NSThread sleepForTimeInterval:1.0];// give time for other thread to start the server
    XCTAssert([testAdmin serverIsRunning], @"Server did not start properly");
}

- (void)testAdminServerStop {
    // This is an example of a functional test case.
    [testAdmin startServer:@"stop test"];
    [NSThread sleepForTimeInterval:1.0];
    XCTAssert([testAdmin serverIsRunning], @"Server not running can't be stopped");
    [testAdmin stopServer];
    [NSThread sleepForTimeInterval:1.0];
    
    XCTAssertFalse([testAdmin serverIsRunning], @"Server did not stop properly");
}

- (void)testMemberBrowse{
    [testAdmin startServer:@"Browser Find Test"];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 3.0];
    BOOL serverFound = false;
    NSMutableArray *services = [testMember currentServices];
    for(NSNetService *it in services){
        NSLog(@"%@", it.name);
        if([it.name isEqualToString: @"Browser Find Test"]){
            serverFound = true;
        }
    }
    XCTAssert(serverFound, @"Browser did not find server");
}

- (void)testMemberConnectToService{
    [testAdmin startServer:@"test songroom"];
    // [NSThread detachNewThreadSelector:@selector(memberThread) toTarget:self withObject:nil];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    testMember.connectTo = @"test songroom";
    [testMember connect];
    [NSThread sleepForTimeInterval:2.0];
    // NEED TO HAVE THESE SEPERATED BY some interval or queue will be recieved together
    //[testMember Vote:@"really cool song" withDirection:-1];
    [NSThread sleepForTimeInterval:0.5];
    //  [testMember QueueSong:@"7dS5EaCoMnN7DzlpT6aRn2"];
    
    [NSThread sleepForTimeInterval:0.5];
    
    //  [testMember Vote:@"7dS5EaCoMnN7DzlpT6aRn2" withDirection:-1];
    [NSThread sleepForTimeInterval:4.0];
    // [testMember outputText:@"my favorite song\r\n"];
    // [testMember outputText:@"my less favorite song\r\n"];
    
    
    //[NSThread sleepForTimeInterval: 20.0];
    
    XCTAssert([testMember.songRoom.name isEqualToString:@"test songroom"], @"songroom not sent over correctly");
    XCTAssert([testAdmin.songRoom containsUsername:@"test user"], @"User was not added to the songroom");
    XCTAssert([testMember.songRoom containsUsername:@"test user"], @"Did not add user to Songroom before sending back");
}

// These tests cannot be written until we have a better idea of what we will be using to queue songs
// at the moment we think it will be spotify URIs which we need to have a functional spotify frame work
// to find
// aditionally the vote for song and update song rely on creating song objects that rely on info from spotify
// We will not have this info until

- (void)testQueueSong{
    [testAdmin startServer:@"QueueTest"];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    testMember.connectTo = @"QueueTest";
    [testMember connect];
    
    [NSThread sleepForTimeInterval: 2.0];
    [testMember QueueSong:@"7dS5EaCoMnN7DzlpT6aRn2"];
    [NSThread sleepForTimeInterval: 1.0];
    XCTAssert(([testAdmin.songRoom.songQueue getIndexOfURI:@"7dS5EaCoMnN7DzlpT6aRn2"] >= 0), @"song not queued on Admin");
    XCTAssert(([testMember.songRoom.songQueue getIndexOfURI:@"7dS5EaCoMnN7DzlpT6aRn2"] >= 0), @"songroom not queued on members");
    
}


- (void)testVoteSong{
    [testAdmin startServer:@"VoteTest"];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 2.0];
    testMember.connectTo = @"VoteTest";
    [testMember connect];
    [NSThread sleepForTimeInterval: 4.0];
    [testMember QueueSong:@"7dS5EaCoMnN7DzlpT6aRn2"];
    [NSThread sleepForTimeInterval: 1.0];
    [testMember Vote:@"7dS5EaCoMnN7DzlpT6aRn2" withDirection:-1];
    [NSThread sleepForTimeInterval: 1.0];
    // seeing if the vote was registered for the admin
    XCTAssert(([testAdmin.songRoom.songQueue getIndexOfURI:@"7dS5EaCoMnN7DzlpT6aRn2"] >= 0), @"song not queued on Admin");
    int index =[testAdmin.songRoom.songQueue getIndexOfURI:@"7dS5EaCoMnN7DzlpT6aRn2"];
    Song *adminSong= testAdmin.songRoom.songQueue.songs[index];
    XCTAssert((adminSong.voteScore == -1), @"Vote not registered on host");
    // seeing if the vote was registered
    XCTAssert(([testMember.songRoom.songQueue getIndexOfURI:@"7dS5EaCoMnN7DzlpT6aRn2"] >= 0), @"song not queued on Admin");
    index =[testMember.songRoom.songQueue getIndexOfURI:@"7dS5EaCoMnN7DzlpT6aRn2"];
    Song *memberSong= testMember.songRoom.songQueue.songs[index];
    XCTAssert((memberSong.voteScore == -1), @"vote not transmitted back to user");
    
    
    
}

/*
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