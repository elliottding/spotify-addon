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

- (void)test_albumWithIdentifier
{
    RequestAlbumCallback callback = ^(NSError *error, SPTAlbum *album)
    {
        XCTAssertNotNil(album, @"No album was retrieved.");
        XCTAssertEqualObjects(@"Feels Like Home", album.name, @"Retrieved album name does not match actual album name");
    };
    
    [[SpotifyRetriever instance] requestAlbum:@"4L1HDyfdGIkACuygktO7T7" callback:callback];
}

@end
