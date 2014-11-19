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
    XCTAssertEqualObjects(      , statusString, @"Parser failed to create status message");
}

- (void)test_makePlayNextString
{
    NSString * nextString = [Parser makePlayNextString];
    XCTAssertEqualObjects(@"NEWCS", nextString, @"Parser failed to create play next song message");
}

- (void)test_readString
{
    
    // Test if strings can be parsed to call other methods
    /* TODO:
     1. Vote message creates a vote
     2. Queue message adds a song to the queue
     3. Update message results in an update
     4. Signin message adds a user to the songroom
     5. SRStatus message updates songroom
     6. PlayNext message plays next song
     */
}

@end
