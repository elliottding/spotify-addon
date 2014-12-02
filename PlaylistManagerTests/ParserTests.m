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
#import "SongQueue.h"
#import "Song.h"

@interface ParserTests : XCTestCase
{
    SongRoom *r;
    SongQueue *sq;
    User *user1;
    User *user2;
    Song *song1;
    Song *song2;
    Song *song3;
}

@end

@implementation ParserTests

- (void)setUp
{
    [super setUp];
    r = [[SongRoom alloc] initWithName:@"songroom"];
    r.songQueue = [[SongQueue alloc] init];
    user1 = [[User alloc] initWithUsername:@"user1"];
    user2 = [[User alloc] initWithUsername:@"user2"];
    //song1 = [[Song alloc] initWithTrackID:123 andTrack:nil];
    //song2 = [[Song alloc] initWithTrackID:456 andTrack:nil];
    song1 = [[Song alloc] initWithIdentifier:@"7dS5EaCoMnN7DzlpT6aRn2"];
    song2 = [[Song alloc] initWithIdentifier:@"1aKsg5b9sOngINaQXbB0P7"];
    song3 = [[Song alloc] initWithIdentifier:@"hist"];
    [r registerUser:user1];
    [r.songQueue addSong:song1];
    [r.songQueue addSong:song2];
    [r.historyQueue addObject:song3];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test_makeVoteString
{
    NSString *voteString = [Parser makeVoteString:@"user" updown:1 songURI:@"song1"];
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
    NSString *statusString = [Parser makeSongRoomStatusString:r];
    XCTAssertEqualObjects(@"UPSR:user1:PSONGS:RSONGS:7dS5EaCoMnN7DzlpT6aRn2,0:1aKsg5b9sOngINaQXbB0P7,0:HIST:hist", statusString, @"Parser failed to create status message");
}

- (void)test_makePlayNextString
{
    NSString * nextString = [Parser makePlayNextString];
    XCTAssertEqualObjects(@"NEWCS", nextString, @"Parser failed to create play next song message");
}

- (void)test_readString
{
    // test vote protocol
    NSMutableDictionary *d1 = [[NSMutableDictionary alloc] init];
    [d1 setObject:@"VOTE" forKey:@"type"];
    [d1 setObject:@"user1" forKey:@"username"];
    [d1 setObject:@1 forKey:@"updown"];
    [d1 setObject:@"song1" forKey:@"songURI"];
    XCTAssertEqualObjects(d1, [Parser readString:@"VOTE:user1:1:song1"], @"Failed to parse vote message");
    
    // test queue protocol
    NSMutableDictionary *d2 = [[NSMutableDictionary alloc] init];
    [d2 setObject:@"QUEUE" forKey:@"type"];
    [d2 setObject:@"song2" forKey:@"songURI"];
    //XCTAssertEqualObjects(d2, [Parser readString:@"QUEUE:song2"], @"Failed to parse queue message");
    
    // test update protocol
    NSMutableDictionary *d3 = [[NSMutableDictionary alloc] init];
    [d3 setObject:@"UPDATE" forKey:@"type"];
    XCTAssertEqualObjects(d3, [Parser readString:@"UPDATE"], @"Failed to parse update message");
    
    // test signin protocol
    NSMutableDictionary *d4 = [[NSMutableDictionary alloc] init];
    [d4 setObject:@"SIGNIN" forKey:@"type"];
    [d4 setObject:@"user2" forKey:@"username"];
    XCTAssertEqualObjects(d4, [Parser readString:@"SIGNIN:user2"], @"Failed to parse signin message");
    
    // test upsr protocol
    NSMutableDictionary *d5 = [[NSMutableDictionary alloc] init];
    [d5 setObject:@"UPSR" forKey:@"type"];
    NSMutableArray *users = [[NSMutableArray alloc] init];
    //changed this
    NSMutableDictionary *prefsongs = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *regsongs = [[NSMutableDictionary alloc] init];
    NSMutableArray *history = [[NSMutableArray alloc] init];
    //until here
    [d5 setObject:users forKey:@"users"];
    [d5 setObject:prefsongs forKey:@"prefsongs"];
    [d5 setObject:regsongs forKey:@"regsongs"];
    [d5 setObject:history forKey:@"history"];
        //test empty songroom
    XCTAssertEqualObjects(d5, [Parser readString:@"UPSR:PSONGS:RSONGS:HIST"], @"Failed to parse upsr message for empty songroom");
    [users addObject:@"user1"];
    [users addObject:@"user2"];
    [prefsongs setObject:@0 forKey: @"7dS5EaCoMnN7DzlpT6aRn2"];
    [regsongs setObject:@1 forKey: @"1aKsg5b9sOngINaQXbB0P7"];
    [history setObject:@"song3" atIndexedSubscript:0];
    [d5 setObject:users forKey: @"users"];
    [d5 setObject:prefsongs forKey: @"prefsongs"];
    [d5 setObject:regsongs forKey: @"regsongs"];
    [d5 setObject:history forKey:@"history"];
        //test songroom with users and songs
    XCTAssertEqualObjects(d5, [Parser readString:@"UPSR:user1:user2:PSONGS:7dS5EaCoMnN7DzlpT6aRn2,0:RSONGS:1aKsg5b9sOngINaQXbB0P7,1:HIST:song3"], @"Failed to parse upsr message for active songroom");
    
    // test newcs protocol
    NSMutableDictionary *d6 = [[NSMutableDictionary alloc] init];
    [d6 setObject:@"NEWCS" forKey:@"type"];
    XCTAssertEqualObjects(d6, [Parser readString:@"NEWCS"], @"Failed to parse newcs message");
}
@end