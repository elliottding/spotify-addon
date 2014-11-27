//
//  PlaybackViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "PlaybackViewController.h"

#import "SpotifyRetriever.h"

@interface PlaybackViewController ()

@property (nonatomic) SPTAudioStreamingController *streamer;

@property (nonatomic) IBOutlet UILabel *songNameLabel;

@property (nonatomic) IBOutlet UIButton *playPauseButton;

@end

@implementation PlaybackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Now Playing";
    // self.streamer = [SPTAudioStreamingController new];
}

- (void)ensureLoggedIn
{
    if (self.streamer == nil)
    {
        self.streamer = [SPTAudioStreamingController new];
    }
    if (!self.streamer.loggedIn)
    {
        [self.streamer loginWithSession:[SpotifyRetriever instance].session callback:^(NSError *error) {
            if (error != nil)
            {
                NSLog(@"*** SPTAudioStreamingController login error: %@", error);
                return;
            }
        }];
    }
}

- (void)playSong:(Song *)song
{
    NSLog(@"attempting to play %@", song);
    self.song = song;
    [self ensureLoggedIn];
    [self.streamer playTrackProvider:song.track callback:^(NSError *error)
     {
         if (error != nil)
         {
             NSLog(@"Playback error: %@", error);
             return;
         }
         NSLog(@"Now playing: %@", song.track.name);
     }];
}

- (void)setSong:(Song *)song
{
    self.songNameLabel.text = song.track.name;
    _song = song;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playPauseButtonAction
{
    self.playPauseButton.titleLabel.text = @"Pause";
}

@end
