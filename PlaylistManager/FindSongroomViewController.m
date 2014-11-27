//
//  FindSongroomViewController.m
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "FindSongroomViewController.h"

#import "TabBarController.h"

#import "Admin.h"

@interface FindSongroomViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *currentServices;

@end

@implementation FindSongroomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [playlistTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"songroomCell"];
    [NSThread sleepForTimeInterval:5];
    [self reloadView];
    // Do any additional setup after loading the view.
}

- (void)reloadView
{
    // self.currentServices = [[Member instance] currentServices];
    [playlistTable reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // TODO: Possible race condition here
    // return self.currentServices.count; //*** placeholder, var needs to find available songrooms;
    return [[Member instance] currentServices].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songroomCell"
                                                            forIndexPath:indexPath];
    NSNetService *service = [[[Member instance] currentServices] objectAtIndex:indexPath.row];
    cell.textLabel.text = service.name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNetService *selectedService = [[Member instance] currentServices][indexPath.row];
    [Member instance].connectTo = selectedService.name;
    [[Member instance] connect];
    [NSThread sleepForTimeInterval:2];
    
    SongRoom *songRoom = [Member instance].songRoom;
    UIWindow *mainWindow = [UIApplication sharedApplication].windows.firstObject;
    mainWindow.rootViewController = [[TabBarController alloc] initWithSongRoom:songRoom];
}

- (IBAction)makeNewSongRoomButtonAction
{
    NSString *songRoomName = @"New Room";
    SongRoom *songRoom = [[SongRoom alloc] initWithName:songRoomName];
    
    [Admin instance].username = @"Test Admin";
    [Admin instance].songRoom = songRoom;
    [[Admin instance] startServer:songRoomName];
    
    UIWindow *mainWindow = [UIApplication sharedApplication].windows.firstObject;
    mainWindow.rootViewController = [[TabBarController alloc] initWithSongRoom:songRoom];
}

@end
