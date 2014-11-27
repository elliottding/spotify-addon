//
//  HistoryViewController.h
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SongRoom.h"

@interface HistoryViewController : UITableViewController

@property (nonatomic, strong) SongRoom *songRoom;

- (instancetype)initWithHistoryQueue:(NSArray *)historyQueue;

- (instancetype)initWithSongRoom:(SongRoom *)songRoom;

@end
