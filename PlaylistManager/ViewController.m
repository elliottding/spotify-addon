//
//  ViewController.m
//  PlaylistManager
//
//  Created by Elliott Ding on 11/11/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "ViewController.h"

#import "SongView.h"

#import "SpotifyRetriever.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)loadView
{
    UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"SongView" owner:self options:nil] objectAtIndex:0];
    self.view = view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view loaded");
    SongView *songView = (SongView *)self.view;
    [songView loadTrackWithIdentifier:@"0DiWol3AO6WpXZgp0goxAV"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
