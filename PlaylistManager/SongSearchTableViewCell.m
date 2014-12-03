//
//  SongSearchTableViewCell.m
//  PlaylistManager
//
//  Created by mlandgrebe on 12/2/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SongSearchTableViewCell.h"

#import <Spotify/Spotify.h>

#import "SpotifyRetriever.h"

@interface SongSearchTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;

@end

@implementation SongSearchTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadTrackWithIdentifier:(NSString *)identifier
{
    [[SpotifyRetriever instance] requestTrack:identifier callback:^(NSError *error, SPTTrack *track)
     {
         if (error != nil)
         {
             NSLog(@"*** error: %@", error);
             return;
         }
         
         Song *song = [[Song alloc] initWithTrack:track];
         self.song = song;
     }];
    NSLog(@"loading track");
}

- (void)trackDidLoad
{
    [self updateTextLabels];
}

- (void)setSong:(Song *)song
{
    if (song == self.song)
    {
        return;
    }
    [self unobserveSong:self.song];
    [self observeSong:song];
    _song = song;
    [self updateTextLabels];
}

- (void)observeSong:(Song *)song
{
    [song addObserver:self forKeyPath:@"track" options:0 context:nil];
    //[song addObserver:self forKeyPath:@"voteScore" options:0 context:nil];
}

- (void)unobserveSong:(Song *)song
{
    [song removeObserver:self forKeyPath:@"track"];
    //[song removeObserver:self forKeyPath:@"voteScore"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object != self.song)
    {
        return;
    }
    if ([keyPath isEqualToString:@"track"]) //| [keyPath isEqualToString:@"voteScore"])
    {
        [self updateTextLabels];
    }
}

- (void)updateTextLabels
{
    SPTPartialArtist *artist = self.song.track.artists[0];
    NSString *artistName = artist.name;
    self.artistNameLabel.text = artistName;
    
    NSString *songName = self.song.track.name;
    self.songNameLabel.text = songName;
}

- (void)dealloc
{
    [self unobserveSong:self.song];
}

@end
