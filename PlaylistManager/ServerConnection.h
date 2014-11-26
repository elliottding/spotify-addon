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

// SHOULD ONLY BE CALLED EXTERNALLY FOR TESTING PURPOSES
- (void)outputText:(NSString *)text;


@end