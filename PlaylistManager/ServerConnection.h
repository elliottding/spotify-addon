//
//  ServerConnection.h
//  ClientServer
//
//  Created by Zachary Jenkins on 11/12/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
//
// THIS SHOULD BE YOUR WORKING COPY

#import <Foundation/Foundation.h>

#import "Server.h"
#import "User.h"
#import "Song.h"

@interface ServerConnection : NSObject

// This notification is posted when the connection closes, either because you called
// -close or because of on-the-wire events (the client closing the connection, a network
// error, and so on).
extern NSString *const ConnectionDidCloseNotification;

// The stream properties will only be invoked at set up
@property (nonatomic, strong, readonly) NSInputStream *inputStream;

@property (nonatomic, strong, readonly) NSOutputStream *outputStream;

// This will be the username associated with the stream
@property (nonatomic, strong) NSString * username;

@property (nonatomic, weak) User *host;

// connection methods
- (BOOL)open;

- (void)close;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;

// SERVER RECIEVE METHODS
// These methods will be envoked in response to a server event
// other server events may include updates to songrooms
- (void) userDidDisconnect;

- (void) RecievedVote:(NSData *) voteInfo;

// this will only be envoked when the user firts initiates a session
// returns a user that can then be sent to the client
- (User *) userRequestToJoin:(NSData *) infoToJoin;

// SERVER SEND Methods
// These are the methods that will be called by data classes to send
// information to the client
// they take objects and do all of the translating to protocols themselves
// and then envoke sending methods
- (void) updateCurrentlyPlaying: (Song *) newSong;

// songroom can be taked from host property
- (void) updateSongRoom;

// SHOULD ONLY BE CALLED EXTERNALLY FOR TESTING PURPOSES
- (void)outputText:(NSString *)text;



@end