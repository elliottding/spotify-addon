//
//  SongTests.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/4/14.
//
//

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>

#import "Song.h"

int const trackID1 = 1234;

@interface SongTests : XCTestCase
{
    Song *song1;
}

@end

@implementation SongTests

- (void)setUp
{
    [super setUp];
    song1 = [[Song alloc] initWithTrackID:trackID1];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_initWithTrackID
{
    XCTAssertEqual(trackID1, song1.trackID, @"Track ID not properly set in initialization");
}

@end
