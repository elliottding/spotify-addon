//
//  User.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import <Foundation/Foundation.h>

#import <Spotify/Spotify.h>

#import "SongRoom.h"

@interface User : NSObject

// String representing the username of this User.
// NOTE: Usernames MUST be unique.
@property (nonatomic, strong) NSString *username;

// The SongRoom containing this User.
// NOTE: Do not set this property; treat as readonly. However, the readonly qualifier can't be used here
// because SongRoom needs to modify this. Need to come up with some way of qualifying this as readonly
// while still allowing SongRoom to set its value.
// If this property is modified, then the User is automatically unregistered from the previous SongRoom.
@property (nonatomic, strong) SongRoom *songRoom;

@property (nonatomic, strong) SPTSession *session;

// Initializes a User with the given username.
- (instancetype)initWithUsername:(NSString *)username;

-(void)executeDict:(NSMutableDictionary *)dict;

@end
