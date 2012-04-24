//
//  TodoModel.m
//  Stack
//
//  Created by Tianhang Yu on 12-4-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "TodoModel.h"
#import "StackModelManager.h"

@implementation TodoModel

@dynamic text;

+ (NSEntityDescription *)todoDescription
{       
    return [NSEntityDescription entityForName:@"TodoModel"
                       inManagedObjectContext:[[StackModelManager sharedManager] managedObjectContext]];
}

+ (NSArray *)todos
{
    NSError * error = nil;
    
    NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[TodoModel todoDescription]];
    
    NSArray *fetchObjects = [[[StackModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest
                                                                                                    error:&error];
    [fetchRequest release];
    
    if (error == nil) 
    {
        return fetchObjects;
    }
    else 
    {
        return nil;
    }
}

+ (void)push:(NSString *)text
{
    TodoModel *model = [[[TodoModel alloc] init] autorelease];
    model.text = text; 
    
    [[StackModelManager sharedManager] save];
}

+ (BOOL)pop
{
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[TodoModel todoDescription]];
    [fetchRequest setFetchLimit:1];
    
    NSArray *fetchObjects = [[[StackModelManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest 
                                                                                                   error:&error];
    
    if (!error && [fetchObjects count] > 0) 
    {
        [[[StackModelManager sharedManager] managedObjectContext] deleteObject:[fetchObjects objectAtIndex:0]];
        
        return YES;
    }
    else 
    {
        return NO;
    }
}

@end
