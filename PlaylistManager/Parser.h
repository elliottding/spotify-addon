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

+ (NSString *)makeVoteString:(NSString *)username updown:(int)updown songURI:(NSString *)songURI; // "VOTE:1:[SONGURI]"
+ (NSString *)makeQueueString:(NSString *)songURI; // "QUEUE:[SONGURI]"
+ (NSString *)makeCurrentSendString:(NSString *)songURI; // "CURRENTSONG:[SONGURI]"
+ (NSString *)makeUpdateString; // "UPDATE"
+ (NSString *)makeSigninString:(NSString *)username; // "SIGNIN:USERNAME"
+ (NSString *)makeSignoutString:(NSString *)username; // "SIGNOUT:USERNAME"
+ (NSString *)makeSongRoomStatusString:(SongRoom *)songRoom; //
+ (NSString *)makePlayNextString; // "NEWCS"
+ (NSString *)makeRemoveString:(NSString *)songURI; // "REMOVE:[SONGURI]"
+ (NSString *)makeKickString; // "KICK"
+ (NSString *)makeFailedQueueString;

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
 
 3. CURRENTSONG
 {
    "type" : @"CURRENTSONG"
    "songURI" : (NSString)
 }
 
 4. UPDATE
 {
    "type" : @"UPDATE"
 }
 
 5. SIGNIN
 {
    "type" : @"SIGNIN"
    "username" : (NSString)
 }
 
 6. SIGNOUT
 {
    "type" : @"SIGNOUT"
    "username" : (NSString)
 }
 
 7. UPSR
 {
    "type" : @"UPSR"
    "users" : (NSMutableArray)
    "songs" : (NSMutableDictionary)
 }
 
 8. NEWCS
 {
    "type" : @"NEWCS"
 }
 
 9. REMOVE
 {
    "type": @"REMOVE"
    "songURI" : (NSString)

 }
 
 10. KICK
 {
    "type" : @"NEWCS"
 }
 
 */


@end