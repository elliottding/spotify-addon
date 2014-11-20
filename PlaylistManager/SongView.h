//
//  SongView.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Song.h"

@interface SongView : UIView

@property (nonatomic, strong) Song *song;

- (instancetype)initWithSong:(Song *)song frame:(CGRect)frame;

@end
