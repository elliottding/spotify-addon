//
//  SongTableViewCell.h
//  PlaylistManager
//
//  Created by Elliott Ding on 11/25/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Song.h"

@interface SongTableViewCell : UITableViewCell

@property (nonatomic, strong) Song *song;

- (void)loadTrackWithIdentifier:(NSString *)identifier;

@end
