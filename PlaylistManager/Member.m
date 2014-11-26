//
//  Member.m
//  PlaylistManager
//
//  Created by Zachary Jenkins on 11/18/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "Member.h"
#import "Parser.h"
#import "Client.h"
#import "User.h"
#import "SpotifyRetriever.h"

@interface Member()

@property (nonatomic, strong) Client *connection;
@property (nonatomic, strong) NSMutableData *outputBuffer;


@end

@implementation Member


-(void) connect{
    
    _connection.connectTo = self.connectTo;
    [_connection connect];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"MemberNotification"
                                               object:nil];
    [NSThread detachNewThreadSelector:@selector(manageInput) toTarget:(self) withObject:nil];
    
}

-(void)receiveTestNotification:(NSNotification *) notification{
    NSDictionary* userInfo = notification.userInfo;
    NSString* string = userInfo[@"string"];
    [self outputText:string];
    NSLog(@"Member recieved: %@", string);
    
}

-(void) manageInput{
    while (1) {
        if(_connection.available){
            NSLog(_connection.message);
            [self executeDict:[Parser readString:_connection.message]];
            _connection.message = nil;
            _connection.available = 0;

        }
        
    }
}


- (void)startOutput
{
    NSLog(@"Member: start output called");
    assert([self.outputBuffer length] != 0);
    
    NSInteger actuallyWritten = [_connection.outputStream write:[self.outputBuffer bytes] maxLength:[self.outputBuffer length]];
    if (actuallyWritten > 0) {
        //  [self.outputBuffer replaceBytesInRange:NSMakeRange(0, (NSUInteger) actuallyWritten) withBytes:NULL length:0];
        [self.outputBuffer setLength:0];
        // If we didn't write all the bytes we'll continue writing them in response to the next
        // has-space-available event.
    } else {
        // A non-positive result from -write:maxLength: indicates a failure of some form; in this
        // simple app we respond by simply closing down our connection.
    }
}

- (void)outputText:(NSString *)text
{
    NSLog(@"Member: called output text");
    NSData * dataToSend = [text dataUsingEncoding:NSUTF8StringEncoding];
    if (self.outputBuffer != nil) {
        
        BOOL wasEmpty = ([self.outputBuffer length] == 0);
        [self.outputBuffer appendData:dataToSend];
        if (wasEmpty) {
            [self startOutput];
        }
    }
}


-(void) startBrowser{
    _connection = [[Client alloc] init];
    [_connection startBrowser];
    self.services = _connection.services;
    self.outputBuffer = [[NSMutableData alloc] init];
    
}

-(void)executeDict:(NSMutableDictionary *)dict
{
    if ([[dict objectForKey:@"type"] isEqualToString:@"UPSR"]){
        for (NSString * user in [dict objectForKey:@"users"]){
            User *userobj = [[User alloc] initWithUsername:user];
            //add user to dictionary of users if not in users
            [self.songRoom registerUser:userobj]; //registerUser overwrites previous values?
        }
        for (id key in self.songRoom.userDictionary){
            if (![[dict objectForKey:@"users"] objectForKey:key]){
                [self.songRoom unregisterUsername:key];
            }
            //if user is not in list of users sent by server, then remove
        }
        SongQueue *newQ = [[SongQueue alloc] init];
        __block Song *newsong;
        for (id key in [dict objectForKey:@"songs"]){
            
            [[SpotifyRetriever instance] requestTrack:key callback:^(NSError *error, SPTTrack *track)
             {
                 if (error != nil)
                 {
                     NSLog(@"*** error: %@", error);
                     return;
                 }
                 
                 newsong = [[Song alloc] initWithTrack:track];
                 
             }];
            //SPTTrack * track;
            // Song *newsong = [[Song alloc] initWithTrack:track];
            newsong.voteScore = [[[dict objectForKey:@"songs"] objectForKey:key] intValue];
            //this might cause an error, i'm not sure if this number is actually stored as an int in dict
            [newQ appendSong:newsong];
        }
        self.songRoom.songQueue = newQ;
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"NEWCS"]){
        //new song by removing top song
        [self.songRoom.songQueue removeTopSong];
    }
}


-(void) Vote:(NSString *)songURI withDirection:(int)upDown
{
    NSString *vote = [Parser makeVoteString: self.username updown:upDown songURI: songURI];
    [self outputText:vote];
}

-(void)QueueSong:(NSString *)songURI{
    NSString *queueRequest = [Parser makeQueueString:songURI];
    [self outputText:queueRequest];
}
-(NSMutableArray *) currentServices{
    return _connection.services;
}

@end



