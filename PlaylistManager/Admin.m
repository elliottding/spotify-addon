//
//  Admin.m
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "Admin.h"
#import "Server.h"

@interface Admin ()

@property (nonatomic, strong) Server * songroomServer;

@end

@implementation Admin

-(BOOL)startServer:(NSString *)name{
    self.songroomServer = [[Server alloc] init];
    [self.songroomServer startWithName:name WithHost: self];
    NSLog(@"Admin started server");
    return true;
}



-(void)stopServer{
    [self.songroomServer stop];
    return;
}

-(BOOL)serverIsRunning{
    return self.songroomServer.running;
    
}
@end
