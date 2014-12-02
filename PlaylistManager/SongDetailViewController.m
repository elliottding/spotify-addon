//
//  SongDetailViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SongDetailViewController.h"

#import "PlaylistNavigationController.h"

#import "Song.h"

#import "SongRoom.h"

#import "SongQueue.h"

#import "Member.h"

@interface SongDetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *songNameLabel;

@property (nonatomic) PlaylistNavigationController *playlistNavigationController;

@end

@implementation SongDetailViewController

- (PlaylistNavigationController *)playlistNavigationController
{
    return (PlaylistNavigationController *)self.navigationController;
}

- (void)setSong:(Song *)song
{
    _song = song;
    NSLog(@"set song to %@", song.track.name);
    self.songNameLabel.text = song.track.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Re-set song to ensure proper loading
    self.song = self.song;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSongButtonAction
{
    [self.playlistNavigationController.songRoom playSong:self.song];
    // [self.playlistNavigationController popViewControllerAnimated:NO];
    [self.playlistNavigationController pushPlaybackViewControllerWithSong:self.song];
    [self.playlistNavigationController reloadPlaylistTableView];
}

- (IBAction)removeFromQueueButtonAction
{
    [self.playlistNavigationController.songQueue removeSongFromEitherQueue:self.song];
    [self.playlistNavigationController popViewControllerAnimated:YES];
    [self.playlistNavigationController reloadPlaylistTableView];
}

- (IBAction)voteUpButtonAction
{
    [[Member instance] Vote:self.song.identifier withDirection:1];
    [NSThread sleepForTimeInterval:2.0];
    //self.song.voteScore += 1;
    [self.playlistNavigationController popViewControllerAnimated:YES];
    [self.playlistNavigationController reloadPlaylistTableView];
}

- (IBAction)voteDownButtonAction
{
    [[Member instance] Vote:self.song.identifier withDirection:-1];
    [NSThread sleepForTimeInterval:2.0];
    //self.song.voteScore -= 1;
    [self.playlistNavigationController popViewControllerAnimated:YES];
    [self.playlistNavigationController reloadPlaylistTableView];
}

@end
