//
//  Song.h
//  Playlist Manager
//
//  Created by Elliott Ding on 11/4/14.
//
//

#import <Spotify/Spotify.h>
#import <Foundation/Foundation.h>

#import "VoteBox.h"

@protocol SongDelegate <NSObject>

- (void)trackDidLoad;

@end

@interface Song : NSObject

// Unique identifier.
@property (nonatomic) int trackID;

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, weak) id <SongDelegate> delegate;

// The corresponding Spotify track.
@property (nonatomic, strong) SPTTrack *track;

// The VoteBox representing all user votes registered to this Song.
@property (nonatomic, strong, readonly) VoteBox *voteBox;

// The sum total of all votes in the vote box registered to this Song.
@property (nonatomic) int voteScore;

// Initializes a new Song with the specified track ID.
- (instancetype)initWithTrackID:(int)trackID andTrack:(SPTTrack *)track;

- (instancetype)initWithTrack:(SPTTrack *)track;

- (instancetype)initWithIdentifier:(NSString *)identifier;

@end
