//
//  WordModel.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	WORD_TYPE_NORMAL,
	WORD_TYPE_USER_MAKE,
	WORD_TYPE_BOOK,
	WORD_TYPE_MOVIE,
	WORD_TYPE_TVSHOW,
	WORD_TYPE_FAMOUS_PERSON,
	WORD_TYPE_FAMOUS_PLACE,
	WORD_TYPE_COMPANY,
	WORD_TYPE_COMIC,
	WORD_TYPE_COMIC_STAR
} wordType;


@interface WordModel : NSObject

@property (nonatomic, retain) NSString *wordStr;
@property (nonatomic) wordType wordType;

+ (NSArray *)randomWords;

@end
