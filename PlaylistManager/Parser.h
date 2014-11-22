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

/* For each protocol string, readString returns the following NSMutableDictionary:
 1. VOTE 
 {
    "type" : @"VOTE"
    "user" : (NSString)
    "updown" : (int)
    "songURI" : (NSString)
 }

 2. QUEUE
 {
    "type" : @"QUEUE"
    "songURI" : (NSString)
 }
 
 3. UPDATE
 {
    "type" : @"UPDATE"
 }
 
 4. SIGNIN
 {
    "type" : @"SIGNIN"
    "username" : (NSString)
 }
 
 5. UPSR
 {
    "type" : @"UPSR"
    "users" : (NSMutableArray)
    "songs" : (NSMutableDictionary)
 }
 
 6. NEWCS
 {
    "type" : @"NEWCS"
 }
 
 */


@end