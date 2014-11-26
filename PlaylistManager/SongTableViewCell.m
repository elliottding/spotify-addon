//
//  SongTableViewCell.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/25/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SongTableViewCell.h"

#import <Spotify/Spotify.h>

#import "SpotifyRetriever.h"

@implementation SongTableViewCell

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
}

- (void)setSong:(Song *)song
{
    _song = song;
    if (song != nil)
    {
        self.textLabel.text = song.track.name;
        /*
        self.songNameLabel.text = song.track.name;
        SPTPartialArtist *artist = song.track.artists[0];
        self.artistNameLabel.text = artist.name;
        [self setSongImageWithSPTImage:song.track.album.smallestCover];
        */
    }
    // self.backgroundColor = [UIColor greenColor];
    // [self setNeedsDisplay];
}

/*
- (void)setSongImageWithSPTImage:(SPTImage *)sptImage
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:sptImage.imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.songImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.songImage];
}
*/

@end
