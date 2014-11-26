//
//  Song.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/4/14.
//
//

#import "Song.h"

#import "SpotifyRetriever.h"

NSString * const ObserveValueKeypath = @"totalScore";

@interface Song ()

//@property (nonatomic, readwrite) int voteScore;

@property (nonatomic, strong, readwrite) VoteBox *voteBox;

@end

@implementation Song

- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    if (self)
    {
        self.voteBox = [[VoteBox alloc] init];
        [self.voteBox addObserver:self forKeyPath:ObserveValueKeypath options:0 context:nil];
        self.voteScore = 0;
        self.identifier = identifier;
        [self loadTrackWithIdentifier:self.identifier];
    }
    return self;
}

- (instancetype)initWithTrackID:(int)trackID andTrack:(SPTTrack *)track
{
    self = [super init];
    if (self)
    {
        self.voteBox = [[VoteBox alloc] init];
        [self.voteBox addObserver:self forKeyPath:ObserveValueKeypath options:0 context:nil];
        self.voteScore = 0;
        self.trackID = trackID;
        self.track = track;
    }
    return self;
}

- (instancetype)initWithTrack:(SPTTrack *)track
{
    self = [super init];
    if (self)
    {
        self.voteBox = [[VoteBox alloc] init];
        [self.voteBox addObserver:self forKeyPath:ObserveValueKeypath options:0 context:nil];
        self.voteScore = 0;
        self.track = track;
    }
    return self;
}

- (void)setDelegate:(id<SongDelegate>)delegate
{
    if (delegate != self.delegate)
    {
        // if track has already loaded, immediately send a trackDidLoad message
        if (self.track != nil)
        {
            [delegate trackDidLoad];
        }
        _delegate = delegate;
    }
}

- (void)loadTrackWithIdentifier:(NSString *)identifier
{
    [[SpotifyRetriever instance] requestTrack:identifier callback:^(NSError *error, SPTTrack *track)
     {
         if (error != nil)
         {
             NSLog(@"*** error: %@", error);
             return;
         }
         self.track = track;
         [self.delegate trackDidLoad];
     }];
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
