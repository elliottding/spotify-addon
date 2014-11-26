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
    [self.playlistNavigationController popViewControllerAnimated:YES];
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
    self.song.voteScore += 1;
    [self.playlistNavigationController popViewControllerAnimated:YES];
    [self.playlistNavigationController reloadPlaylistTableView];
}

- (IBAction)voteDownButtonAction
{
    self.song.voteScore -= 1;
    [self.playlistNavigationController popViewControllerAnimated:YES];
    [self.playlistNavigationController reloadPlaylistTableView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
