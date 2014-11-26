//
//  User.m
//  Playlist Manager
//
//  Created by Andrew Yang on 11/4/14.
//
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "User.h"

@interface UserTests : XCTestCase
{
    User *testUser1;
    User *testUser2;
}

@end

@implementation UserTests

- (void)setUp
{
    [super setUp];
    testUser1 = [[User alloc] initWithUsername:@"testname1"];
    testUser2 = [[User alloc] initWithUsername:@"testname2"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_initWithUsername
{
    XCTAssertEqualObjects(@"testname1", testUser1.username, @"User failed to properly initialize username");
}

@end