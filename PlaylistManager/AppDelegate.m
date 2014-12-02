// TutorialApp
// Created by Spotify on 04/09/14.
// Copyright (c) 2014 Spotify. All rights reserved.

#import <Spotify/Spotify.h>
#import "AppDelegate.h"

#import "Admin.h"
#import "SongQueue.h"

#import "TabBarController.h"
#import "SelectPlaylistTableViewController.h"
#import "SpotifyRetriever.h"

#import "Member.h"
#import "Admin.h"

// Constants
static NSString * const kClientId = @"3168ef4060a84063a872200bf82dad3a";
static NSString * const kCallbackURL = @"spotifyiossdkexample://"; // @"CS22001-app-login://callback";
static NSString * const kTokenSwapServiceURL = @"http://localhost:1234/swap";

@interface AppDelegate ()

@property (nonatomic, strong, readwrite) SPTAudioStreamingController *audioStreamingController;
@property (nonatomic, strong) Admin *testAdmin;

@end

@implementation AppDelegate

- (SongRoom *)createTestRoom
{
    // Set up test song room
    NSArray *trackIdentifiers = @[@"7dS5EaCoMnN7DzlpT6aRn2",
                                  @"1aKsg5b9sOngINaQXbB0P7",
                                  @"2woCw59DHRIb1vcyQ2a7Ca",
                                  @"4O594chXfv4lHvneDP0Ud0",
                                  @"7pJgjBf82BrUQ3z7HdQvW1",
                                  @"2Bs4jQEGMycglOfWPBqrVG",
                                  @"18AJRdgUoO9EYn11N7xzaT",
                                  @"7IHOIqZUUInxjVkko181PB"];
    SongQueue *songQueue = [[SongQueue alloc] init];
    for (int i = 0; i < 3; i++)
    {
        Song *song = [[Song alloc] initWithIdentifier:trackIdentifiers[i]];
        [songQueue.preferredQueue appendSong:song];
    }
    for (int i = 3; i < trackIdentifiers.count; i++)
    {
        Song *song = [[Song alloc] initWithIdentifier:trackIdentifiers[i]];
        [songQueue addSong:song];
    }
    SongRoom *songRoom = [[SongRoom alloc] initWithName:@"Test Room"];
    songRoom.songQueue = songQueue;
    return songRoom;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /*
    SongRoom *songRoom = [self createTestRoom];
    self.testAdmin = [[Admin alloc] initWithUsername:@"Test Admin"];
    [self.testAdmin startServer:@"Test Room"];
    self.testAdmin.songRoom = songRoom;
    */
    // Set up test member
    [[Member instance] startBrowser];
    [Member instance].username = @"Placeholder";
    
    // Prompt for Spotify login
    [self loginToSpotifyWithApplication:application];

    // Uncomment to bypass main storyboard loading
    // self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // self.window.rootViewController = [[TabBarController alloc] initWithSongRoom:songRoom];
    // [self.window makeKeyAndVisible];
    
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
        
        // Set the SpotifyRetriever session to this session
        [SpotifyRetriever instance].session = session;
        [Member instance].username = session.canonicalUsername;
        NSLog(@"*(&(&*(&********************* session ID = %@", session);
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

@end
