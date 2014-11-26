//
//  TabBarController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "TabBarController.h"

#import "SongQueue.h"

#import "PlaylistNavigationController.h"
#import "HistoryViewController.h"
#import "RoomViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom
{
    self = [super init];
    if (self)
    {
        self.songRoom = songRoom;
        self.pnc = [[PlaylistNavigationController alloc] initWithSongRoom:songRoom];
        self.hnc = [[HistoryViewController alloc] initWithHistoryQueue:songRoom.historyQueue];
        self.rnc = [[RoomViewController alloc] init];
        
        [self setViewControllers:@[self.pnc, self.hnc, self.rnc] animated:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
