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
#import "RoomNavigationController.h"

@interface TabBarController () <UITabBarControllerDelegate>

@end

@implementation TabBarController

- (instancetype)initWithSongRoom:(SongRoom *)songRoom
{
    self = [super init];
    if (self)
    {
        self.songRoom = songRoom;
        self.pnc = [[PlaylistNavigationController alloc] initWithSongRoom:songRoom];
        self.hnc = [[HistoryViewController alloc] initWithSongRoom:songRoom];
        self.rnc = [[RoomNavigationController alloc] initWithSongRoom:songRoom];
        
        [self setViewControllers:@[self.pnc, self.hnc, self.rnc] animated:NO];
        self.delegate = self;
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

- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
    if (viewController == self.hnc)
    {
        [self.hnc.tableView reloadData];
    }
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
