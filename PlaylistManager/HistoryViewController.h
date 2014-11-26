//
//  HistoryViewController.h
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface HistoryViewController : UITableViewController

- (instancetype)initWithHistoryQueue:(NSArray *)historyQueue;

@end
