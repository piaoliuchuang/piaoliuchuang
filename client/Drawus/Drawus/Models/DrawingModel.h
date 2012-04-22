//
//  DrawingModel.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameModel;
@class PlayerModel;
@class WordModel;

@interface DrawingModel : NSObject

@property (nonatomic, retain) PlayerModel *owner;
@property (nonatomic, retain) GameModel *game;
@property (nonatomic, retain) WordModel *word;
@property (nonatomic, retain) NSArray *pathAry;
@property (nonatomic) BOOL guessed;

@end
