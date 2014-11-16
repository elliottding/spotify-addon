//
//  ServerConnection.h
//  ClientServer
//
//  Created by Zachary Jenkins on 11/12/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Server.h"

@interface ServerConnection : NSObject

// This notification is posted when the connection closes, either because you called
// -close or because of on-the-wire events (the client closing the connection, a network
// error, and so on).
extern NSString *const ConnectionDidCloseNotification;

@property (nonatomic, strong, readonly) NSInputStream *inputStream;

@property (nonatomic, strong, readonly) NSOutputStream *outputStream;

@property (nonatomic, strong) Server *myServer;

- (BOOL)open;

- (void)close;

- (instancetype)initWithInputStream:(NSInputStream *)inputStream outputStream:(NSOutputStream *)outputStream;

@end
