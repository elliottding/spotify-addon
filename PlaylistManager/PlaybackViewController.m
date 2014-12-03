//
//  PlaybackViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "PlaybackViewController.h"

#import "SpotifyRetriever.h"

#import "Member.h"

#import "Admin.h"

NSTimeInterval const NextSongTimerInterval = 2;

@interface PlaybackViewController () <SPTAudioStreamingPlaybackDelegate>

@property (nonatomic) SPTAudioStreamingController *streamer;

@property (nonatomic) IBOutlet UILabel *songNameLabel;

@property (nonatomic) IBOutlet UILabel *artistNameLabel;

@property (nonatomic) IBOutlet UIButton *playPauseButton;

@property (nonatomic) IBOutlet UISlider *volumeSlider;

@property (nonatomic) IBOutlet UIImageView *songArtImageView;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *volumeLabel;

@property (nonatomic) NSTimeInterval currentSongDuration;

@property (nonatomic) NSTimer *nextSongTimer;

@end

@implementation PlaybackViewController

- (void)dealloc
{
    [self.streamer removeObserver:self forKeyPath:@"currentTrackMetadata"];
}

- (void)setSong:(Song *)song
{
    self.songNameLabel.text = song.track.name;
    SPTPartialArtist *artist = song.track.artists[0];
    self.artistNameLabel.text = artist.name;
    
    // Load song art image
    
    NSURL *songArtImageURL = song.track.album.largestCover.imageURL;
    NSData *songArtImageData = [NSData dataWithContentsOfURL:songArtImageURL];
    UIImage *songArtImage = [UIImage imageWithData:songArtImageData];
    self.songArtImageView.image = songArtImage;
    
    self.currentSongDuration = song.track.duration;
    
    _song = song;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Now Playing";
    if (self.streamer.isPlaying)
    {
        self.playPauseButton.titleLabel.text = @"Pause";
    }
    else
    {
        self.playPauseButton.titleLabel.text = @"Play";
    }
    if (![Admin check])
    {
        self.playPauseButton.hidden = YES;
        self.nextButton.hidden = YES;
        self.volumeSlider.hidden = YES;
        self.volumeLabel.hidden = YES;
    }
}

// Ensure that the audio streamer is initialized and logged in.
- (void)ensureLoggedIn
{
    if (self.streamer == nil)
    {
        self.streamer = [SPTAudioStreamingController new];
        [self.streamer addObserver:self forKeyPath:@"currentTrackMetadata" options:0 context:nil];
        self.streamer.playbackDelegate = self;
    }
    
    if (!self.streamer.loggedIn)
    {
        [self.streamer loginWithSession:[SpotifyRetriever instance].session callback:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"*** SPTAudioStreamingController login error: %@", error);
                 return;
             }
         }];
    }
}

- (void)setPlayPauseButtonPlay
{
    self.playPauseButton.titleLabel.text = @"Play";
}

- (void)setPlayPauseButtonPause
{
    self.playPauseButton.titleLabel.text = @"Pause";
}

- (IBAction)playNextSong
{
    Song *nextSong = [Member instance].songRoom.songQueue.nextSong;
    if (nextSong != nil)
    {
        [self playSong:nextSong];
    }
}

- (void)checkTimeAndMaybePlayNextSong
{
    // [self.streamer.currentTrackMetadata objectForKey:SPTAudioStreamingMetadataTrackDuration];
    double timeFrac = self.streamer.currentPlaybackPosition / self.currentSongDuration;
    NSLog(@"Playback timer firing; progress = %f", timeFrac);
    if (timeFrac > 0.999 || self.streamer.currentPlaybackPosition < 0.001)
    {
        [self.nextSongTimer invalidate];
        [self playNextSong];
    }
}

- (void)playSong:(Song *)song
{
    NSLog(@"attempting to play %@", song);
    self.song = song;
    [self ensureLoggedIn];
    
    // HISTORY QUEUE UPDATE
    [[Member instance].songRoom.historyQueue addObject:self.song];
    [[Member instance] RemoveSong: self.song.identifier];
    
    [self.streamer playTrackProvider:song.track callback:^(NSError *error)
     {
         if (error != nil)
         {
             NSLog(@"Playback error: %@", error);
             return;
         }
         
         NSLog(@"Now playing: %@", song.track.name);
         [self setPlayPauseButtonPause];
         
         // Set volume slider to reflect true playback volume
         [self.volumeSlider setValue:self.streamer.volume animated:YES];
         
         // Run next song timer
         self.nextSongTimer = [NSTimer scheduledTimerWithTimeInterval:NextSongTimerInterval target:self selector:@selector(checkTimeAndMaybePlayNextSong) userInfo:nil repeats:YES];
     }];
}

// Observe changes in currently playing track metadata
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == self.streamer && [keyPath isEqualToString:@"currentTrackMetadata"])
    {
        NSDictionary *trackMetadata = self.streamer.currentTrackMetadata;
        NSString *songNameText = [trackMetadata objectForKey:SPTAudioStreamingMetadataTrackName];
        self.songNameLabel.text = songNameText;
        NSLog(@"PlaybackViewController observed change %@", songNameText);
        self.artistNameLabel.text = [trackMetadata objectForKey:SPTAudioStreamingMetadataArtistName];
    }
}

- (void)audioStreaming:(SPTAudioStreamingController *)audioStreaming
didChangePlaybackStatus:(BOOL)isPlaying
{
    if (isPlaying)
    {
        [self setPlayPauseButtonPause];
    }
    else
    {
        [self setPlayPauseButtonPlay];
    }
}

// Handle Play/Pause button tap
- (IBAction)playPauseButtonAction
{
    // Avoid retain cycle in callback
    // __unsafe_unretained typeof(self) weakSelf = self;
    
    if (self.streamer.isPlaying)
    {
        [self.streamer setIsPlaying:NO callback:^(NSError *error)
         {
             if (error != nil)
             {
                 NSLog(@"Playback pause error: %@", error);
                 return;
             }
             // [weakSelf setPlayPauseButtonPlay];
         }];
    }
    else
    {
        // If current song is nil, then get the next song from the song queue to play
        if (self.song == nil)
        {
            Song *song = [Member instance].songRoom.songQueue.nextSong;
            [self playSong:song];
            // [[Member instance].songRoom playSong:song];
        }
        // Otherwise, unpause the song
        else
        {
            [self.streamer setIsPlaying:YES callback:^(NSError *error)
             {
                 if (error != nil)
                 {
                     NSLog(@"Playback resume error: %@", error);
                     return;
                 }
                 // [weakSelf setPlayPauseButtonPause];
             }];
        }
    }
}

// Handle volume slider change
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
