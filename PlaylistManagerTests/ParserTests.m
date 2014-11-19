//
//  ParserTests.m
//  PlaylistManager
//
//  Created by Andrew Yang on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
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
    song1 = [[Song alloc] initWithTrackID:123 andTrack:nil];
    song2 = [[Song alloc] initWithTrackID:456 andTrack:nil];
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
    NSMutableDictionary * d1 = [[NSDictionary alloc] init];
    [d1 setObject:@"VOTE" forKey:@"type"];
    [d1 setObject:@"user1" forKey:@"user"];
    [d1 setObject:1 forKey:@"updown"];
    [d1 setObject:@"song1" forKey:@"songURI"];
    XCTAssertEqualObjects(d1, [Parser readString:@"VOTE:user1:1:song1"], @"Failed to parse vote message");
    
    // test queue protocol
    NSMutableDictionary * d2 = [[NSDictionary alloc] init];
    [d2 setObject:@"QUEUE" forKey:@"type"];
    [d2 setObject:@"song2" forKey:@"songURI"];
    XCTAssertEqualObjects(d2, [Parser readString:@"QUEUE:song2"], @"Failed to parse queue message");
    
    // test update protocol
    NSMutableDictionary * d3 = [[NSDictionary alloc] init];
    [d3 setObject:@"UPDATE" forKey:@"type"];
    XCTAssertEqualObjects(d3, [Parser readString:@"UPDATE"], @"Failed to parse update message");
    
    // test signin protocol
    NSMutableDictionary * d4 = [[NSDictionary alloc] init];
    [d4 setObject:@"SIGNIN" forKey:@"type"];
    [d4 setObject:@"user2" forKey:@"username"];
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