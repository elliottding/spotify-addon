//
//  Parser.h
//  PlaylistManager
//
//  Created by Andrew Yang on 11/17/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#ifndef PlaylistManager_Parser_h
#define PlaylistManager_Parser_h


#endif

@interface Parser : NSObject

+ (NSString *)makeVoteString:(NSString *)uname updown:(int)updown song:(NSString *)songURI; // "VOTE:1"
+ (NSString *)makeQueueString:(NSString *)songURI; // "QUEUE:[SONGURI]"
+ (NSString *)makeUpdateString; // "UPDATE"
+ (NSString *)makeSigninString:(NSString *)username; // "SIGNIN:USERNAME"
+ (NSString *)makeSRStatusString:(SongRoom *)sr; //
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