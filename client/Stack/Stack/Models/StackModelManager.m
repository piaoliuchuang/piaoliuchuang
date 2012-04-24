//
//  StackModelManager.m
//  Stack
//
//  Created by Tianhang Yu on 12-4-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "StackModelManager.h"

static NSString *stackDB = @"stack.sqlite";

@implementation StackModelManager

static StackModelManager *_sharedManager = nil;

- (NSString *)databaseName
{
    return stackDB;
}

+ (StackModelManager *)sharedManager
{
    @synchronized(self) {
        if (!_sharedManager) 
        {
            _sharedManager = [[StackModelManager alloc] init];
        }
    }
    return _sharedManager;
}

+ (id)alloc
{
	NSAssert(_sharedManager == nil, @"Attempt to allocate a second instance of a singleton!");
    
	return [super alloc];
}

@end
