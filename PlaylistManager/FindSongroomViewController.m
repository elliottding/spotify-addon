//
//  FindSongroomViewController.m
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "FindSongroomViewController.h"

#import "TabBarController.h"

@interface FindSongroomViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *currentServices;

@end

@implementation FindSongroomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [playlistTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"songroomCell"];
    self.member = [[Member alloc] initWithUsername:@"test"];
    [self.member startBrowser];
    [NSThread sleepForTimeInterval:5.0];
    [self reloadView];
    // Do any additional setup after loading the view.
}
- (void)reloadView
{
    self.currentServices = [self.member currentServices];
    [playlistTable reloadData];
}

- (void)didReceiveMemoryWarning {
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.currentServices count]; //*** placeholder, var needs to find available songrooms;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songroomCell" forIndexPath:indexPath];
    NSNetService *service = [self.currentServices objectAtIndex:indexPath.row];
    cell.textLabel.text = service.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNetService *selectedService = self.currentServices[indexPath.row];
    self.member.connectTo = selectedService.name;
    [self.member connect];
    [NSThread sleepForTimeInterval:2];
    
    SongRoom *songRoom = self.member.songRoom;
    UIWindow *mainWindow = [UIApplication sharedApplication].windows.firstObject;
    mainWindow.rootViewController = [[TabBarController alloc] initWithSongRoom:songRoom];
}

@end
