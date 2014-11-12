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

@interface SongRoom ()

// Dictionary of username-User key-value pairs.
@property (nonatomic, strong) NSMutableDictionary *userDictionary;

@end

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
    [self.userDictionary setObject:user forKey:user.username];
}

- (void)unregisterUser:(User *)user
{
    [self unregisterUsername:user.username];
}

- (void)unregisterUsername:(NSString *)username
{
    [self.userDictionary removeObjectForKey:username];
}

- (User *)userWithUsername:(NSString *)username
{
    return [self.userDictionary valueForKey:username];
}

@end
