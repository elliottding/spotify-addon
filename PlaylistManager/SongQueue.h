//
//  SongQueue.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/10/14.
//
//

#import <Foundation/Foundation.h>
#import "Song.h"

#import "UnsortedSongQueue.h"

@interface SongQueue : UnsortedSongQueue

// The queue for preferred Songs. Bypasses vote score when determining the next Song.
@property (nonatomic, strong) UnsortedSongQueue *preferredQueue;

// The next Song to be played. Priority is given for songs in the preferred queue.
// If no Songs are in the preferred queue, then priority is given based on vote score.
@property (nonatomic, strong, readonly) Song *nextSong;

// Adds a Song to the regular voting queue.
- (void)addSong:(Song *)song;

// Moves the specified Song from the regular queue to the preferred queue.
// If the Song is not in the regular queue, simply add it to the preferred queue.
- (void)moveToPreferred:(Song *)song;

// Moves the specified Song from the regular queue to the preferred queue at the specified index.
- (void)moveToPreferred:(Song *)song toIndex:(NSUInteger)index;

// Removes the specified Song from the regular queue.
// NOTE: use [preferredQueue removeSong:song] to remove a Song from the preferred queue.
- (void)removeSong:(Song *)song;

// Removes the Song at the specified index from the regular queue.
- (void)removeSongAtIndex:(NSUInteger)index;

// Removes the top priority Song from the queue.
- (void)removeTopSong;

// 11/18/14
// Proceed to next song in response to NEWCS message from server
- (void)proceedToNextSong;

@end
