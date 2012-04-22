//
//  AudioManager.h
//  Drawus
//
//  Created by Tianhang Yu on 12-4-3.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SHORT_SOUND_TYPE_SHAKE
} SHORT_SOUND_TYPE;

@interface AudioManager : NSObject

+ (AudioManager *)sharedManager;

- (void)playSoundByType:(SHORT_SOUND_TYPE)soundType;

@end
