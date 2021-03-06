//
//  Server.h
//  ClientServer
//
//  Created by Zachary Jenkins on 11/9/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
//
// THIS SHOULD BE YOUR WORKING COPY


#import <Foundation/Foundation.h>
#import "User.h"

@interface Server : NSObject

// initiated in -start chooses an arbitrary port that can be successfully opened
@property (nonatomic, assign, readonly ) NSUInteger port;

// This will be the name the server will be published on bonjour with
// should match the songroom name property
@property (nonatomic) NSString *name;

// this is simply held so it may be passed to server connections
@property (nonatomic, weak) User *host;

@property (nonatomic) BOOL running;

// the name argument will set the name property
// to publish the server with the device name just input the
// empty string here
- (BOOL)startWithName:(NSString *)name WithHost:(User *)host;

- (void)stop;

@end
