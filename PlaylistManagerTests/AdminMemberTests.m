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
    [NSThread sleepForTimeInterval: 1.0];
    BOOL serverFound = false;
    for(NSNetService *it in testMember.services){
        if([it.name isEqualToString: @"Browser Find Test"]){
            serverFound = true;
        }
    }
    XCTAssert(serverFound, @"Browser did not find server");
}

- (void)testMemberConnectToService{
    [testAdmin startServer:@"Browser Find Test"];
    testMember = [[Member alloc] init];
    [testMember startBrowser];
    [NSThread sleepForTimeInterval: 1.0];
    BOOL serverFound = false;
    for(NSNetService *it in testMember.services){
        if([it.name isEqualToString: @"Browser Find Test"]){
            serverFound = true;
        }
    }

    
}





- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
