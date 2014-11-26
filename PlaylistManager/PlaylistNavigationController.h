//
//  NavigationController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongRoom;

@class SongQueue;

@class Song;

@interface PlaylistNavigationController : UINavigationController

@property (nonatomic, strong) SongRoom *songRoom;

@property (nonatomic, strong) SongQueue *songQueue;

- (instancetype)initWithSongRoom:(SongRoom *)songRoom;

- (void)pushSearchViewController;

- (void)pushSongDetailViewControllerWithSong:(Song *)song;

- (void)reloadPlaylistTableView;

@end
