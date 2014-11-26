//
//  NavigationController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongQueue;

@interface NavigationController : UINavigationController

@property (nonatomic, strong) SongQueue *songQueue;

- (instancetype)initWithSongQueue:(SongQueue *)songQueue;

- (void)pushSearchViewController;

@end
