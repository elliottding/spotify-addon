//
//  RefreshTableViewController.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshTableViewController : UITableViewController

@property (nonatomic, strong) UIRefreshControl *refreshControl;

- (void)refresh;

@end
