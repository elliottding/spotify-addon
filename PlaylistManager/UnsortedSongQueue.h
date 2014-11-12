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

@property (nonatomic, strong, readonly) Song *nextSong;

@property (nonatomic) NSUInteger count;

- (void)appendSong:(Song *)song;

- (bool)containsSong:(Song *)song;

- (int)getIndexOfSong:(Song *)song;

- (void)insertSong:(Song *)song atIndex:(NSUInteger)index;

- (void)moveSong:(Song *)song toIndex:(NSUInteger)index;

- (void)moveSongAtIndex:(NSUInteger)index1 toIndex:(NSUInteger)index2;

- (void)removeSong:(Song *)song;

- (void)removeSongAtIndex:(NSUInteger)index;

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

- (id)objectAtIndexedSubscript:(NSUInteger)index;

@end
