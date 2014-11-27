//
//  TabBarController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongRoom;

@class PlaylistNavigationController;

@class HistoryViewController;

@class RoomNavigationController;

@interface TabBarController : UITabBarController

@property (nonatomic, strong) SongRoom *songRoom;

@property (nonatomic, strong) PlaylistNavigationController *pnc;

@property (nonatomic, strong) HistoryViewController *hnc;

@property (nonatomic, strong) RoomNavigationController *rnc;

- (instancetype)initWithSongRoom:(SongRoom *)songRoom;

@end
