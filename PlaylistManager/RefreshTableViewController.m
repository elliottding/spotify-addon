//
//  RefreshTableViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "RefreshTableViewController.h"

#import "Member.h"

@interface RefreshTableViewController ()

@end

@implementation RefreshTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)reload
{
    while ([Member instance].flag != 1);
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    NSLog(@"************* RELOADED ***************");
    [Member instance].flag = 0;
}

- (void)refresh
{
    [[Member instance] updateSongRoom];
    [NSThread detachNewThreadSelector:@selector(reload) toTarget:self withObject:nil];
}

@end
