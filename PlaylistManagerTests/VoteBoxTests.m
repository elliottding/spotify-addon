//
//  VoteBoxTests.m
//  Playlist Manager
//
//  Created by Elliott Ding on 11/11/14.
//
//

#import <UIKit/UIKit.h>

#import <XCTest/XCTest.h>

#import "User.h"

#import "VoteBox.h"

NSString * const username1 = @"user1";

NSString * const username2 = @"user2";

@interface VoteBoxTests : XCTestCase
{
    VoteBox *voteBox1;
    User *user1;
    User *user2;
}

@end

@implementation VoteBoxTests

- (void)setUp
{
    [super setUp];
    voteBox1 = [[VoteBox alloc] init];
    user1 = [[User alloc] initWithUsername:username1];
    user2 = [[User alloc] initWithUsername:username2];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)test_init
{
    XCTAssertEqual(0, voteBox1.totalScore, @"totalScore was not initialized to 0.");
}

- (void)test_containsVoteFromUser
{
    [voteBox1 setVoteScore:1 forUser:user1];
    XCTAssert([voteBox1 containsVoteFromUser:user1], @"Returned false even though vote was registered");
    XCTAssertFalse([voteBox1 containsVoteFromUser:user2], @"Returned true even though vote was not registered");
    
    [voteBox1 setVoteScore:0 forUser:user1];
    XCTAssertFalse([voteBox1 containsVoteFromUser:user1], @"Returned true even though vote score for user is 0");
}

- (void)test_setVoteScore_forUser
{
    [voteBox1 setVoteScore:1 forUser:user1];
    XCTAssert([voteBox1 containsVoteFromUser:user1], @"Returned false even though vote was registered");
    XCTAssertEqual(1, voteBox1.totalScore, @"totalScore count is incorrect");
    
    [voteBox1 setVoteScore:2 forUser:user2];
    XCTAssertEqual(3, voteBox1.totalScore, @"totalScore count is incorrect");
    
    [voteBox1 setVoteScore:-3 forUser:user1];
    XCTAssertEqual(-1, voteBox1.totalScore, @"totalScore count is incorrect");
}

- (void)test_voteScoreForUser
{
    XCTAssertEqual(0, [voteBox1 voteScoreForUser:user1], @"No vote registered to user should return 0");
    
    [voteBox1 setVoteScore:2 forUser:user1];
    XCTAssertEqual(2, [voteBox1 voteScoreForUser:user1], @"Vote score incorrect");
    
    [voteBox1 setVoteScore:-1 forUser:user1];
    [voteBox1 setVoteScore:5 forUser:user2];
    XCTAssertEqual(-1, [voteBox1 voteScoreForUser:user1], @"Vote score incorrect; possibly affected by vote from another user");
}

@end
