//
//  NavigationController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "NavigationController.h"
#import "PlaylistTableViewController.h"
#import "SearchViewController.h"
#import "SongQueue.h"

@interface NavigationController ()

@property (nonatomic, strong) PlaylistTableViewController *playlistViewController;

@property (nonatomic, strong) SearchViewController *searchViewController;

@end

@implementation NavigationController

- (instancetype)initWithSongQueue:(SongQueue *)songQueue
{
    self = [super init];
    if (self)
    {
        // Set up PlaylistViewController
        PlaylistTableViewController *ptvc = [[PlaylistTableViewController alloc]
                                             initWithSongQueue:songQueue];
        self.playlistViewController = ptvc;
        
        // Set up SearchViewController
        SearchViewController *svc = [[SearchViewController alloc] init];
        self.searchViewController = svc;
        
        [self pushViewController:ptvc animated:NO];
        self.songQueue = songQueue;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushSearchViewController
{
    [self pushViewController:self.searchViewController animated:YES];
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
