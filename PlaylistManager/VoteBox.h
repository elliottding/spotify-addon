//
//  VoteBox.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/11/14.
//
//

#import <Foundation/Foundation.h>

//#import "User.h"
@class User;

@interface VoteBox : NSObject

// The sum of all vote scores of all votes in this VoteBox.
@property (nonatomic, readonly) int totalScore;

// Checks if this VoteBox contains a (nonzero) vote from the specified User.
- (bool)containsVoteFromUser:(User *)user;

// Checks if this VoteBox contains a (nonzero) vote registered to the specified username string.
- (bool)containsVoteFromUsername:(NSString *)username;

// Sets the vote score of the specified User.
- (void)setVoteScore:(int)voteScore forUser:(User *)user;

// Sets the vote score registered to the specified username.
- (void)setVoteScore:(int)voteScore forUsername:(NSString *)username;

// Retrieves the vote score of the specified User.
- (int)voteScoreForUser:(User *)user;

// Retrieves the vote score registered to the specified username.
- (int)voteScoreForUsername:(NSString *)username;

// Forces a recalculation of the total vote score. If all is working properly, this function should be useless
// and completely unnecessary.
- (void)recalculateTotalScore;

// Generate a string representation of a user vote (called by
// - (NSString *)makeVoteString:(U

@end
