//
//  SongDetailViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/26/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "SongDetailViewController.h"

#import "Song.h"

@interface SongDetailViewController ()

@property (nonatomic, strong) IBOutlet UILabel *songNameLabel;

@end

@implementation SongDetailViewController

- (void)setSong:(Song *)song
{
    _song = song;
    self.songNameLabel.text = song.track.name;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Re-set song to ensure proper loading
    self.song = self.song;
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
