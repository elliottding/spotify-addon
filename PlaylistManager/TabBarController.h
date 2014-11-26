//
//  TabBarController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongQueue;

@class PlaylistNavigationController;

@class HistoryViewController;

@class RoomViewController;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) SongQueue *songQueue;

@property (nonatomic, strong) PlaylistNavigationController *pnc;

@property (nonatomic, strong) HistoryViewController *hnc;

@property (nonatomic, strong) RoomViewController *rnc;

- (instancetype)initWithSongQueue:(SongQueue *)songQueue;

@end
