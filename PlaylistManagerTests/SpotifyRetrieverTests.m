//
//  SpotifyRetrieverTests.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>

#import "SpotifyRetriever.h"

@interface SpotifyRetrieverTests : XCTestCase

@end

@implementation SpotifyRetrieverTests

- (void)test_requestAlbum
{
    RequestAlbumCallback callback = ^(NSError *error, SPTAlbum *album)
    {
        XCTAssertNotNil(album, @"No album was retrieved.");
        XCTAssertEqualObjects(@"Feels Like Home", album.name, @"Retrieved album name does not match actual album name");
    };
    
    [[SpotifyRetriever instance] requestAlbum:@"4L1HDyfdGIkACuygktO7T7" callback:callback];
}

- (void)test_requestTrack
{
    RequestTrackCallback callback = ^(NSError *error, SPTTrack *track)
    {
        XCTAssertNotNil(track, @"No track was retrieved.");
        XCTAssertEqualObjects(@"One More Time", track.name, @"Retrieved track name does not match actual album name");
    };
    
    [[SpotifyRetriever instance] requestTrack:@"0DiWol3AO6WpXZgp0goxAV" callback:callback];
}

- (void)test_trackSearchByString
{
    NSString *trackName = @"One More Time";
    SearchCallback callback = ^(NSError *error, SPTListPage *listPage)
    {
        XCTAssertNotNil(listPage, @"Returned list was nil");
        SPTTrack *firstTrack = listPage.items[0];
        XCTFail();
        XCTAssertEqualObjects(trackName, firstTrack.name, @"Search did not return correct items");
    };
    
    [[SpotifyRetriever instance] trackSearchByString:trackName callback:callback];
}

@end
