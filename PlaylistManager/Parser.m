//
//  Parser.m
//  PlaylistManager
//
//  Created by Andrew Yang on 11/17/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import "Parser.h"
#import "SongRoom.h"
#import "SongQueue.h"
#import "UnsortedSongQueue.h"
#import "Song.h"

@implementation Parser

+ (NSString *)makeVoteString:(NSString *)username updown:(int)updown songURI:(NSString *)songURI
{
    NSString * voteString = [username stringByAppendingString:[NSString stringWithFormat:@":%d:",updown]];
    voteString = [voteString stringByAppendingString:songURI];
    voteString = [@"VOTE:" stringByAppendingString:voteString];
    return voteString;
}

+ (NSString *)makeQueueString:(NSString *)songURI
{
    NSString *queueString = [@"QUEUE:" stringByAppendingString:songURI];
    return queueString;
}

+ (NSString *)makeUpdateString
{
    NSString * updateString = @"UPDATE";
    return updateString;
}

+ (NSString *)makeSigninString:(NSString *)username
{
    NSString * signinString = [@"SIGNIN:" stringByAppendingString:username];
    return signinString;
}

+ (NSString *)makeSongRoomStatusString:(SongRoom *)songRoom
{
    NSString * statusString = @"UPSR:";
    //users added to string by keys
    for (id key in songRoom.userDictionary){
        statusString = [statusString stringByAppendingString:key];
        statusString = [statusString stringByAppendingString:@":"];
    }
    statusString = [statusString stringByAppendingString:@"SONGS:"];
    //add songs to string in order, starting with preferred songs
    for (Song *song in songRoom.songQueue.preferredQueue.songs){
        statusString = [statusString stringByAppendingString:[NSString stringWithFormat:@"%@,%d:", song.identifier, song.voteScore]];
    }
    //then add regular songs to string
    for (Song *song in songRoom.songQueue.songs){
        statusString = [statusString stringByAppendingString:[NSString stringWithFormat:@"%@,%d:", song.identifier, song.voteScore]];
    }
    //remove trailing ':'
    statusString = [statusString substringToIndex:[statusString length] - 1];
    return statusString;
}

+ (NSString *)makePlayNextString
{
    NSString * nextString = @"NEWCS";
    return nextString;
}

+ (NSMutableDictionary *)readString:(NSString *)protocolString
{
    NSMutableDictionary * voteDict = [[NSMutableDictionary alloc] init];
    NSArray * splitString = [protocolString componentsSeparatedByString:@":"];
    
    if ([[splitString objectAtIndex:0] isEqualToString:@"VOTE"]){
        [voteDict setObject:@"VOTE" forKey:@"type"];
        [voteDict setObject:[splitString objectAtIndex:1] forKey:@"username"];
        [voteDict setObject:@([[splitString objectAtIndex:2] integerValue]) forKey:@"updown"];
        [voteDict setObject:[splitString objectAtIndex:3] forKey:@"songURI"];
        
    } else if ([[splitString objectAtIndex:0] isEqualToString:@"QUEUE"]){
        [voteDict setObject:@"QUEUE" forKey:@"type"];
        [voteDict setObject:[splitString objectAtIndex:1] forKey:@"songURI"];
        [voteDict setObject:[splitString objectAtIndex:3] forKey:@"track"];
    
    } else if ([[splitString objectAtIndex:0] isEqualToString:@"UPDATE"]){
        [voteDict setObject:@"UPDATE" forKey:@"type"];
        
    } else if ([[splitString objectAtIndex:0] isEqualToString:@"SIGNIN"]){
        [voteDict setObject:@"SIGNIN" forKey:@"type"];
        [voteDict setObject:[splitString objectAtIndex:1] forKey:@"username"];
        
    } else if ([[splitString objectAtIndex:0] isEqualToString:@"UPSR"]){
        NSUInteger len = [splitString count];
        [voteDict setObject:@"UPSR" forKey:@"type"];
        NSMutableArray *users = [[NSMutableArray alloc] init];
        NSMutableDictionary *songs = [[NSMutableDictionary alloc] init];
        int i = 1;
        while (![[splitString objectAtIndex:i] isEqualToString:@"SONGS"]){
            [users setObject:[splitString objectAtIndex:i] atIndexedSubscript:(i - 1)];
            ++i;
        }
        [voteDict setObject:users forKey:@"users"];
        while (++i < len){
            NSArray * splitSong = [[splitString objectAtIndex:i] componentsSeparatedByString:@","];
            [songs setObject:@([[splitSong objectAtIndex:1] integerValue]) forKey:[splitSong objectAtIndex:0]];
        }
        [voteDict setObject:songs forKey:@"songs"];
        
    } else if ([[splitString objectAtIndex:0] isEqualToString:@"NEWCS"]){
        [voteDict setObject:@"NEWCS" forKey:@"type"];
        
    }
    
    return voteDict;
}

@end