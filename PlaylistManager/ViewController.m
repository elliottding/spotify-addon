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
    
    // self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    // self.view.backgroundColor = [UIColor blueColor];
    // NSLog(@"loading view");
    self.view = [[SongView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    /*
    [[SpotifyRetriever instance] requestTestTrack:^(NSError *error, SPTTrack *track)
    {
        if (error != nil)
        {
            NSLog(@"*** error: %@", error);
            return;
        }

        if (self.view == nil)
        {
            NSLog(@"initializing view");
            Song *song = [[Song alloc] initWithTrack:track];
            CGRect frame = [UIScreen mainScreen].applicationFrame;
            
            self.view = [[SongView alloc] initWithSong:song frame:frame];
            self.view.backgroundColor = [UIColor blueColor];
        }
    }];
    */
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view loaded");
    [[SpotifyRetriever instance] requestTestTrack:^(NSError *error, SPTTrack *track)
     {
         if (error != nil)
         {
             NSLog(@"*** error: %@", error);
             return;
         }
         
         if (self.view != nil)
         {
             SongView *songView = (SongView *)self.view;
             Song *song = [[Song alloc] initWithTrack:track];
             songView.song = song;
         }
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
