//
//  RecentPlayerCell.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NORMAL_PLAYER_CELL_HEIGHT 40.f
#define EXPANDED_PLAYER_CELL_HEIGHT 150.f

@class PlayerModel;

@interface RecentPlayerCell : UITableViewCell

@property (nonatomic, retain) PlayerModel *player;

- (void)updateUI;

@end


// @portocol RecentPlayerCellDelegate <NSObject>

// - (void)didClickedPlay

// @end
