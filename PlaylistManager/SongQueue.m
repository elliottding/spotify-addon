//
//  SongQueue.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import "SongQueue.h"

NSString *ObservePropertyName = @"voteScore";

@interface SongQueue ()

@end

@implementation SongQueue

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.preferredQueue = [[UnsortedSongQueue alloc] init];
    }
    return self;
}

- (void)dealloc
{
    while (self.count > 0)
    {
        // Deregisters self as observer for all songs
        [self removeSongAtIndex:0];
    }
}

- (Song *)nextSong
{
    if (self.preferredQueue.count > 0)
    {
        return self.preferredQueue.nextSong;
    }
    if (self.count > 0)
    {
         return super.nextSong;
    }
    return nil;
}

// Add a song to the SongQueue, preserving vote score sort ordering.
- (void)addSong:(Song *)song
{
    // Check for the default case first, to avoid unnecessary index-searching
    if (song.voteScore == 0)
    {
        // Append song to the end of the songs array
        [self appendSong:song];
    }
    else
    {
        // Sorted insert by vote score
        [self insertSong:song atIndex:[self getIndexForVoteScore:song.voteScore]];
    }
}

- (void)moveToPreferred:(Song *)song
{
    [self removeSong:song];
    [self.preferredQueue appendSong:song];
}

- (void)moveToPreferred:(Song *)song toIndex:(NSUInteger)index
{
    [self removeSong:song];
    [self.preferredQueue insertSong:song atIndex:index];
}

// Get the index of the first song with a vote score smaller than the specified vote score
// TODO: Can be made faster using binary search
- (NSUInteger)getIndexForVoteScore:(int)voteScore
{
    int i = 0;
    for (; i < self.count; i++)
    {
        Song *song = self[i];
        if (voteScore > song.voteScore)
        {
            break;
        }
    }
    return i;
}

// Overrides

- (void)insertSong:(Song *)song atIndex:(NSUInteger)index
{
    [super insertSong:song atIndex:index];
    [song addObserver:self forKeyPath:ObservePropertyName options:0 context:nil];
}

- (void)removeSong:(Song *)song
{
    NSUInteger index = [self getIndexOfSong:song];
    [self removeSongAtIndex:index];
}

- (void)removeSongAtIndex:(NSUInteger)index
{
    if (index >= self.count)
    {
        return;
    }
    Song *song = self[index];
    [super removeSongAtIndex:index];
    [song removeObserver:self forKeyPath:ObservePropertyName];
}

- (void)removeTopSong
{
    if ([self.preferredQueue containsSong:self.nextSong])
    {
        [self.preferredQueue removeSongAtIndex:0];
    }
    else
    {
        [self removeSongAtIndex:0];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    Song *song = (Song *)object;
    if ([keyPath isEqualToString:ObservePropertyName])
    {
        [self removeSong:song];
        [self addSong:song];
    }
}

@end
