//
//  DataFetcher.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    errorTypeUnknown = 0,
    errorTypeFailed,
    errorTypeNetwork,
    errorTypeNoUser,
} errorType;

@protocol DataFetcherDelegate;

@interface DataFetcher : NSObject

- (NSString *)searchStr;
- (NSString *)pushPrefixStr;
- (NSDictionary *)pushDataDictionary;
- (void)handleJSONRoot:(NSDictionary *)root;

- (void)notifyFetched:(DataFetcher *)dataFetcher error:(NSError *)error;
- (void)fetchData;
- (void)pushData;
- (void)addDelegate:(id<DataFetcherDelegate>)delegate;
- (void)removeDelegate:(id<DataFetcherDelegate>)delegate;

@end

@protocol DataFetcherDelegate <NSObject>

@optional
- (void)dataFetched:(DataFetcher *)dataFetcher error:(NSError *)error;
- (void)dataFetchFailed:(DataFetcher *)dataFetcher error:(NSError *)error;

- (void)dataPushed:(DataFetcher *)dataFetcher;
- (void)dataPushFailed:(DataFetcher *)dataFetcher error:(NSError *)error;

@end
