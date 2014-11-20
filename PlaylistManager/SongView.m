//
//  SongView.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SongView.h"

@implementation SongView

- (instancetype)initWithSong:(Song *)song frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSLog(@"init");
        self.song = song;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSLog(@"drawing");
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:self.bounds];
    [[UIColor redColor] setFill];
    [path fill];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
