//
//  RoomViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "RoomNavigationController.h"

#import "SongRoom.h"

#import "GuestListTableViewController.h"

@interface RoomNavigationController ()

@property (nonatomic, strong) SongRoom *songRoom;

@property (nonatomic, strong) GuestListTableViewController *guestListViewController;

@end

@implementation RoomNavigationController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom
{
    self = [super init];
    if (self)
    {
        self.songRoom = songRoom;
        self.guestListViewController = [[GuestListTableViewController alloc] initWithSongRoom:songRoom];
        [self pushViewController:self.guestListViewController animated:NO];
    }
    return self;
}

@end
