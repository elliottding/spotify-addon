//
//  SpotifyRequestManager.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Spotify/Spotify.h>

@interface SpotifyRetriever : NSObject

typedef void (^RequestAlbumCallback) (NSError *error, SPTAlbum *album);

// An authenticated Spotify session to request with. Can be nil.
@property (nonatomic, strong) SPTSession *session;

@property (nonatomic) NSTimeInterval timeOutInterval;

// Retrieves the singleton instance of this class.
+ (instancetype)instance;

// Requests an album from Spotify with the specified identifier, and executes the callback upon completion.
- (void)requestAlbum:(NSString *)identifier callback:(RequestAlbumCallback)callback;

// Retrieves a SPTAlbum with the specified identifier from the Spotify service.
- (SPTAlbum *)albumWithIdentifier:(NSString *)identifier;

// Retrieves a SPTTrack with the specified identifier from the Spotify service.
- (SPTTrack *)trackWithIdentifier:(NSString *)identifier;

@end
