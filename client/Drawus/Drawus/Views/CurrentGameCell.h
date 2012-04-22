//
//  CurrentGameCell.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
	通过 NORMAL_GAME_CELL_HEIGHT 判断当前 cell 是否 expand
	由于 tableView 在 load cells 的时候默认设置 cell height 为 44.f
	因此不可以把 NORMAL_GAME_CELL_HEIGHT 设置为 44.f
*/

#define NORMAL_GAME_CELL_HEIGHT 40.f
#define EXPANDED_GAME_CELL_HEIGHT 200.f


@class GameModel;
@protocol CurrentGameCellDelegate;

@interface CurrentGameCell : UITableViewCell

@property (nonatomic, retain) id<CurrentGameCellDelegate> drDelegate;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) GameModel *game;
@property (nonatomic) BOOL expanded;
@property (nonatomic) PLAYER_STATUS playerStatus;

- (void)updateUI;

@end


@protocol CurrentGameCellDelegate <NSObject>

- (void)didClickedPlayBtnInCurrentGameCell:(CurrentGameCell *)currentGameCell;
- (void)didClickedDeleteBtnInCurrentGameCell:(CurrentGameCell *)currentGameCell;

@end