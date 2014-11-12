//
//  SongQueueTests.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/11/14.
//
//

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>

#import "SongQueue.h"

@interface SongQueueTests : XCTestCase
{
    SongQueue *q;
    Song *song1;
    Song *song2;
    Song *song3;
    Song *song4;
    User *user1;
    User *user2;
    User *user3;
}

@end

@implementation SongQueueTests

- (void)setUp
{
    [super setUp];
    q = [[SongQueue alloc] init];
    song1 = [[Song alloc] initWithTrackID:1];
    song2 = [[Song alloc] initWithTrackID:2];
    song3 = [[Song alloc] initWithTrackID:3];
    song4 = [[Song alloc] initWithTrackID:4];
    user1 = [[User alloc] initWithUsername:@"user1"];
    user2 = [[User alloc] initWithUsername:@"user2"];
    user3 = [[User alloc] initWithUsername:@"user3"];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_init
{
    XCTAssertNotNil(q.preferredQueue, @"preferredQueue was nil after initialization");
    XCTAssertNil(q.nextSong, @"nextSong should be nil after initialization");
}

- (void)test_addSong
{
    [q addSong:song1];
    [q addSong:song2];
    XCTAssertEqualObjects(song1, q.nextSong, @"nextSong should be first added song in the event of a vote tie");
    
    [song3.voteBox setVoteScore:1 forUser:user1];
    [q addSong:song3];
    XCTAssertEqualObjects(song3, q.nextSong, @"nextSong should be song with highest vote score");
}

- (void)test_moveToPreferred
{
    [song1.voteBox setVoteScore:1 forUser:user1];
    [q addSong:song1];
    [q addSong:song2];
    [q moveToPreferred:song2];
    XCTAssertFalse([q containsSong:song2], @"song2 was not removed from regular queue");
    XCTAssert([q.preferredQueue containsSong:song2], @"song2 was not found in preferred queue");
    XCTAssertEqualObjects(song2, q.nextSong, @"preferred songs should have priority over all non-preferred songs");
    
    [q moveToPreferred:song3];
    XCTAssertFalse([q containsSong:song2], @"song2 was not removed from regular queue");
    XCTAssert([q.preferredQueue containsSong:song2], @"song2 was not found in preferred queue");
    XCTAssertEqualObjects(song2, q.nextSong, @"top song should remain unchanged");
}

- (void)test_moveToPreferred_toIndex
{
    [q moveToPreferred:song1];
    [q moveToPreferred:song2 toIndex:0];
    XCTAssertEqualObjects(song2, q.nextSong, @"song2 was moved to front of preferred queue and should be the next song");
    
    [q moveToPreferred:song3 toIndex:1];
    XCTAssertEqualObjects(song3, q.preferredQueue[1], @"song3 was not moved to the correct index in the preferred queue");
}

- (void)test_removeSong
{
    [q addSong:song1];
    [q addSong:song2];
    [q removeSong:song1];
    XCTAssertEqualObjects(song2, q.nextSong, @"only song in the queue is not the next song");
    XCTAssertEqual(1, q.count, @"count incorrect");
    XCTAssertFalse([q containsSong:song1], @"song1 found in queue even though it was removed");
    
    [q removeSong:song3];
    XCTAssertEqualObjects(song2, q.nextSong, @"only song in the queue is not the next song");
    XCTAssertEqual(1, q.count, @"count incorrect");
}

- (void)test_removeSongAtIndex
{
    [q addSong:song1];
    [q addSong:song2];
    [q removeSongAtIndex:1];
    XCTAssertEqualObjects(song1, q.nextSong, @"only song in the queue is not the next song");
    XCTAssertEqual(1, q.count, @"count incorrect");
    XCTAssertFalse([q containsSong:song2], @"song2 found in queue even though it was removed");
    
    [q removeSongAtIndex:4];
    XCTAssertEqualObjects(song1, q.nextSong, @"only song in the queue is not the next song");
    XCTAssertEqual(1, q.count, @"count incorrect");
}

- (void)test_removeTopSong
{
    [q addSong:song1];
    [q addSong:song2];
    [q removeTopSong];
    XCTAssertEqualObjects(song2, q.nextSong, @"only song in the queue is not the next song");
    XCTAssertEqual(1, q.count, @"count incorrect");
    XCTAssertFalse([q containsSong:song1], @"song1 found in queue even though it was removed");
    
    [q moveToPreferred:song3];
    [q removeTopSong];
    XCTAssertEqualObjects(song2, q.nextSong, @"only song in the queue is not the next song");
    XCTAssertEqual(1, q.count, @"count incorrect");
    XCTAssertFalse([q.preferredQueue containsSong:song3], @"song3 found in queue even though it was removed");
}

- (void)test_automaticSorting
{
    [q addSong:song1];
    [q addSong:song2];
    [q addSong:song3];
    [song2.voteBox setVoteScore:1 forUser:user1];
    XCTAssertEqualObjects(song2, q.nextSong, @"song2 has most votes and should be next song");
    XCTAssertEqualObjects(song1, q[1], @"song1 should be after next song");
    
    [song3.voteBox setVoteScore:2 forUser:user1];
    XCTAssertEqualObjects(song3, q.nextSong, @"song3 has most votes and should be next song");
    XCTAssertEqualObjects(song2, q[1], @"song2 should be after next song");
    
    [song3.voteBox setVoteScore:-5 forUser:user2];
    XCTAssertEqualObjects(song2, q.nextSong, @"song2 has most votes and should be next song");
    XCTAssertEqualObjects(song1, q[1], @"song1 should be after next song");
}

@end
