//
//  PlaybackViewController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Song.h"

@interface PlaybackViewController : UIViewController

@property (nonatomic, strong) Song *song;

- (void)playSong:(Song *)song;

@end
