//
//  PlaylistTableViewController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/25/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SongRoom.h"

@interface PlaylistTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) SongQueue *songQueue;

@property (nonatomic, strong) NSMutableArray *trackIdentifiers;

- (instancetype)initWithSongQueue:(SongQueue *)songQueue;

@end
