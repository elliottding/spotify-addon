//
//  VoteBox.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/11/14.
//
//

#import <Foundation/Foundation.h>

#import "User.h"

@interface VoteBox : NSObject

// The sum of all vote scores of all votes in this VoteBox.
@property (nonatomic, readonly) int totalScore;

// Check if this VoteBox contains a (nonzero) vote from the specified User.
- (bool)containsVoteFromUser:(User *)user;

// Check if this VoteBox contains a (nonzero) vote registered to the specified username string.
- (bool)containsVoteFromUsername:(NSString *)username;

// Set the vote score of the specified User.
- (void)setVoteScore:(int)voteScore forUser:(User *)user;

// Set the vote score registered to the specified username.
- (void)setVoteScore:(int)voteScore forUsername:(NSString *)username;

// Retrieve the vote score of the specified User.
- (int)voteScoreForUser:(User *)user;

// Retrieve the vote score registered to the specified username.
- (int)voteScoreForUsername:(NSString *)username;

// Force a recalculation of the total vote score. If all is working properly, this function should be useless
// and completely unnecessary.
- (void)recalculateTotalScore;

@end
