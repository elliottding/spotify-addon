//
//  SearchViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SearchViewController.h"

#import "PlaylistTableView.h"

#import "SpotifyRetriever.h"

#import "Song.h"

@interface SearchViewController ()

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchResults;

@end

@implementation SearchViewController

- (void)loadView
{
    self.searchResults = [[NSMutableArray alloc] init];
    
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *mainView = [[UIView alloc] initWithFrame:mainFrame];
    
    CGRect tableViewFrame = mainFrame;
    PlaylistTableView *ptv = [[PlaylistTableView alloc] initWithFrame:tableViewFrame
                                                                style:UITableViewStylePlain];
    ptv.delegate = self;
    ptv.dataSource = self;
    
    [mainView addSubview:ptv];
    self.view = mainView;
    self.tableView = ptv;
}

- (void)searchUsingString:(NSString *)string
{
    self.searchResults = [[NSMutableArray alloc] init];
    SearchCallback callback = ^(NSError *error, SPTListPage *listPage)
    {
        if (error != nil)
        {
            NSLog(@"*** Error: Spotify search for %@ failed.", string);
        }
        for (SPTTrack *track in listPage.items)
        {
            Song *song = [[Song alloc] initWithTrack:track];
            [self.searchResults addObject:song];
        }
        if (listPage.hasNextPage)
        {
            [listPage requestNextPageWithSession:nil callback:callback];
        }
    };
    [[SpotifyRetriever instance] trackSearchByString:string callback:callback];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add a Song";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
