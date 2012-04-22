//
//  PlayerDataFetcher.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-31.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DataFetcher.h"

@interface PlayerDataFetcher : DataFetcher

+ (PlayerDataFetcher *)sharedFetcher;

- (NSArray *)recentPlayers;
- (BOOL)checkUsername:(NSString *)username;

@end
