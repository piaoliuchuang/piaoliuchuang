//
//  WordModelManager.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "WordModelManager.h"

static NSString *wordDB = @"word.sqlite";

@implementation WordModelManager

static WordModelManager *_sharedManager;

- (NSString *)databaseName
{
    return wordDB;
}

+ (WordModelManager *)sharedManager
{
	@synchronized(self) {
		if (!_sharedManager)
		{
			_sharedManager = [[WordModelManager alloc] init];
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
