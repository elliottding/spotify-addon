//
// Client.h
//  Server
//
//  Created by Zachary Jenkins on 11/9/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
// THIS SHOULD BE YOUR WORKING COPY

#import <Foundation/Foundation.h>
#import "Server.h"
#import "ServerConnection.h"

@interface Client : NSObject

@property (nonatomic, strong) NSMutableArray *  services;

// will connect to this string when discovered only for testing connecting to a service
// from services will be implemented seperately
// To use this is must be set before browing begins

@property (nonatomic, strong) NSString *connectTo;

// For testing purposes
// if this property is set before a connection is made with the server this message will be called
@property (nonatomic) NSString *message;

// Also for testing purposes
// the client will store server responses here for comparison
@property (nonatomic) NSString *response;

@property (nonatomic, strong, readwrite) NSOutputStream *       outputStream;

- (void)startBrowser;

- (void)openStreamsToNetService:(NSNetService *)netService;

-(void)connect;

- (void) outputText:(NSString *)text;




@end
