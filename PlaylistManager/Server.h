//
//  Server.h
//  ClientServer
//
//  Created by Zachary Jenkins on 11/9/14.
//  Copyright (c) 2014 Zachary Jenkins. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Server : NSObject

// initiated in -start chooses an arbitrary port that can be successfully opened
@property (nonatomic, assign, readonly ) NSUInteger port;

// This will be the name the server will be published on bonjour with
// should match the songroom name property
@property (nonatomic) NSString *name;

// This property determines how many times the server should echo back
// before exiting
// this is important for testing to stop the servers loop otherwise the code will never reach the tests
// for non testing purposes this should either be removed (along with associated code)
// or set to an unreachable number
@property int numberOfEchos;

// set to zero when server starts incremented each echo
@property int currentEchos;

// the name argument will set the name property
// to publish the server with the device name just input the
// empty string here
- (BOOL)start:(NSString *)name;

- (void)stop;

@end
