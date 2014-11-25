//
//  VoteBox.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/11/14.
//
//
#import "User.h"
#import "VoteBox.h"

@interface VoteBox ()

@property (nonatomic, readwrite) int totalScore;

@property (nonatomic, strong) NSMutableDictionary *voteDictionary;

@end

@implementation VoteBox

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.totalScore = 0;
        self.voteDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (bool)containsVoteFromUser:(User *)user
{
    return [self containsVoteFromUsername:user.username];
}

- (bool)containsVoteFromUsername:(NSString *)username
{
    return [self voteScoreForUsername:username] != 0;
}

- (void)setVoteScore:(int)voteScore forUser:(User *)user
{
    [self setVoteScore:voteScore forUsername:user.username];
}

// voteScore will be restricted to +1 or -1 when voting through the user interface
- (void)setVoteScore:(int)voteScore forUsername:(NSString *)username
{
    if (username == nil)
    {
        // We don't want to modify _totalScore in this case, so immediately return.
        return;
    }
    
    // Get the old vote score for this username.
    int previousScore = [self voteScoreForUsername:username];
    
    // If voteScore == 0, then scoreObj is nil.
    NSNumber *scoreObj = nil;
    if (voteScore != 0)
    {
        scoreObj = [NSNumber numberWithInt:voteScore];
    }
    
    // If scoreObj is nil, then this removes the username key from the dictionary, so that we save space.
    [self.voteDictionary setValue:scoreObj forKey:username];
    
    // Modify total vote score by the amount that vote score changed for this username.
    self.totalScore += voteScore - previousScore;
}

- (int)voteScoreForUser:(User *)user
{
    return [self voteScoreForUsername:user.username];
}

- (int)voteScoreForUsername:(NSString *)username
{
    NSNumber *scoreObj = [self.voteDictionary objectForKey:username];
    // If username is not found in dictionary, return 0 for no vote score.
    if (scoreObj == nil)
    {
        return 0;
    }
    return [scoreObj intValue];
}

// If all is working correctly, this function should be useless, and do nothing.
- (void)recalculateTotalScore
{
    self.totalScore = 0;
    for (NSString *username in self.voteDictionary)
    {
        int voteScore = [self voteScoreForUsername:username];
        self.totalScore += voteScore;
    }
}

@end
