// TutorialApp
// Created by Spotify on 04/09/14.
// Copyright (c) 2014 Spotify. All rights reserved.

#import <Spotify/Spotify.h>
#import "AppDelegate.h"

#import "Admin.h"
#import "SongQueue.h"

#import "PlaylistTableViewController.h"
#import "SelectPlaylistTableViewController.h"
#import "SpotifyRetriever.h"

// Constants
static NSString * const kClientId = @"3168ef4060a84063a872200bf82dad3a";
static NSString * const kCallbackURL = @"spotifyiossdkexample://"; // @"CS22001-app-login://callback";
static NSString * const kTokenSwapServiceURL = @"http://localhost:1234/swap";

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) SPTAudioStreamingController *audioStreamingController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set up a song queue for testing
    [self loginToSpotifyWithApplication:application];
    return YES;
}

// Handle auth callback
- (BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    
    // Ask SPTAuth if the URL given is a Spotify authentication callback
    if (![auth canHandleURL:url withDeclaredRedirectURL:[NSURL URLWithString:kCallbackURL]])
    {
        NSLog(@"*** Auth URL is invalid");
        return NO;
    }
    NSLog(@"Auth URL is valid");
    
    void (^authCallback) (NSError *, SPTSession *);
    authCallback = ^(NSError *error, SPTSession *session)
    {
        if (error != nil)
        {
            NSLog(@"*** Auth error: %@", error);
            return;
        }
        NSLog(@"Auth success");
        [self playUsingSession:session];
        [SpotifyRetriever instance].session = session;
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.rootViewController = [[SelectPlaylistTableViewController alloc] init];
        [self.window makeKeyAndVisible];
        
    };
    
    // Call the token swap service to get a logged in session
    [auth handleAuthCallbackWithTriggeredAuthURL:url
                   tokenSwapServiceEndpointAtURL:[NSURL URLWithString:kTokenSwapServiceURL]
                                        callback:authCallback];
    return YES;
}

// Perform Spotify login
- (void)loginToSpotifyWithApplication:(UIApplication *)application
{
    SPTAuth *auth = [SPTAuth defaultInstance];
    NSURL *loginURL = [auth loginURLForClientId:kClientId
                            declaredRedirectURL:[NSURL URLWithString:kCallbackURL]
                                         scopes:@[SPTAuthStreamingScope]];
    
    // Opening a URL in Safari close to application launch may trigger
    // an iOS bug, so we wait a bit before doing so.
    [application performSelector:@selector(openURL:) withObject:loginURL afterDelay:0.1];
}

- (void)playUsingSession:(SPTSession *)session
{
    // Create a new player if needed
    if (self.audioStreamingController == nil)
    {
        self.audioStreamingController = [SPTAudioStreamingController new];
    }
    
    void (^requestCallback) (NSError *, SPTAlbum *);
    requestCallback = ^(NSError *error, SPTAlbum *album)
    {
        NSLog(@"Album: %@", album);
        if (error != nil)
        {
            NSLog(@"*** URI request error: %@", error);
            return;
        }
    };
    
    [SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:4L1HDyfdGIkACuygktO7T7"]
                     withSession:nil
                        callback:requestCallback];
    
    /*
    void (^loginCallback) (NSError *);
    loginCallback = ^(NSError *error)
    {
        if (error != nil)
        {
            NSLog(@"*** Enabling playback got error: %@", error);
            return;
        }
        
        [SPTRequest requestItemAtURI:[NSURL URLWithString:@"spotify:album:4L1HDyfdGIkACuygktO7T7"]
                         withSession:nil
                            callback:requestCallback];
    };
    
    [self.streamingController loginWithSession:session callback:loginCallback];
    */
}

@end
