//
//  GuestListTableViewController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SongRoom;

@interface GuestListTableViewController : UITableViewController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom;

@end
