//
//  GameStatView.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GameModel;

@interface GameStatView : UIScrollView

@property (nonatomic, retain) GameModel *game;

- (void)updateUI;

@end
