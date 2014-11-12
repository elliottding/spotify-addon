//
//  UnsortedSongQueueTests.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/11/14.
//
//

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>

#import "UnsortedSongQueue.h"

@interface UnsortedSongQueueTests : XCTestCase
{
    UnsortedSongQueue *queue1;
    Song *song1;
    Song *song2;
    Song *song3;
    Song *song4;
}

@end

@implementation UnsortedSongQueueTests

- (void)setUp
{
    [super setUp];
    queue1 = [[UnsortedSongQueue alloc] init];
    song1 = [[Song alloc] initWithTrackID:1];
    song2 = [[Song alloc] initWithTrackID:2];
    song3 = [[Song alloc] initWithTrackID:3];
    song4 = [[Song alloc] initWithTrackID:4];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_init
{
    XCTAssertNil(queue1.nextSong, @"nextSong should be nil upon initialization");
    XCTAssertEqual(0, queue1.count, @"count should be 0 as the queue contains no songs");
}

- (void)test_appendSong
{
    [queue1 appendSong:song1];
    XCTAssertEqualObjects(song1, queue1.nextSong, @"nextSong should not be nil when queue is not empty");
    XCTAssertEqual(1, queue1.count, @"count incorrect");
    
    [queue1 appendSong:song2];
    XCTAssertEqualObjects(song1, queue1.nextSong, @"nextSong should be the first song that was appended");
    XCTAssertEqual(2, queue1.count, @"count incorrect");
}

- (void)test_getIndexOfSong
{
    [queue1 appendSong:song1];
    [queue1 appendSong:song2];
    [queue1 appendSong:song3];
    XCTAssertEqual(0, [queue1 getIndexOfSong:song1], @"song1 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(2, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
    XCTAssertEqual(-1, [queue1 getIndexOfSong:song4], @"song4 is not in queue; should return -1");
}

- (void)test_insertSong_atIndex
{
    for (int i = 0; i < 6; i++)
    {
        [queue1 appendSong:song4];
    }
    [queue1 insertSong:song1 atIndex:4];
    [queue1 insertSong:song2 atIndex:2];
    [queue1 insertSong:song3 atIndex:5];
    // Should now be 6, since two songs were inserted before it
    XCTAssertEqual(6, [queue1 getIndexOfSong:song1], @"song1 index incorrect");
    XCTAssertEqual(2, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(5, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
}

- (void)test_moveSong_toIndex
{
    [queue1 insertSong:song1 atIndex:0];
    [queue1 insertSong:song2 atIndex:1];
    [queue1 insertSong:song3 atIndex:2];
    
    [queue1 moveSong:song1 toIndex:2];
    XCTAssertEqual(2, [queue1 getIndexOfSong:song1], @"song1 index incorrect");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
    
    [queue1 moveSong:song3 toIndex:0];
    XCTAssertEqual(2, [queue1 getIndexOfSong:song1], @"song1 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
}

- (void)test_moveSongAtIndex_toIndex
{
    [queue1 insertSong:song1 atIndex:0];
    [queue1 insertSong:song2 atIndex:1];
    [queue1 insertSong:song3 atIndex:2];
    
    [queue1 moveSongAtIndex:0 toIndex:2];
    XCTAssertEqual(2, [queue1 getIndexOfSong:song1], @"song1 index incorrect");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
    
    [queue1 moveSongAtIndex:1 toIndex:0];
    XCTAssertEqual(2, [queue1 getIndexOfSong:song1], @"song1 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
}

- (void)test_removeSong
{
    [queue1 insertSong:song1 atIndex:0];
    [queue1 insertSong:song2 atIndex:1];
    [queue1 insertSong:song3 atIndex:2];
    
    [queue1 removeSong:song1];
    XCTAssertEqual(2, queue1.count, @"song count incorrect");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
    XCTAssertEqual(-1, [queue1 getIndexOfSong:song1], @"song1 is not in queue; should return -1");
    
    [queue1 removeSong:song4];
    XCTAssertEqual(2, queue1.count, @"song count incorrect; should have remained unchanged");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
}

- (void)test_removeSong_atIndex
{
    [queue1 insertSong:song1 atIndex:0];
    [queue1 insertSong:song2 atIndex:1];
    [queue1 insertSong:song3 atIndex:2];
    
    [queue1 removeSongAtIndex:0];
    XCTAssertEqual(2, queue1.count, @"song count incorrect");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
    XCTAssertEqual(-1, [queue1 getIndexOfSong:song1], @"song1 is not in queue; should return -1");
    
    /*
    [queue1 removeSongAtIndex:4];
    XCTAssertEqual(2, queue1.count, @"song count incorrect; should have remained unchanged");
    XCTAssertEqual(0, [queue1 getIndexOfSong:song2], @"song2 index incorrect");
    XCTAssertEqual(1, [queue1 getIndexOfSong:song3], @"song3 index incorrect");
    */
}

- (void)test_objectAtIndexedSubscript
{
    [queue1 insertSong:song1 atIndex:0];
    [queue1 insertSong:song2 atIndex:1];
    [queue1 insertSong:song3 atIndex:2];
    XCTAssertEqualObjects(song2, queue1[1], @"Subscripting did not return correct song");
}

- (void)test_setObject_atIndexedSubscript
{
    [queue1 insertSong:song1 atIndex:0];
    [queue1 insertSong:song2 atIndex:1];
    [queue1 insertSong:song3 atIndex:2];
    queue1[1] = song1;
    XCTAssertEqualObjects(song1, queue1[1], @"Subscripting did not set correct song");
}

@end
