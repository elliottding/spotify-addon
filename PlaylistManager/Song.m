//
//  Song.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/4/14.
//
//

#import "Song.h"

NSString * const ObserveValueKeypath = @"totalScore";

@interface Song ()

@property (nonatomic, readwrite) int voteScore;

@property (nonatomic, strong, readwrite) VoteBox *voteBox;

@end

@implementation Song

- (instancetype)initWithTrackID:(int)trackID
{
    self = [super init];
    if (self)
    {
        self.voteBox = [[VoteBox alloc] init];
        [self.voteBox addObserver:self forKeyPath:ObserveValueKeypath options:0 context:nil];
        self.voteScore = 0;
        self.trackID = trackID;
    }
    return self;
}

- (void)dealloc
{
    [self.voteBox removeObserver:self forKeyPath:ObserveValueKeypath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:ObserveValueKeypath])
    {
        VoteBox *voteBox = (VoteBox *)object;
        self.voteScore = voteBox.totalScore;
    }
}

@end
