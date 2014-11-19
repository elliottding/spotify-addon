//
//  Parser.m
//  PlaylistManager
//
//  Created by Andrew Yang on 11/17/14.
//  Copyright (c) 2014 Elliott Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parser.h"



@implementation Parser
/*
// this is for users/members of songroom
- (void)clientTransmitProtocol:(int)type{
    
    switch (type){
        case 1: sendVoteString; //send string "1 %v %s" where v is 1/0 (updown) and s is a song ID
        case 2: sendQueueString; //send string "2 %u" where u is a songURI
        case 3: sendUpdateString; //send string "3"
        case 4: sendSignString; //send string "4 %n" where n is a username
            
    }

}

// this is for users/members of songroom
- (void)clientReceiveProtocol:(NSString *)string{
    char type = [string characterAtIndex:0];
    switch (type){
        case '1': readStatusString; changeSRStatus;
            //rest of string contains update info; change local sr accordingly
        case '2': readCurrString; changeCurrSong;//change current song and update local sr accordingly
        //case '3': ; ??
    }
}

// this is for users/members of songroom
- (void)serverTransmitProtocol:(int)type{
    
    switch (type){
        case 1: createStatusString; sendStatusString;
            //create and send string "1 %s" where s describes the current status of the songroom
        case 2: sendCurrString; //create and send string "2 %s" where s is the new song playing
        //case 3: ; ??
            
    }
    
}

// this is for users/members of songroom
- (void)serverReceiveProtocol:(NSString *)string{
    char type = [string characterAtIndex:0];
    switch (type){
        case '1': readVoteString; createStatusString; sendStatusString;
            //rest of string contains up/down and trackid; update votes
        case '2': readQueueString; addSong
            //add song referenced by songURI to queue
        case '3': readUpdateString; createStatusString; sendStatusString;
            //create string with server sr info and send back to user
        case '4': readSignString; addUser; createStatusString; sendStatusString;
            //add username to sr and send sr info back to user
    }
}
*/
@end