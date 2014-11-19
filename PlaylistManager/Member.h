//
//  Member.h
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "User.h"

@interface Member : User

// The member will basically become what is now the client class
// and will be used to fing services and maintain the connections with
// them

// the member should deal with ecerything it recieves simply
// by making the appropriate changes to the data
// so the only methods needed are for finding, connecting, and sending

// This will hold all of the available songrooms as NSNetService objects
// once the browser is started

@property (nonatomic, strong) NSMutableArray *  services;

// this will start the search for services (it might mate sense to just
// overwrite the init and have this start automatically)
- (void)startBrowser;

// Once the user decides what room to join send the NSNetServiece object
// from the services array to this method and it will create the connection
- (void)openStreamsToNetService:(NSNetService *)netService;

// These are the methods that should be called when a user wants to
// either send a vote or queue a song this send the information to the
// server

-(void)Vote:(int)songID;

-(void) QueueSong:(NSString *) songURI;


@end