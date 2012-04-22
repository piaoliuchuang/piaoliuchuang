//
//  CoreDataModelManager.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "CoreDataModelManager.h"

static NSString *drawusDB = @"drawus.sqlite";

@implementation CoreDataModelManager

static CoreDataModelManager *_sharedManager;

- (NSString *)databaseName
{
    return drawusDB;
}

+ (CoreDataModelManager *)sharedManager
{
	@synchronized(self) {
		if (!_sharedManager)
		{
			_sharedManager = [[CoreDataModelManager alloc] init];
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
