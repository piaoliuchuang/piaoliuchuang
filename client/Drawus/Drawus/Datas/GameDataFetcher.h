//
//  GameDataFetcher.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-31.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DataFetcher.h"
#import "GameModel.h"
#import "DrawingModel.h"
#import "WordModel.h"
#import "PlayerModel.h"

typedef enum
{
    errorTypeUnknown = 0,
    errorTypeFailed,
    errorTypeNetwork,
    errorTypeNoUser
} errorType;

@interface GameDataFetcher : DataFetcher

@property (nonatomic) int currentIndex;

+ (GameDataFetcher *)sharedFetcher;

- (NSArray *)currentGames;
- (GameModel *)currentGame;
- (DrawingModel *)currentDrawing;
- (WordModel *)currentWord;
- (NSArray *)randomWords;

- (void)correctCurrentGame:(BOOL)pass;
- (void)addNewGameWithPlayer:(PlayerModel *)player;
- (void)updateCurrentGameWithWord:(WordModel *)word path:(NSArray *)pathAry;
- (void)leaveGame:(GameModel *)game;

@end
