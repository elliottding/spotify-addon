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

#import "SongTableViewCell.h"

#import "Song.h"

#import "PlaylistNavigationController.h"

#import "SongRoom.h"

@interface SearchViewController ()  <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *searchResults;

@property (nonatomic, strong) SPTListPage *searchResultListPage;

@property (nonatomic, strong) UITextField *searchBox;

@end

@implementation SearchViewController

- (void)loadView
{
    /*
    self.searchResults = [[NSMutableArray alloc] init];
    for (int i = 0; i < 20; i++)
    {
        Song *song = [[Song alloc] init];
        self.searchResults addObject
    }
    */
    static int partition = 6;
    
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    UIView *mainView = [[UIView alloc] initWithFrame:mainFrame];
    
    // Set up the search box view
    CGRect searchFrame = mainFrame;
    CGFloat searchFrameHeight = mainFrame.size.height / partition;
    searchFrame.size = CGSizeMake(mainFrame.size.width, searchFrameHeight);
    
    UITextField *searchBox = [[UITextField alloc] initWithFrame:searchFrame];
    searchBox.placeholder = @"Search...";
    searchBox.backgroundColor = [UIColor whiteColor];
    searchBox.delegate = self;
    [mainView addSubview:searchBox];
    
    // Set up the search results view
    CGRect tableViewFrame = mainFrame;
    tableViewFrame.origin = CGPointMake(mainFrame.origin.x, searchFrameHeight);
    tableViewFrame.size = CGSizeMake(mainFrame.size.width,
                                     mainFrame.size.height * (partition - 1) / partition);
    
    PlaylistTableView *ptv = [[PlaylistTableView alloc] initWithFrame:tableViewFrame
                                                                style:UITableViewStylePlain];
    ptv.delegate = self;
    ptv.dataSource = self;
    [mainView addSubview:ptv];
    
    self.searchBox = searchBox;
    self.tableView = ptv;
    self.view = mainView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add a Song";
    [self.tableView registerClass:[SongTableViewCell class] forCellReuseIdentifier:@"SongCell"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchUsingString:textField.text];
    // Hide keyboard
    [textField resignFirstResponder];
    return YES;
}

/*
// TODO: Hide keyboard when user touches outside of search box
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.searchBox endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}
*/

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
        /*
        self.searchResultListPage = listPage;
        if (listPage.hasNextPage)
        {
            [listPage requestNextPageWithSession:nil callback:callback];
        }
        */
        [self.tableView reloadData];
    };
    [[SpotifyRetriever instance] trackSearchByString:string callback:callback];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return self.searchResults.count;
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
        song = self.searchResults[indexPath.item];
    }
    else
    {
        [NSException raise:@"Index error" format:@"indexPath section %ld is invalid", indexPath.section];
    }
    
    cell.song = song;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Search Results";
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    PlaylistNavigationController *nav = (PlaylistNavigationController *)self.navigationController;
    
    // Add song to song queue
    Song *selectedSong = self.searchResults[indexPath.item];
    [nav.songQueue addSong:selectedSong];
    
    // Pop this view controller
    [self.navigationController popViewControllerAnimated:YES];
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
