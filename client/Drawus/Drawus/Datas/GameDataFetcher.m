//
//  GameDataFetcher.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-31.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "GameDataFetcher.h"

static GameDataFetcher *_sharedFetcher = nil;

@interface GameDataFetcher () {

}

@property (nonatomic, retain) NSMutableArray *currentGames;

@end

@implementation GameDataFetcher

@synthesize currentGames=_currentGames;
@synthesize currentIndex=_currentIndex;

#pragma mark - class methods

+ (GameDataFetcher *)sharedFetcher
{
	@synchronized(self) {
		if (_sharedFetcher == nil)
		{
			_sharedFetcher = [[GameDataFetcher alloc] init];
		}
	}
	return _sharedFetcher;
}

+ (id)alloc
{
	NSAssert(_sharedFetcher == nil, @"Attempted to allocate a second instance of a singleton");
	return [super alloc];
}

#pragma mark - private

- (void)setCurrentGame:(GameModel *)game
{
	[_currentGames replaceObjectAtIndex:_currentIndex withObject:game];
}

#pragma mark - extended

- (NSString *)searchStr
{
    NSString *urlStr = [NSString stringWithFormat:@"%@%@&uuid=%@", URLPrefix, userSearch, [[UIDevice currentDevice] uniqueIdentifier]];
    
	return urlStr;
}

- (NSString *)pushPrefixStr
{
    return nil;
}

- (NSDictionary *)pushDataDictionary
{
    return nil;
}

- (void)handleJSONRoot:(NSDictionary *)root
{
	// handle root

	NSString *message = [root objectForKey:@"message"];
    
    if ([message isEqualToString:noUser])
    {
    	[self notifyFetched:self error:[NSError errorWithDomain:@"DataFetcher" code:errorTypeNoUser userInfo:nil]];
    }
    else if ([message isEqualToString:success])
    {
    	NSDictionary *data = [root objectForKey:@"data"];

    	NSNumber *score = [data objectForKey:@"score"];
    	NSArray *gameInfo = [data objectForKey:@"gameinfo"];
    }

	// debug code
	self.currentGames = [[[NSMutableArray alloc] init] autorelease];

	[_currentGames addObject:firstGameModel()];
	[_currentGames addObject:secondGameModel()];
}

#pragma mark - public

- (NSArray *)currentGames
{
	return _currentGames;
}

- (GameModel *)currentGame
{
	return [_currentGames objectAtIndex:_currentIndex];
}

- (DrawingModel *)currentDrawing
{
	return [[self currentGame].drawings objectAtIndex:([[self currentGame].drawings count] - 1)];
}

- (WordModel *)currentWord
{
	return [self currentDrawing].word;	
}

- (NSArray *)randomWords
{
	return [WordModel randomWords];
}

- (void)correctCurrentGame:(BOOL)pass
{
	// push notify to server

	DrawingModel *drawing = [self currentDrawing];
	drawing.guessed = pass;

	GameModel *game = [self currentGame];

    NSMutableArray *anAry = [game.drawings mutableCopy];
    [anAry addObject:drawing];
    
    game.drawings = anAry;
    [anAry release];

    [self setCurrentGame:game];
	
	// [self pushData];
}

- (void)addNewGameWithPlayer:(PlayerModel *)player
{
	GameModel *newGame = [[GameModel alloc] init];
	newGame.players = [NSArray arrayWithObjects:me(), player, nil];
	newGame.currentOwner = me();
	newGame.round = [NSNumber numberWithInt:1];

	[_currentGames addObject:newGame];
    [newGame release];
    
	_currentIndex = [_currentGames count] - 1;

	// push notify to server
}

- (void)updateCurrentGameWithWord:(WordModel *)word path:(NSArray *)pathAry
{
    DrawingModel *drawing = [[DrawingModel alloc] init];

	drawing.owner  = me();
	drawing.word   = word;
	drawing.pathAry = pathAry;

    GameModel *game = [self currentGame];

    NSMutableArray *anAry = [game.drawings mutableCopy];
    [anAry addObject:drawing];
    [drawing release];
    
    game.drawings = anAry;
    [anAry release];

    [self setCurrentGame:game];

	// push notify to server
}

- (void)leaveGame:(GameModel *)game
{
	if (game.currentOwner.username == username())
	{
		game.currentOwner = [game nextOwner];
	}

	[game removePlayer:me()];

	// push notify to server
}

#pragma mark - default

- (id)init
{
	self = [super init];
	if (self)
	{
		self.currentGames = [[[NSMutableArray alloc] init] autorelease];

		[_currentGames addObject:firstGameModel()];
		[_currentGames addObject:secondGameModel()];
        [_currentGames addObject:thirdGameModel()];
        [_currentGames addObject:forthGameModel()];
	}
	return self;
}

- (void)dealloc
{
	self.currentGames = nil;

	[super dealloc];
}

@end
