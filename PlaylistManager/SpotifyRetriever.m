//
//  SpotifyRequestManager.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SpotifyRetriever.h"

@interface SpotifyRetriever ()

// Stores the most recently requested item.
@property (nonatomic, strong) id requestedItem;

@property (nonatomic) bool requestFailed;

@end

@implementation SpotifyRetriever

// Multithread-safe singleton instance
+ (instancetype)instance
{
    static SpotifyRetriever *singleInstance = nil;
    static dispatch_once_t onceToken;
    
    // Ensure that singleInstance is initialized only once across all threads
    dispatch_once(&onceToken, ^
                  {
                      singleInstance = [[self alloc] initPrivate];
                  });
    return singleInstance;
}

// Construct a Spotify URI from the given identifier and item type string.
+ (NSURL *)spotifyURIFromIdentifier:(NSString *)identifier withTypeString:(NSString *)typeString
{
    NSString *uriString = [NSString stringWithFormat:@"spotify:%@:%@", typeString, identifier];
    return [NSURL URLWithString:uriString];
}

// Throws an error if caller attempts to initialize normally
- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Init"
                                   reason:@"Attempted to initialize a new instance of singleton SpotifyRetriever."
                                 userInfo:nil];
    return nil;
}

// Working initializer that is only available privately
- (instancetype)initPrivate
{
    self = [super init];
    if (self)
    {
        self.session = nil;
        self.timeOutInterval = 10;
        self.requestedItem = nil;
        self.requestFailed = false;
    }
    return self;
}

- (void)handleRequestedItem:(id)item withError:(NSError *)error
{
    if (error != nil)
    {
        NSLog(@"*** Spotify request failed with error: %@", error);
        self.requestedItem = nil;
    }
    self.requestedItem = item;
}

- (id)itemAtURI:(NSURL *)uri
{
    void (^requestCallback) (NSError *, id);
    requestCallback = ^(NSError *error, id item)
    {
        [self handleRequestedItem:item withError:error];
    };
    [SPTRequest requestItemAtURI:uri withSession:self.session callback:requestCallback];
    return self.requestedItem;
}

- (void)requestAlbum:(NSString *)identifier callback:(RequestAlbumCallback)callback
{
    NSURL *uri = [[self class] spotifyURIFromIdentifier:identifier withTypeString:@"album"];
    [SPTRequest requestItemAtURI:uri withSession:self.session callback:callback];
}

- (void)requestTrack:(NSString *)identifier callback:(RequestTrackCallback)callback
{
    NSURL *uri = [[self class] spotifyURIFromIdentifier:identifier withTypeString:@"track"];
    [SPTRequest requestItemAtURI:uri withSession:self.session callback:callback];
}

- (void)requestTestTrack:(RequestTrackCallback)callback
{
    [self requestTrack:@"0DiWol3AO6WpXZgp0goxAV" callback:callback];
}

- (void)trackSearchByString:(NSString *)searchString callback:(SearchCallback)callback
{
    searchString = [searchString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    // NSString *query = [NSString stringWithFormat:@"q=%@&type=track", searchString];
    NSString *query = [NSString stringWithFormat:@"%@", searchString];
    [SPTRequest performSearchWithQuery:query
                             queryType:SPTQueryTypeTrack
                                offset:0
                               session:self.session
                              callback:callback];
}

- (SPTAlbum *)albumWithIdentifier:(NSString *)identifier
{
    NSURL *uri = [[self class] spotifyURIFromIdentifier:identifier withTypeString:@"album"];
    NSLog(@"*** uri: %@", uri);
    return [self itemAtURI:uri];
}

- (SPTTrack *)trackWithIdentifier:(NSString *)identifier
{
    NSURL *uri = [[self class] spotifyURIFromIdentifier:identifier withTypeString:@"track"];
    return [self itemAtURI:uri];
}

@end
