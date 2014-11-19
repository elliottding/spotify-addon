//
//  ParserTests.m
//  PlaylistManager
//
//  Created by Andrew Yang on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "Parser.h"
#import "User.h"
#import "SongRoom.h"
#import "Song.h"

@interface ParserTests : XCTestCase
{
    SongRoom *r;
    User *user1;
    User *user2;
    Song *song1;
    Song *song2;
}

@end

@implementation ParserTests

- (void)setUp
{
    [super setUp];
    r = [[SongRoom alloc] initWithName:@"songroom"];
    user1 = [[User alloc] initWithUsername:@"user1"];
    user2 = [[User alloc] initWithUsername:@"user2"];
    song1 = [[Song alloc] initWithTrackID:123];
    song2 = [[Song alloc] initWithTrackID:456];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_makeVoteString
{
    NSString * voteString = [Parser makeVoteString:@"user" updown:1 songURI:@"song1"];
    XCTAssertEqualObjects(@"VOTE:user:1:song1", voteString, @"Parser failed to create vote message");
}

- (void)test_makeQueueString
{
    NSString * queueString = [Parser makeQueueString:@"song1"];
    XCTAssertEqualObjects(@"QUEUE:song1", queueString, @"Parser failed to create queue message");
}

- (void)test_makeUpdateString
{
    NSString * upString = [Parser makeUpdateString];
    XCTAssertEqualObjects(@"UPDATE", upString, @"Parser failed to create update message");
}

- (void)test_makeSigninString
{
    NSString * signString = [Parser makeSigninString:@"user"];
    XCTAssertEqualObjects(@"SIGNIN:user", signString, @"Parser failed to create signin message");
}

- (void)test_makeSRStatusString
{
    NSJSONSerialization * statusString = [Parser makeSRStatusString:r];
    XCTAssertEqualObjects(@"UPSR:user1:SONGS:song1,0:song2,0", statusString, @"Parser failed to create status message");
    // SET THESE PROPERTIES IN TEST SONGROOM
    //
    //
    //
    //
}

- (void)test_makePlayNextString
{
    NSString * nextString = [Parser makePlayNextString];
    XCTAssertEqualObjects(@"NEWCS", nextString, @"Parser failed to create play next song message");
}

- (void)test_readString
{
    // test vote protocol
    NSMutableDictionary * d1 = [[dictionary alloc] init];
    [d1 setObject:@"VOTE" forkey:@"type"];
    [d1 setObject:@"user1" forkey:@"user"];
    [d1 setObject:1 forkey:@"updown"];
    [d1 setObject:@"song1" forkey:@"songURI"];
    XCTAssertEqualObjects(d1, [Parser readString:@"VOTE:user1:1:song1"], @"Failed to parse vote message");
    
    // test queue protocol
    NSMutableDictionary * d2 = [[dictionary alloc] init];
    [d2 setObject:@"QUEUE" forkey:@"type"];
    [d2 setObject:@"song2" forkey:@"songURI"];
    XCTAssertEqualObjects(d2, [Parser readString:@"QUEUE:song2"], @"Failed to parse queue message");

    // test update protocol
    NSMutableDictionary * d3 = [[dictionary alloc] init];
    [d3 setObject:@"UPDATE" forkey:@"type"];
    XCTAssertEqualObjects(d3, [Parser readString:@"UPDATE"], @"Failed to parse update message");
    
    // test signin protocol
    NSMutableDictionary * d4 = [[dictionary alloc] init];
    [d4 setObject:@"SIGNIN" forkey:@"type"];
    [d4 setObject:@"user2" forkey:@"username"];
    XCTAssertEqualObjects(d4, [Parser readString:@"SIGNIN:user2"], @"Failed to parse signin message");
    
    // test upsr protocol
    // NEED TO SET TEST DICTIONARY
    //
    //
    //
    //
    NSMutableDictionary * d5 = [[dictionary alloc] init];
    [d5 setObject:@"UPSR" forkey:@"type"];
    [d5 setObject: forkey:@"      "];
    XCTAssertEqualObjects(d5, [Parser readString:@"UPSR:user1:user2:SONGS:song1,0:song2,0"], @"Failed to parse upsr message");
    
    // test newcs protocol
    NSMutableDictionary * d6 = [[dictionary alloc] init];
    [d4 setObject:@"NEWCS" forkey:@"type"];
    XCTAssertEqualObjects(d4, [Parser readString:@"NEWCS"], @"Failed to parse newcs message");

}

@end
