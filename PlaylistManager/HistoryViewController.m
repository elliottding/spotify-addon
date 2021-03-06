//
//  HistoryViewController.m
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "HistoryViewController.h"

#import "SongTableViewCell.h"

#import "Member.h"

@interface HistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *historyQueue;

@end

@implementation HistoryViewController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom
{
    self = [super init];
    if (self)
    {
        // self.songRoom = songRoom;
        self.title = @"History";
    }
    return self;
}

- (SongRoom *)songRoom
{
    return [Member instance].songRoom;
}

- (void)loadView
{
    CGRect tableViewFrame = [[UIScreen mainScreen] applicationFrame];
    UITableView *tableView = [[UITableView alloc] initWithFrame:tableViewFrame
                                                          style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView reloadData];
    self.view = tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Register the cell class for a reuse identifier
    [self.tableView registerClass:[SongTableViewCell class] forCellReuseIdentifier:@"SongCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        NSLog(@"HistoryViewController: Currently %d items in the queue", self.songRoom.historyQueue.count);
        return self.songRoom.historyQueue.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseIdentifier = @"SongCell";
    SongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier
                                                              forIndexPath:indexPath];
    
    // Initialize a new cell if one was not dequeued
    if (cell == nil)
    {
        cell = [[SongTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:reuseIdentifier];
    }
    
    // Set the song of the cell
    Song *song;
    if (indexPath.section == 0)
    {
        song = self.songRoom.historyQueue[indexPath.row];
    }
    else
    {
        [NSException raise:@"Index error" format:@"indexPath section %ld is invalid", indexPath.section];
    }
    
    cell.song = song;
    return cell;
}

@end
