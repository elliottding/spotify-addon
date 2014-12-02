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
    statusString = [statusString stringByAppendingString:@"PSONGS:"];
    //add songs to string in order, starting with preferred songs
    for (Song *song in songRoom.songQueue.preferredQueue.songs){
        statusString = [statusString stringByAppendingString:[NSString stringWithFormat:@"%@,%d:", song.identifier, song.voteScore]];
    }
    statusString = [statusString stringByAppendingString:@"RSONGS:"];
    //then add regular songs to string
    for (Song *song in songRoom.songQueue.songs){
        statusString = [statusString stringByAppendingString:[NSString stringWithFormat:@"%@,%d:", song.identifier, song.voteScore]];
    }
    statusString = [statusString stringByAppendingString:@"HIST:"];
    //then add history queue
    for (Song *song in songRoom.historyQueue){
        statusString = [statusString stringByAppendingString:[NSString stringWithFormat:@"%@:", song.identifier]];
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

+ (NSString *)makeRemoveString:(NSString *)songURI
{
    NSString *queueString = [@"REMOVE:" stringByAppendingString:songURI];
    return queueString;
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
        NSMutableDictionary *prefsongs = [[NSMutableDictionary alloc] init];
        NSMutableDictionary *regsongs = [[NSMutableDictionary alloc] init];
        NSMutableArray *history = [[NSMutableArray alloc] init];
        int i = 0;
        //set users array
        while (![[splitString objectAtIndex:++i] isEqualToString:@"PSONGS"]){
            [users setObject:[splitString objectAtIndex:i] atIndexedSubscript:(i - 1)];
        }
        [voteDict setObject:users forKey:@"users"];
        //set preferred songs dictionary
        while (![[splitString objectAtIndex:++i] isEqualToString:@"RSONGS"]){
            NSArray * splitSong = [[splitString objectAtIndex:i] componentsSeparatedByString:@","];
            [prefsongs setObject:@([[splitSong objectAtIndex:1] integerValue]) forKey:[splitSong objectAtIndex:0]];
        }
        //set regular songs dictionary
        [voteDict setObject:prefsongs forKey:@"prefsongs"];
        while (![[splitString objectAtIndex:++i] isEqualToString:@"HIST"]){
            NSArray * splitSong = [[splitString objectAtIndex:i] componentsSeparatedByString:@","];
            [regsongs setObject:@([[splitSong objectAtIndex:1] integerValue]) forKey:[splitSong objectAtIndex:0]];
        }
        //set history array
        [voteDict setObject:regsongs forKey:@"regsongs"];
        int j = 0;
        while (++i < len){
            [history setObject:[splitString objectAtIndex:i] atIndexedSubscript:j++];
        }
        [voteDict setObject:history forKey:@"history"];
        
    } else if ([[splitString objectAtIndex:0] isEqualToString:@"NEWCS"]){
        [voteDict setObject:@"NEWCS" forKey:@"type"];
        
    }
    else if ([[splitString objectAtIndex:0] isEqualToString:@"REMOVE"]){
        [voteDict setObject:@"REMOVE" forKey:@"type"];
        [voteDict setObject:[splitString objectAtIndex:1] forKey:@"songURI"];
    }
    return voteDict;
}

@end