//
//  GuestListTableViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "GuestListTableViewController.h"

#import "SongRoom.h"

@interface GuestListTableViewController ()

@property (nonatomic, strong) SongRoom *songRoom;

@end

@implementation GuestListTableViewController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom
{
    self = [super init];
    if (self)
    {
        self.songRoom = songRoom;
        self.title = [NSString stringWithFormat:@"%@ Guest List", songRoom.name];
        //self.title = @"%@: SongRoom Guest List", srname;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GuestCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.songRoom.userDictionary.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuestCell"
                                                            forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GuestCell"];
    }
    
    NSString *key = self.songRoom.userDictionary.allKeys[indexPath.row];
    // User *user = [self.songRoom.userDictionary objectForKey:key];
    
    cell.textLabel.text = key;
    return cell;
}

@end
