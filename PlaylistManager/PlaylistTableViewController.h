//
//  PlaylistTableViewController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/25/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RefreshTableViewController.h"

#import "SongRoom.h"

@interface PlaylistTableViewController : RefreshTableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SongQueue *songQueue;

@property (nonatomic, strong) NSMutableArray *trackIdentifiers;

- (instancetype)initWithSongQueue:(SongQueue *)songQueue;

// Reloads all cells in the table view.
- (void)reloadView;

@end
