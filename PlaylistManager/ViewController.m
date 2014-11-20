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
    NSLog(@"loading view");
    [[SpotifyRetriever instance] requestTestTrack:^(NSError *error, SPTTrack *track)
    {
        if (error != nil)
        {
            NSLog(@"*** error: %@", error);
            return;
        }
        Song *song = [[Song alloc] initWithTrack:track];
        NSLog(@"%@", song.track.name);
        self.view = [[SongView alloc] initWithSong:song frame:[UIScreen mainScreen].applicationFrame];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view loaded");
    //[self.view setNeedsDisplay];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
