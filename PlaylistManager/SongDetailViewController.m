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

#import "Admin.h"

@interface SongDetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *songNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *songArtImageView;

@property (weak, nonatomic) IBOutlet UIButton *removeSongButton;

@property (weak, nonatomic) IBOutlet UIButton *playSongButton;

@property (weak, nonatomic) IBOutlet UIButton *moveToPreferredButton;

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
    SPTPartialArtist *artist = song.track.artists[0];
    self.artistNameLabel.text = artist.name;
    self.songNameLabel.text = song.track.name;
    
    // Code for Cover Art
    NSURL *songArtImageURL = song.track.album.largestCover.imageURL;
    NSData *songArtImageData = [NSData dataWithContentsOfURL:songArtImageURL];
    UIImage *songArtImage = [UIImage imageWithData:songArtImageData];
    self.songArtImageView.image = songArtImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Re-set song to ensure proper loading
    self.song = self.song;
    
    if (![Admin check])
    {
        NSLog(@"***** DISABLING ADMIN FEATURES *****");
        //[self.playSongButton setEnabled:NO];
        //[self.removeSongButton setEnabled:NO];
        self.playSongButton.hidden = YES;
        self.removeSongButton.hidden = YES;
        self.moveToPreferredButton.hidden = YES;
    }
    else
    {
        NSLog(@"***** ADMIN %@ FEATURES ENABLED *****", [Admin instance].username);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSongButtonAction
{
    PlaylistNavigationController *pnc = self.playlistNavigationController;
    [pnc popToRootViewControllerAnimated:NO];
    [pnc pushPlaybackViewControllerWithSong:self.song];
    
    //Song *selectedSong = self.song;
    //[[Member instance] SendCurrentSong:[selectedSong.track.uri absoluteString]];
    //[NSThread sleepForTimeInterval:2.0];

    // HISTORY QUEUE UPDATE
    // [[Member instance].songRoom.historyQueue addObject:self.song];
    // [[Member instance] RemoveSong: self.song.identifier];
    
    [NSThread sleepForTimeInterval:2.0];
    [pnc reloadPlaylistTableView];
}

- (IBAction)removeFromQueueButtonAction
{
    [[Member instance] RemoveSong: self.song.identifier];
    [NSThread sleepForTimeInterval:2.0];
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

- (IBAction)moveToPreferredAction
{
    [[Admin instance].songRoom.songQueue moveToPreferred:self.song];
    [[Member instance] RemoveSong:self.song.identifier];
    [NSThread sleepForTimeInterval:2.0];
    [self.playlistNavigationController popViewControllerAnimated:YES];
    [self.playlistNavigationController reloadPlaylistTableView];
}

@end
