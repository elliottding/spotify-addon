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

@property (nonatomic) BOOL serverIsRunning;


// the name argument will set the name property
// to publish the server with the device name just input the
// empty string here
- (BOOL)startServer:(NSString *)name;

// stops the server
- (void)stopServer;


// When a song changes envoke this method with the new song and the change
// will be pushed to all of the server connections

- (void) updateCurrentlyPlaying: (Song *) newSong;

@end
