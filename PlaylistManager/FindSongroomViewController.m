//
//  FindSongroomViewController.m
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "FindSongroomViewController.h"

@interface FindSongroomViewController ()

@property NSMutableArray* currServ;

@end

@implementation FindSongroomViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.member = [[Member alloc] initWithUsername:@"test"];
    [self.member startBrowser];

    // Do any additional setup after loading the view.
}
- (void)reloadView
{
    self.currServ = [self.member currentServices];
    //[self.tableView reloadData];
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
    return [self.currServ count]; //*** placeholder, var needs to find available songrooms;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"songroomCell" forIndexPath:indexPath];
    NSNetService* service = [self.currServ objectAtIndex:indexPath.row];
    cell.textLabel.text = service.name;
    return cell;
}

@end
