//
//  ShakeDetector.h
//  Drawus
//
//  Created by Tianhang Yu on 12-4-2.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kAccelermeterFrequency 60

@protocol ShakeDetectorDelegate;

@interface ShakeDetector : NSObject

+ (ShakeDetector *)sharedDetector;

- (void)addDelegate:(id<ShakeDetectorDelegate>)delegate;
- (void)removeDelegate:(id<ShakeDetectorDelegate>)delegate;

- (void)enrollWhenAppActive;    // to fix UIAccelerometer doesn't work bug
- (void)startDetect;
- (void)stopDetect;

@end

@protocol ShakeDetectorDelegate <NSObject>

- (void)shakeDetectorCallback:(ShakeDetector *)shakedetector;

@end