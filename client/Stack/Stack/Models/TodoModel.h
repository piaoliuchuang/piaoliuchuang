//
//  TodoModel.h
//  Stack
//
//  Created by Tianhang Yu on 12-4-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface TodoModel : NSManagedObject

@property (nonatomic, retain) NSString * text;

+ (NSArray *)todos;

+ (void)push:(NSString *)text;
+ (BOOL)pop;

@end
