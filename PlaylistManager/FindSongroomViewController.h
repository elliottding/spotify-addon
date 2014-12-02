//
//  FindSongroomViewController.h
//  PlaylistManager
//
//  Created by Joshua Stevens-Stein on 11/19/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Member.h"

@interface FindSongroomViewController : UIViewController <UITextFieldDelegate> {
    
    __weak IBOutlet UITableView *playlistTable;
}

- (IBAction)enteredSongroomName:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *songroomName;

@end
