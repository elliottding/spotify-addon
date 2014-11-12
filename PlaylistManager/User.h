//
//  User.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import <Foundation/Foundation.h>

#import "SongRoom.h"

@interface User : NSObject

// Usernames MUST be unique
@property (nonatomic, strong, readonly) NSString *username;

@property (nonatomic, weak) SongRoom *songRoom;

- (instancetype)initWithUsername:(NSString *)username;

@end
