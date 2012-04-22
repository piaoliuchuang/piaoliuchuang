//
//  ShakeDetector.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-2.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "ShakeDetector.h"

static ShakeDetector *_sharedDetector = nil;

@interface ShakeDetector () <UIAccelerometerDelegate>

@property (nonatomic, retain) NSMutableArray *kmDelegates;

@end

@implementation ShakeDetector

@synthesize kmDelegates=_kmDelegates;

#pragma mark - class methods

+ (ShakeDetector *)sharedDetector
{
	@synchronized(self) {
		if (_sharedDetector == nil)
		{
			_sharedDetector = [[ShakeDetector alloc] init];
		}
	}
	return _sharedDetector;
}

+ (id)alloc
{
	NSAssert(_sharedDetector == nil, @"Attempted to allocate a second instance of a singleton!");
	return [super alloc];
}

#pragma mark - public

- (void)addDelegate:(id<ShakeDetectorDelegate>)delegate
{
	[_kmDelegates addObject:delegate];
}

- (void)removeDelegate:(id<ShakeDetectorDelegate>)delegate
{
	[_kmDelegates removeObject:delegate];
}

- (void)enrollWhenAppActive
{
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / kAccelermeterFrequency)];
}

- (void)startDetect
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

- (void)stopDetect
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
}

#pragma mark - default

- (id)init
{
	self = [super init];
	if (self)
	{
		self.kmDelegates = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}

- (void)dealloc
{
	self.kmDelegates = nil;

	[super dealloc];
}

#pragma mark - UIAccelerometerDelegaet

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
	static NSInteger shakeCount = 0;
	static NSDate *shakeStart;

	NSDate *now = [[NSDate alloc] init];

	// 摇晃 2 秒内
	NSDate *checkDate = [[NSDate alloc] initWithTimeInterval:2.0f sinceDate:shakeStart];

	// 超过 2 秒，重新计算晃动次数
	if ([now compare:checkDate] == NSOrderedDescending || shakeStart == nil)
	{
		shakeCount = 0;
		[shakeStart release];
		shakeStart = [[NSDate alloc] init];
	}

	[now release];
	[checkDate release];

	// 三轴摇晃的G力超过 2 则列入计次, fabsf() 绝对值，去掉了 z 轴的晃动 “ || fabsf(acceleration.z) > 1.8 ”
	if (fabsf(acceleration.x) > 1.8 || fabsf(acceleration.y) > 1.8)
	{
		shakeCount ++;

		// 如果晃动计次大于 4 次，则调用 callback
		if (shakeCount > 4)
		{
			for (id<ShakeDetectorDelegate> delegate in _kmDelegates)
			{
				if (delegate != nil)
				{
					if ([delegate respondsToSelector:@selector(shakeDetectorCallback:)])	
					{
						[delegate shakeDetectorCallback:self];
					}
				}	
			}	

			shakeCount = 0;
			[shakeStart release];
			shakeStart = [[NSDate alloc] init];
		}
	}
}

@end







