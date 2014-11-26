//
//  User.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import "User.h"

@implementation User

- (instancetype)initWithUsername:(NSString *)username
{
    self = [super init];
    if (self)
    {
        _username = username;
    }
    return self;
}

-(void)executeDict:(NSMutableDictionary *)dict{
    NSAssert(NO, @"Subclasses need to overwrite this method");
}

@end
