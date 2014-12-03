//
//  Admin.h
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "User.h"
#import "Song.h"

@interface Admin : User

+ (instancetype)instance;

// the name argument will set the name property
// to publish the server with the device name just input the
// empty string here
- (BOOL)startServer:(NSString *)name;

// stops the server
- (void)stopServer;

// checks the server to see if its running
// originally designed to be a variable but that can't react to server changes as easily
- (BOOL) serverIsRunning;

// Check if the user of the app is an Admin
+ (bool)check;

// When a song changes envoke this method with the new song and the change
// will be pushed to all of the server connections

// - (void) updateCurrentlyPlaying: (Song *) newSong;

@end
