//
//  SongSearchTableViewCell.h
//  PlaylistManager
//
//  Created by mlandgrebe on 12/2/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Song.h"

@interface SongSearchTableViewCell : UITableViewCell

@property (nonatomic, strong) Song *song;

- (void)loadTrackWithIdentifier:(NSString *)identifier;

@end

