//
//  WordModel.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "WordModel.h"

@implementation WordModel

@synthesize wordStr=_wordStr;
@synthesize wordType =_wordType;

+ (NSArray *)randomWords
{
	return [NSArray arrayWithObjects:happy(), justin(), ladygaga(), nil];
}

@end
