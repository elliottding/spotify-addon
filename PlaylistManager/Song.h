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

@interface Song : NSObject

// Unique identifier.
@property (nonatomic) int trackID;

//the corresponding spotify track
@property (nonatomic) SPTTrack* track;

// The VoteBox representing all user votes registered to this Song.
@property (nonatomic, strong, readonly) VoteBox *voteBox;

// Returns the sum total of all votes in the vote box registered to this Song.
@property (nonatomic, readonly) int voteScore;

// Initialize a new Song with the specified track ID.
- (instancetype)initWithTrackID:(int)trackID andTrack:(SPTTrack*)track;

@end
