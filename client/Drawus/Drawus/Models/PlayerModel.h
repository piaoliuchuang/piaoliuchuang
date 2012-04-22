//
//  PlayerModel.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerModel : NSObject

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSMutableArray *currentGames;

@end
