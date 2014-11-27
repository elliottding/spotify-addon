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

@property (nonatomic) IBOutlet UILabel *artistNameLabel;

@property (nonatomic) IBOutlet UIButton *playPauseButton;

@property (nonatomic) IBOutlet UISlider *volumeSlider;

@end

@implementation PlaybackViewController

- (void)dealloc
{
    [self.streamer removeObserver:self forKeyPath:@"currentTrackMetadata"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Now Playing";
    // self.song = self.song;
    // self.streamer = [SPTAudioStreamingController new];
}

- (void)ensureLoggedIn
{
    if (self.streamer == nil)
    {
        self.streamer = [SPTAudioStreamingController new];
        [self.streamer addObserver:self forKeyPath:@"currentTrackMetadata" options:0 context:nil];
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
         // Set volume slider to reflect true playback volume
         [self.volumeSlider setValue:self.streamer.volume animated:YES];
     }];
}

/*
- (void)setSong:(Song *)song
{
    self.songNameLabel.text = song.track.name;
    self.artistNameLabel.text =
    _song = song;
}
*/

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.streamer && [keyPath isEqualToString:@"currentTrackMetadata"])
    {
        NSDictionary *currentTrackMetadata = self.streamer.currentTrackMetadata;
        self.songNameLabel.text = [currentTrackMetadata objectForKey:SPTAudioStreamingMetadataTrackName];
        self.artistNameLabel.text = [currentTrackMetadata objectForKey:SPTAudioStreamingMetadataArtistName];
    }
}

- (IBAction)playPauseButtonAction
{
    // Avoid retain cycle in callback
    __unsafe_unretained typeof(self) weakSelf = self;
    
    if (self.streamer.isPlaying)
    {
        [self.streamer setIsPlaying:NO callback:^(NSError *error)
        {
            if (error != nil)
            {
                NSLog(@"Playback pause error: %@", error);
                return;
            }
            weakSelf.playPauseButton.titleLabel.text = @"Play";
        }];
    }
    else
    {
        [self.streamer setIsPlaying:YES callback:^(NSError *error)
        {
            if (error != nil)
            {
                NSLog(@"Playback resume error: %@", error);
                return;
            }
            weakSelf.playPauseButton.titleLabel.text = @"Pause";
        }];
    }
}

- (IBAction)volumeSliderChangeAction
{
    // Avoid retain cycle in callback
    __unsafe_unretained typeof(self) weakSelf = self;
    
    float sliderValue = self.volumeSlider.value;
    [self.streamer setVolume:sliderValue callback:^(NSError *error)
    {
        if (error != nil)
        {
            NSLog(@"Volume error: %@", error);
            return;
        }
        NSLog(@"Volume set to %f; slider at %f", weakSelf.streamer.volume, sliderValue);
    }];
}

@end
