//
//  SongRoom.h
//  Playlist Manager
//
//  Created by Mark Landgrebe on 11/4/14.
//
//

#import <Foundation/Foundation.h>
#import "SongQueue.h"

//@class SongQueue;

@class User;

@interface SongRoom : NSObject

// Dictionary of username-User key-value pairs.
@property (nonatomic, strong) NSMutableDictionary *userDictionary;

// The name of the SongRoom.
@property (nonatomic, strong) NSString *name;

// The song queue.
@property (nonatomic, strong) SongQueue *songQueue;

// The history queue of played songs.
@property (nonatomic, strong) NSMutableArray *historyQueue;
// When a song is played, it is removed from the songQueue and appended to the history Queue

// Initializes a SongQueue with the specified name.
- (instancetype)initWithName:(NSString *)name;

// Checks if the SongRoom contains the specified User.
- (bool)containsUser:(User *)user;

// Checks if the SongRoom contains a User with the specified username.
- (bool)containsUsername:(NSString *)username;

// Registers a User to this SongRoom.
// Sets the songRoom property of the User to this SongRoom.
- (void)registerUser:(User *)user;

// Unregisters a User from this SongRoom.
// Sets the songRoom property of the User to nil.
- (void)unregisterUser:(User *)user;

// Unregisters the User with the specified username from this SongRoom.
- (void)unregisterUsername:(NSString *)username;

// Returns the User with the specified username registered to this SongRoom.
// Returns nil if none found.
- (User *)userWithUsername:(NSString *)username;

- (void)playNextSong;

@end
