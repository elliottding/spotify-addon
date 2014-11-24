//
//  UnsortedSongQueue.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import <Foundation/Foundation.h>

#import "Song.h"

@interface UnsortedSongQueue : NSObject

@property (nonatomic, strong) NSMutableArray *songs;

// The next Song to be played from this queue.
@property (nonatomic, strong, readonly) Song *nextSong;

// The total number of Songs in this queue.
@property (nonatomic) NSUInteger count;

// Adds a Song to the end of the queue.
- (void)appendSong:(Song *)song;

// Checks if the queue contains the specified Song.
- (bool)containsSong:(Song *)song;

// Returns the index for the specified Song in the queue.
// Returns -1 if the specified Song is not in the queue.
- (int)getIndexOfSong:(Song *)song;

// Inserts a Song into the queue at the given index.
- (void)insertSong:(Song *)song atIndex:(NSUInteger)index;

// Moves a Song in the queue to the given index.
- (void)moveSong:(Song *)song toIndex:(NSUInteger)index;

// Moves the Song at index1 in the queue to index2.
- (void)moveSongAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2;

// Removes the given Song from the queue.
- (void)removeSong:(Song *)song;

// Removes the Song at the given index from the queue.
- (void)removeSongAtIndex:(NSUInteger)index;

// For subscripting support.
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

// For subscripting support.
- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end
