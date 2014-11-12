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

@property (nonatomic, strong) UnsortedSongQueue *preferredQueue;

@property (nonatomic, strong, readonly) Song *nextSong;

- (void)addSong:(Song *)song;

- (void)moveToPreferred:(Song *)song;

- (void)moveToPreferred:(Song *)song toIndex:(NSUInteger)index;

- (void)removeSong:(Song *)song;

- (void)removeSongAtIndex:(NSUInteger)index;

- (void)removeTopSong;

@end
