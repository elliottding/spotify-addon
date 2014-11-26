//
//  Admin.m
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "Admin.h"
#import "Server.h"
#import "Parser.h"
#import "User.h"
#import "Song.h"
#include "ServerConnection.h"

@interface Admin ()

@property (nonatomic, strong) Server * songroomServer;

@property (nonatomic, strong) NSMutableData *outputBuffer;


@end

@implementation Admin

-(BOOL)startServer:(NSString *)name{
    self.songroomServer = [[Server alloc] init];
    [self.songroomServer startWithName:name WithHost: self];
    NSLog(@"Admin started server");
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"TestNotification"
                                               object:nil];
    _outputBuffer = [[NSMutableData alloc] init];
    //[[NSRunLoop currentRunLoop] run];
    return true;
}

- (void)startOutput: (ServerConnection *) connection
{
    NSLog(@"start output called");
    assert([self.outputBuffer length] != 0);
    
    NSInteger actuallyWritten = [connection.outputStream write:[self.outputBuffer bytes] maxLength:[self.outputBuffer length]];
    if (actuallyWritten > 0) {
        //[self.outputBuffer replaceBytesInRange:NSMakeRange(0, (NSUInteger) actuallyWritten) withBytes:NULL length:0];
        [self.outputBuffer setLength: 0];
        // If we didn't write all the bytes we'll continue writing them in response to the next
        // has-space-available event.
    } else {
        // A non-positive result from -write:maxLength: indicates a failure of some form; in this
        // simple app we respond by simply closing down our connection.
    }
}

- (void)outputText:(NSString *)text toConnection: (ServerConnection *) connection
{
    NSLog(@"called output text");
    NSData * dataToSend = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (self.outputBuffer != nil) {
        
        BOOL wasEmpty = ([self.outputBuffer length] == 0);
        [self.outputBuffer appendData:dataToSend];
        if (wasEmpty) {
            [self startOutput: connection];
        }
    }
}


-(void)receiveTestNotification:(NSNotification *) notification{
    NSDictionary* userInfo = notification.userInfo;
    NSString* string = userInfo[@"string"];
    [self outputText:string toConnection:notification.object];
    //[self executeDict:[Parser readString:string]];
    NSLog(@"Admin recieved: %@", string);
    
}

// THIS FUNCTION DOESN'T WORK YET B/C songRoom is not recognized as a field of admin
-(void)executeDict:(NSMutableDictionary *)dict FromSender: (ServerConnection *) connection{
    if ([[dict objectForKey:@"type"] isEqualToString:@"VOTE"]){
        if ([self.songRoom.songQueue getIndexOfSong:[dict objectForKey:@"songURI"]] >= 0){
            //vote for that song
        } else if ([self.songRoom.songQueue.preferredQueue getIndexOfSong:[dict objectForKey:@"songURI"]] >= 0){
            //vote for that song
        }
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"QUEUE"]){
       //retrieve song by trackID
        Song* song = [dict objectForKey:@"songURI"];// get song by
        [self.songRoom.songQueue addSong:song];
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"UPDATE"]){
        NSString *songRoomString = [Parser makeSongRoomStatusString:self.songRoom];
        [self outputText:songRoomString toConnection: connection];
        //is songRoom accessible?
        //send string
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"SIGNIN"]){
        //make a user object?
        User *user = [[User alloc] initWithUsername:[dict objectForKey:@"username"]];
        [self.songRoom registerUser:user];
        NSString *songRoomString = [Parser makeSongRoomStatusString:self.songRoom];
        [self outputText:songRoomString toConnection: connection];
        
    }

}


-(void)stopServer{
    [self.songroomServer stop];
    return;
}

-(BOOL)serverIsRunning{
    return self.songroomServer.running;
    
}
@end
