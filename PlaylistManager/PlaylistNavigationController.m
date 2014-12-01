//
//  NavigationController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "PlaylistNavigationController.h"
#import "PlaylistTableViewController.h"
#import "SearchViewController.h"
#import "SongDetailViewController.h"
#import "PlaybackViewController.h"
#import "SongRoom.h"
#import "SongQueue.h"
#import "Member.h"

@interface PlaylistNavigationController ()

@property (nonatomic, strong) PlaylistTableViewController *playlistViewController;

@property (nonatomic, strong) SearchViewController *searchViewController;

@property (nonatomic, strong) SongDetailViewController *songDetailViewController;

@property (nonatomic, strong) PlaybackViewController *playbackViewController;

@end

@implementation PlaylistNavigationController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom
{
    self = [super init];
    if (self)
    {
        // Set up PlaylistViewController
        PlaylistTableViewController *ptvc = [[PlaylistTableViewController alloc]
                                             initWithSongQueue:songRoom.songQueue];
        self.playlistViewController = ptvc;
        
        // Set up SearchViewController
        SearchViewController *svc = [[SearchViewController alloc] init];
        self.searchViewController = svc;
        
        // Set up SongDetailViewController
        SongDetailViewController *sdvc = [[SongDetailViewController alloc] init];
        self.songDetailViewController = sdvc;
        
        // Set up PlaybackViewController
        PlaybackViewController *pbvc = [[PlaybackViewController alloc] init];
        self.playbackViewController = pbvc;
        
        [self pushViewController:ptvc animated:NO];
        self.songRoom = songRoom;
    }
    return self;
}

- (SongRoom *)songRoom
{
    return [Member instance].songRoom;
}

- (SongQueue *)songQueue
{
    return self.songRoom.songQueue;
}

- (void)pushSearchViewController
{
    [self pushViewController:self.searchViewController animated:YES];
}

- (void)pushPlaybackViewController
{
    [self pushViewController:self.playbackViewController animated:YES];
}

- (void)pushSongDetailViewControllerWithSong:(Song *)song
{
    self.songDetailViewController.song = song;
    [self pushViewController:self.songDetailViewController animated:YES];
}

- (void)pushPlaybackViewControllerWithSong:(Song *)song
{
    [self.playbackViewController playSong:song];
    // This breaks PlaylistTableView sorting
    // [self popToRootViewControllerAnimated:NO];
    [self pushViewController:self.playbackViewController animated:YES];
}

- (void)reloadPlaylistTableView
{
    [self.playlistViewController reloadView];
}

@end
