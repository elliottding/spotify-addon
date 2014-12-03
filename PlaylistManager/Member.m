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

+ (instancetype)instance
{
    static Member *singleInstance = nil;
    static dispatch_once_t onceToken;
    
    // Ensure that singleInstance is initialized only once across all threads
    dispatch_once(&onceToken, ^
                  {
                      singleInstance = [[self alloc] init];
                  });
    return singleInstance;
}

- (void)connect
{
    _connection.connectTo = self.connectTo;
    [_connection connect];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveTestNotification:)
                                                 name:@"MemberNotification"
                                               object:nil];
    [NSThread detachNewThreadSelector:@selector(manageInput) toTarget:(self) withObject:nil];
    [NSThread sleepForTimeInterval:1.0];
    [self outputText:[Parser makeSigninString:self.username]];
}

- (void)receiveTestNotification:(NSNotification *) notification{
    NSDictionary* userInfo = notification.userInfo;
    NSString* string = userInfo[@"string"];
    [self outputText:string];
    NSLog(@"Member recieved: %@", string);
    
}

- (void)manageInput {
    while (1) {
        if(_connection.available) {
            NSLog(@"%@", _connection.message);
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
        [self.outputBuffer setLength:0]; // purge buffer after writing
        
    } else {
        // A non-positive result from -write:maxLength: indicates a failure of some form
        
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
        NSLog(@"updating songroom");
        self.songRoom = nil;
        self.songRoom = [[SongRoom alloc] initWithName:_connectTo];
        for (NSString * user in [dict objectForKey:@"users"]){
            User *userobj = [[User alloc] initWithUsername:user];
            NSLog(@"regisering user: %@", user);
            //add user to dictionary of users if not in users
            [self.songRoom registerUser:userobj]; //registerUser overwrites previous values?
            [self.songRoom containsUsername:@"test user"];
        }
        SongQueue *newQ = [[SongQueue alloc] init];
        for (id key in [dict objectForKey:@"prefsongs"]){
            NSLog(@"Queing key '%@' in preferred queue", key);
            Song *newsong = [[Song alloc] initWithIdentifier:key];
            newsong.voteScore = [[[dict objectForKey:@"prefsongs"] objectForKey:key] intValue];
            [newQ.preferredQueue appendSong:newsong];
        }
        for (id key in [dict objectForKey:@"regsongs"]){
            NSLog(@"Queing key '%@' in regular queue", key);
            Song *newsong = [[Song alloc] initWithIdentifier:key];
            newsong.voteScore = [[[dict objectForKey:@"regsongs"] objectForKey:key] intValue];
            [newQ addSong:newsong];
        }
        
        // HISTORY QUEUE UPDATE
        //NSDictionary *historyDict = [dict objectForKey:@"history"];
        for (id key in [dict objectForKey:@"history"]){
            NSLog(@"Queuing key '%@' in history queue", key);
            Song *newsong = [[Song alloc] initWithIdentifier:key];
            //newsong.voteScore = [[historyDict objectForKey:key] intValue];
            [self.songRoom.historyQueue addObject:newsong];
        }
        
        self.songRoom.songQueue = newQ;
        int i = 0;
        for (id key in [dict objectForKey:@"history"]){
            Song *newsong = [[Song alloc] initWithIdentifier:key];
            [self.songRoom.historyQueue setObject:newsong atIndexedSubscript:i++];
        }
        self.flag = 1;
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"NEWCS"]){
        //new song by removing top song
        [self.songRoom.songQueue removeTopSong];
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"CURRENTSONG"]){
        //update current song
        [self.songRoom.historyQueue insertObject:self.songRoom.currentSong atIndex:0];
        Song *currsong = [[Song alloc] initWithIdentifier:[dict objectForKey:@"songURI"]];
        self.songRoom.currentSong = currsong;
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"KICK"]){
        //remove self from songroom
        self.songRoom = nil;
    } else if ([[dict objectForKey:@"type"] isEqualToString:@"QFAIL"]){
        //popup message, queue fail
    }

}

-(void) Vote:(NSString *)songURI withDirection:(int)upDown
{
    NSString *vote = [Parser makeVoteString: self.username updown:upDown songURI: songURI];
    [self outputText:vote];
}

- (void)QueueSong:(NSString *)songURI{
    NSString *queueRequest = [Parser makeQueueString:songURI];
    [self outputText:queueRequest];
}

- (void)SendCurrentSong:(NSString *)songURI{
    NSString *setCurrentSendRequest = [Parser makeCurrentSendString:songURI];
    [self outputText:setCurrentSendRequest];
}

- (NSMutableArray *)currentServices{
    return _connection.services;
}

- (void)updateSongRoom{
    NSString * upRequest = [Parser makeUpdateString];
    [self outputText:upRequest];
}

- (void)RemoveSong:(NSString *)songURI
{
    NSString *remove = [Parser makeRemoveString:songURI];
    [self outputText:remove];
}

- (void)LogOff
{
    NSString *logoffString = [Parser makeSignoutString:self.username];
    [self outputText:logoffString];
}

- (void)playSong:(NSString *)songURI
{
    NSString *remove = [Parser makeRemoveString:songURI];
    [self outputText:remove];
}

@end



