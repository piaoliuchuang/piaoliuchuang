//
//  GameModel.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "GameModel.h"
#import "PlayerModel.h"
#import "DrawingModel.h"

@implementation GameModel

@synthesize gameId=_gameId;
@synthesize players=_players;
@synthesize drawings=_drawings;
@synthesize currentOwner=_currentOwner;
@synthesize round=_round;
@synthesize currentRoundType=_currentRoundType;

#pragma mark - public

+ (GameModel *)gameModelByGameId:(NSString *)gameId
{
	GameModel *game = [[[GameModel alloc] init] autorelease];
	game.gameId = gameId;
	game.players = [NSArray arrayWithObjects:kimi(), fangxin(), nil];
	game.drawings = [NSArray arrayWithObjects:snow(), nil];
	game.currentOwner = fangxin();
	game.round = [NSNumber numberWithInt:1];
    
    return game;
}

- (PlayerModel *)nextOwner
{
	int currentIndex = [_players indexOfObject:_currentOwner];

	if (currentIndex < [_players count] - 1)
	{
		return [_players objectAtIndex:currentIndex + 1];
	}
	else
	{
		return [_players objectAtIndex:0];
	}
}

- (void)removePlayer:(PlayerModel *)player
{
	NSMutableArray *anAry = [_players mutableCopy];
	[anAry removeObject:player];
	self.players = anAry;
	[anAry release];
}

- (void)setPlayers:(NSArray *)players
{
    [_players release];
    _players = [players retain];
    
	for (int i = 0; i < [players count]; ++i)
	{
		PlayerModel *player = [players objectAtIndex:i];
		[player.currentGames addObject:self];
	}
}

@end
