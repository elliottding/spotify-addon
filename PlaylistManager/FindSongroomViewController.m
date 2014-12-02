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
    self.songroomName.delegate = self;
    [super viewDidLoad];
    [playlistTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"songroomCell"];
    [NSThread sleepForTimeInterval:5];
    [self reloadView];
}

- (void)reloadView
{
    // self.currentServices = [[Member instance] currentServices];
    [playlistTable reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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

- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSLog(@"IS BEING CALLED");
    NSString *name = textField.text;
    SongRoom *songRoom = [[SongRoom alloc] initWithName:name];
    
    [Admin instance].username = @"Test admin";
    [Admin instance].songRoom = songRoom;
    [[Admin instance] startServer:name];
    [Member instance].connectTo = @"Foo";
    [NSThread sleepForTimeInterval:2];
    [[Member instance] connect];
    
    UIWindow *mainWindow = [UIApplication sharedApplication].windows.firstObject;
    mainWindow.rootViewController = [[TabBarController alloc] initWithSongRoom:songRoom];
    [textField resignFirstResponder];
    return YES;
}
@end
