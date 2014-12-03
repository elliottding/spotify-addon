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
    SongRoom *sr = [Admin instance].songRoom;
    if (sr.currentSong)
        [sr.historyQueue insertObject:sr.currentSong atIndex:0];
    sr.currentSong = self.song;


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

@end
