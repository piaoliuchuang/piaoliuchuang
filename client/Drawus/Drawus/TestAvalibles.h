//
//  TestAvalibles.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "GameModel.h"
#import "PlayerModel.h"
#import "DrawingModel.h"
#import "WordModel.h"

static inline WordModel* happy () {

	WordModel *word = [[[WordModel alloc] init] autorelease];
	word.wordStr = @"happy";
	word.wordType = WORD_TYPE_NORMAL;
    
    return word;
}

static inline WordModel* justin () {

	WordModel *word = [[[WordModel alloc] init] autorelease];
	word.wordStr = @"justin";
	word.wordType = WORD_TYPE_FAMOUS_PERSON;
    
    return word;
}

static inline WordModel* ladygaga () {
    
	WordModel *word = [[[WordModel alloc] init] autorelease];
	word.wordStr = @"ladygaga";
	word.wordType = WORD_TYPE_FAMOUS_PERSON;
    
    return word;
}

static inline PlayerModel* kimi () {

	PlayerModel *player = [[[PlayerModel alloc] init] autorelease];
	player.username = @"kimi";
	player.email = @"kimirius@gmail.com";
	player.currentGames = nil;

	return player;
}

static inline PlayerModel* fangxin () {

	PlayerModel *player = [[[PlayerModel alloc] init] autorelease];
	player.username = @"fangxin";
	player.email = @"kathyrani@gmail.com";
	player.currentGames = nil;

	return player;
}

static inline PlayerModel* wendy () {

	PlayerModel *player = [[[PlayerModel alloc] init] autorelease];
	player.username = @"wendy";
	player.email = @"peirowendy@gmail.com";
	player.currentGames = nil;

	return player;
}

static inline DrawingModel* snow () {

	DrawingModel *drawing = [[[DrawingModel alloc] init] autorelease];
	drawing.owner = wendy();
	drawing.game = nil;
	drawing.word = justin();

	return drawing;
}

static inline DrawingModel* rain () {

	DrawingModel *drawing = [[[DrawingModel alloc] init] autorelease];
	drawing.owner = kimi();
	drawing.game = nil;
	drawing.word = happy();

	return drawing;
}

static inline GameModel* firstGameModel () {

	GameModel *game = [[[GameModel alloc] init] autorelease];
	game.players = [NSArray arrayWithObjects:kimi(), fangxin(), nil];
	game.drawings = [NSArray arrayWithObjects:snow(), rain(), nil];
	game.currentOwner = fangxin();
	game.round = [NSNumber numberWithInt:2];
	game.currentRoundType = CURRENT_ROUND_TYPE_NEW_DRAW;

	return game;
}

static inline GameModel* secondGameModel () {

	GameModel *game = [[[GameModel alloc] init] autorelease];
	game.players = [NSArray arrayWithObjects:kimi(), fangxin(), wendy(), nil];
	game.drawings = [NSArray arrayWithObjects:snow(), nil];
	game.currentOwner = fangxin();
	game.round = [NSNumber numberWithInt:1];
	game.currentRoundType = CURRENT_ROUND_TYPE_WAIT_DRAW;

	return game;
}

static inline GameModel* thirdGameModel () {
    
	GameModel *game = [[[GameModel alloc] init] autorelease];
	game.players = [NSArray arrayWithObjects:kimi(), fangxin(), wendy(), nil];
	game.drawings = [NSArray arrayWithObjects:snow(), nil];
	game.currentOwner = kimi();
	game.round = [NSNumber numberWithInt:1];
	game.currentRoundType = CURRENT_ROUND_TYPE_WAIT_DRAW;
    
	return game;
}

static inline GameModel* forthGameModel () {
    
	GameModel *game = [[[GameModel alloc] init] autorelease];
	game.players = [NSArray arrayWithObjects:kimi(), fangxin(), nil];
	game.drawings = [NSArray arrayWithObjects:snow(), rain(), nil];
	game.currentOwner = kimi();
	game.round = [NSNumber numberWithInt:2];
	game.currentRoundType = CURRENT_ROUND_TYPE_NEW_DRAW;
    
	return game;
}

static inline NSArray* currentGames () {
    
    return [NSArray arrayWithObjects:firstGameModel(), secondGameModel(), thirdGameModel(), forthGameModel(), nil];
}

static inline NSArray* recentPlayers () {

	return [NSArray arrayWithObjects:kimi(), fangxin(), wendy(), nil];
}
