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
+ (NSString *)makeSignoutString:(NSString *)username;
+ (NSString *)makeSongRoomStatusString:(SongRoom *)songRoom; //
+ (NSString *)makePlayNextString; // "NEWCS"
+ (NSString *)makeRemoveString:(NSString *)songURI; // "REMOVE:[SONGURI]"
+ (NSString *)makeKickString; // "KICK"

+ (NSMutableDictionary *)readString:(NSString *)protocolString;

/* For each protocol string, readString returns the following NSMutableDictionary:
 1. VOTE 
 {
    "type" : @"VOTE"
    "username" : (NSString)
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
 
 5. SIGNOUT
 {
    "type" : @"SIGNOUT"
    "username" : (NSString)
 }
 
 6. UPSR
 {
    "type" : @"UPSR"
    "users" : (NSMutableArray)
    "songs" : (NSMutableDictionary)
 }
 
 7. NEWCS
 {
    "type" : @"NEWCS"
 }
 
 8. REMOVE
 {
    "type": @"REMOVE"
    "songURI" : (NSString)

 }
 
 9. KICK
 {
    "type" : @"NEWCS"
 }
 
 */


@end