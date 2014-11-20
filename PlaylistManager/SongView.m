//
//  SongView.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SongView.h"

@interface SongView ()

@property (nonatomic, strong) UILabel *songNameLabel;

@property (nonatomic, strong) UILabel *artistNameLabel;

@property (nonatomic, strong) UIImageView *songImage;

@end

@implementation SongView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.song = nil;
        
        UILabel *songNameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        songNameLabel.text = @"Loading...";
        [self addSubview:songNameLabel];
        self.songNameLabel = songNameLabel;
        self.backgroundColor = [UIColor blueColor];
        
        UILabel *artistNameLabel = [[UILabel alloc] initWithFrame:self.bounds];
        artistNameLabel.text = @"Loading...";
        [self addSubview:artistNameLabel];
        self.artistNameLabel = artistNameLabel;
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (instancetype)initWithSong:(Song *)song frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"init");
        NSLog(@"frame = %f %f %f %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        self.song = song;
        // self.backgroundColor = [UIColor blueColor];
    }
    return self;
}

- (void)setSong:(Song *)song
{
    _song = song;
    if (song != nil)
    {
        self.songNameLabel.text = song.track.name;
        [self setSongImageWithSPTImage:song.track.album.smallestCover];
    }
    // [self setNeedsDisplay];
}

- (void)setSongImageWithSPTImage:(SPTImage *)sptImage
{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:sptImage.imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.songImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.songImage];
}

/*
- (void)drawRect:(CGRect)rect
{
    
    NSLog(@"drawing");
    UIBezierPath *path;
    if (self.song == nil)
    {
        path = [UIBezierPath bezierPathWithRect:self.bounds];
    }
    else
    {
        path = [UIBezierPath bezierPathWithArcCenter:self.center radius:100 startAngle:0 endAngle:2 * M_PI clockwise:YES];
    }
    [[UIColor redColor] setFill];
    [path fill];
    
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
