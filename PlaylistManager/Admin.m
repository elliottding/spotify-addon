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
#import "SpotifyRetriever.h"

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
    NSLog(@"Admin recieved: %@", string);
    [self executeDict:[Parser readString:string] FromSender:notification.object];
    
}

-(void)executeDict:(NSMutableDictionary *)dict FromSender: (ServerConnection *) connection{
    if ([[dict objectForKey:@"type"] isEqualToString:@"VOTE"]){
        int i;
        if ((i = [self.songRoom.songQueue getIndexOfURI:[dict objectForKey:@"songURI"]]) >= 0){
            VoteBox *vb = [[self.songRoom.songQueue.songs objectAtIndex:i] voteBox];
            [vb setVoteScore:[[dict objectForKey:@"updown"] intValue] forUsername:[dict objectForKey:@"username"]];
        } else if ([self.songRoom.songQueue.preferredQueue getIndexOfURI:[dict objectForKey:@"songURI"]] >= 0){
            VoteBox *vb = [[self.songRoom.songQueue.preferredQueue.songs objectAtIndex:i] voteBox];
            [vb setVoteScore:[[dict objectForKey:@"updown"] intValue] forUsername:[dict objectForKey:@"username"]];
        }
        NSString *songRoomString = [Parser makeSongRoomStatusString:self.songRoom];
        [self outputText:songRoomString toConnection: connection];
        
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"QUEUE"]){
        Song * newsong = [[Song alloc] initWithIdentifier:[dict objectForKey:@"songURI"]];
        NSLog(@"Spotify URI: %@", newsong.identifier);
        [self.songRoom.songQueue addSong:newsong];
        NSLog(@"Next song is: %@", self.songRoom.songQueue.nextSong.identifier);
        NSString *songRoomString = [Parser makeSongRoomStatusString:self.songRoom];
        [self outputText:songRoomString toConnection: connection];
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"UPDATE"]){
        NSString *songRoomString = [Parser makeSongRoomStatusString:self.songRoom];
        [self outputText:songRoomString toConnection: connection];
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"SIGNIN"]){
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