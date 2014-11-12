//
//  UnsortedSongQueue.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import "UnsortedSongQueue.h"

@interface UnsortedSongQueue ()

@property (nonatomic, strong) NSMutableArray *songs;

@end

@implementation UnsortedSongQueue

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.songs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSUInteger)count
{
    return self.songs.count;
}

- (Song *)nextSong
{
    if (self.count > 0)
    {
        return self.songs[0];
    }
    return nil;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
    return self.songs[index];
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
    if ([obj class] != [Song class])
    {
        return;
    }
    self.songs[index] = obj;
}

- (int)getIndexOfSong:(Song *)song
{
    for (int i = 0; i < self.songs.count; i++)
    {
        if (self.songs[i] == song)
        {
            return i;
        }
    }
    return -1;
}

- (void)appendSong:(Song *)song
{
    [self insertSong:song atIndex:self.songs.count];
}

- (bool)containsSong:(Song *)song
{
    return [self.songs containsObject:song];
}

- (void)removeSongAtIndex:(NSUInteger)index
{
    [self.songs removeObjectAtIndex:index];
}

- (void)removeSong:(Song *)song
{
    int index = [self getIndexOfSong:song];
    if (index < 0)
    {
        return;
    }
    [self.songs removeObject:song];
}

// Insert a song into the songs array at the specified index
// Override this
- (void)insertSong:(Song *)song atIndex:(NSUInteger)index
{
    [self.songs insertObject:song atIndex:index];
}

- (void)moveSong:(Song *)song toIndex:(NSUInteger)index
{
    [self removeSong:song];
    [self insertSong:song atIndex:index];
}

- (void)moveSongAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2
{
    Song *song = self.songs[index1];
    [self removeSongAtIndex:index1];
    [self insertSong:song atIndex:index2];
}

@end
