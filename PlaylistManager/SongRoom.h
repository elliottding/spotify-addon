//
//  SongRoom.h
//  Playlist Manager
//
//  Created by Mark Landgrebe on 11/4/14.
//
//

#import <Foundation/Foundation.h>

@class SongQueue;

@class User;

@interface SongRoom : NSObject

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) SongQueue *songQueue;

- (instancetype)initWithName:(NSString *)name;

- (bool)containsUser:(User *)user;

- (bool)containsUsername:(NSString *)username;

- (void)registerUser:(User *)user;

- (void)unregisterUser:(User *)user;

- (void)unregisterUsername:(NSString *)username;

- (User *)userWithUsername:(NSString *)username;

@end
