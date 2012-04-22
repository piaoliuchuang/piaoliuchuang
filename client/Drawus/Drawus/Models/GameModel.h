//
//  GameModel.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

enum CURRENT_ROUND_TYPE {
	CURRENT_ROUND_TYPE_NEW_DRAW,
	CURRENT_ROUND_TYPE_WAIT_DRAW
 };

@class PlayerModel;

@interface GameModel : NSObject

@property (nonatomic, retain) NSString    *gameId;
@property (nonatomic, retain) NSArray     *players;
@property (nonatomic, retain) NSArray     *drawings;
@property (nonatomic, retain) PlayerModel *currentOwner;
@property (nonatomic, retain) NSNumber    *round;
@property (nonatomic) int currentRoundType;

+ (GameModel *)gameModelByGameId:(NSString *)gameId;
- (PlayerModel *)nextOwner;
- (void)removePlayer:(PlayerModel *)player;

@end
