//
//  Parser.h
//  PlaylistManager
//
//  Created by Andrew Yang on 11/17/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SongRoom.h"

@interface Parser : NSObject

+ (NSString *)makeVoteString:(NSString *)username updown:(int)updown songURI:(NSString *)songURI; // "VOTE:1"
+ (NSString *)makeQueueString:(NSString *)songURI; // "QUEUE:[SONGURI]"
+ (NSString *)makeUpdateString; // "UPDATE"
+ (NSString *)makeSigninString:(NSString *)username; // "SIGNIN:USERNAME"
+ (NSString *)makeSongRoomStatusString:(SongRoom *)songRoom; //
+ (NSString *)makePlayNextString; // "NEWCS"

+ (NSMutableDictionary *)readString:(NSString *)protocolString;
//subclass into user and admin parsers?



/*
 - (void)transmitProtocol:(NSString *)outMessage;
 String begins with
 1 - upsr
 2 - newcs
 3 - inituser
 */

- (void)receiveProtocol:(NSString *)inMessage;

@end