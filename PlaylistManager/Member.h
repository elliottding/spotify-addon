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
// THIS IS OUTDDATED USE CURRENT SERVICES

@property (nonatomic) int flag;

@property (nonatomic, weak) NSMutableArray *  services;

// set this property to the name of the songroom you want to connect to then call the connect method
@property (nonatomic, strong) NSString *connectTo;

+ (instancetype)instance;

// Calling this method will search for a service with the name of the connectTo property
// and open a stream to it.
-(void)connect;


// this will start the search for services (it might mate sense to just
// overwrite the init and have this start automatically)
- (void)startBrowser;

// These are the methods that should be called when a user wants to
// either send a vote or queue a song this send the information to the
// server


-(NSMutableArray *) currentServices;

-(void)Vote:(NSString *)songURI withDirection:(int) upDown;

-(void) QueueSong:(NSString *) songURI;

-(void) SendCurrentSong:(NSString *) songURI;

-(void) RemoveSong:(NSString *) songURI;

-(void) updateSongRoom;

-(void) LogOff;


// for testing purposes only
- (void) outputText:(NSString *)text;






@end
