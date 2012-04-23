//
//  DrNavigationController.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMNavigationController.h"

typedef enum {
    titleViewTypeNormal,
    titleViewTypeLeftNil,
    titleViewTypeRightNil
} titleViewType;

typedef enum {
    popViewTypeCreateGame,
    popViewTypeCreateUser,
    popViewTypeConnect
} popViewType;

@interface DrNavigationController : KMNavigationController

- (void)setDrTitle:(NSString *)drTitle type:(titleViewType)type;
- (void)showPopViewByType:(popViewType)type;
- (void)hidePopViewByType:(popViewType)type;

@end
