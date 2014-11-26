//
//  SongRoom.m
//  Playlist Manager
//
//  Created by Mark Landgrebe on 11/4/14.
//
//

#import "SongRoom.h"

#import "SongQueue.h"

#import "User.h"
/*
@interface SongRoom ()

users has been made public

@end
*/
@implementation SongRoom

- (instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self)
    {
        self.name = name;
        self.userDictionary = [[NSMutableDictionary alloc] init];
        self.songQueue = [[SongQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    for (NSString *username in self.userDictionary)
    {
        [self unregisterUsername:username];
    }
}

- (bool)containsUser:(User *)user
{
    return [self containsUsername:user.username];
}

- (bool)containsUsername:(NSString *)username
{
    return [self userWithUsername:username] != nil;
}

- (void)registerUser:(User *)user
{
    user.songRoom = self;
    [self.userDictionary setObject:user forKey:user.username];
    [user addObserver:self forKeyPath:@"songRoom" options:NSKeyValueObservingOptionNew context:nil];
}

// Internal only; use unregisterUser: instead.
- (void)removeUser:(User *)user
{
    [user removeObserver:self forKeyPath:@"songRoom"];
    [self.userDictionary removeObjectForKey:user.username];
}

- (void)unregisterUser:(User *)user
{
    if ([self containsUser:user])
    {
        [self removeUser:user];
        user.songRoom = nil;
    }
}

- (void)unregisterUsername:(NSString *)username
{
    [self unregisterUser:[self.userDictionary objectForKey:username]];
}

- (User *)userWithUsername:(NSString *)username
{
    return [self.userDictionary valueForKey:username];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (![keyPath isEqualToString:@"songRoom"])
    {
        return;
    }
    User *user = (User *)object;
    SongRoom *newSongRoom = [change objectForKey:NSKeyValueChangeNewKey];
    if (newSongRoom != self)
    {
        [self removeUser:user];
    }
}

- (void)playSong:(Song *)song
{
    [self.songQueue removeSongFromEitherQueue:song];
    [self.historyQueue insertObject:song atIndex:0];
}

- (void)playNextSong
{
    [self.historyQueue insertObject:self.songQueue.nextSong atIndex:0];
    [self.songQueue removeTopSong];
}

@end
