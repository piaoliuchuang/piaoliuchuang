//
//  DataFetcher.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DataFetcher.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "NSDictionary_JSONExtensions.h"

@interface DataFetcher () <ASIHTTPRequestDelegate> {

	BOOL _fetching;
	BOOL _pushing;
}

@property (nonatomic, retain) NSMutableArray *drDelegates;
@property (nonatomic, retain) ASIHTTPRequest *request;
@property (nonatomic, retain) ASIFormDataRequest *formRequest;

@end

@implementation DataFetcher

@synthesize drDelegates =_drDelegates;
@synthesize request     =_request;
@synthesize formRequest =_formRequest;

#pragma mark - default

- (void)dealloc
{
	[_request clearDelegatesAndCancel];
    
	self.drDelegates = nil;
	self.request     = nil;
	self.formRequest = nil;

	[super dealloc];
}

- (id)init
{
	self = [super init];
	if (self)
	{
		self.drDelegates = [[[NSMutableArray alloc] init] autorelease];
	}
    return self;
}

#pragma mark - extended

- (NSString *)searchStr
{
	// should be extended

	return nil;
}

- (NSString *)pushPrefixStr
{
	// should be extended

	return nil;
}

- (NSDictionary *)pushDataDictionary
{
	// should be extended

	return nil;
}

- (void)handleJSONRoot:(NSDictionary *)root
{
	// should be extended
}

#pragma mark - public

- (void)notifyFetched:(DataFetcher *)dataFetcher error:(NSError *)error
{
	for (id<DataFetcherDelegate> delegate in _drDelegates)
	{
		if (delegate != nil)
		{
			if ([delegate respondsToSelector:@selector(dataFetched:error:)])	
			{
				[delegate dataFetched:self error:error];
			}
		}	
	}	
}

- (void)addDelegate:(id<DataFetcherDelegate>)delegate
{
	[_drDelegates addObject:delegate];
}

- (void)removeDelegate:(id<DataFetcherDelegate>)delegate
{
	[_drDelegates removeObject:delegate];
}

- (void)fetchData
{
	if (!KMNetworkConnected())
	{
		for (id<DataFetcherDelegate> delegate in _drDelegates)
		{
			if (delegate != nil)
			{
				if ([delegate respondsToSelector:@selector(dataFetchFailed:error:)])	
				{
					[delegate dataFetchFailed:self error:[NSError errorWithDomain:@"DataFetcher" code:errorTypeNetwork userInfo:nil]];
				}
			}	
		}	
	}
	else
	{
		if (!_fetching)
		{
			_fetching = YES;

			NSString *urlStr = [self searchStr];

			self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
			[_request setDelegate:self];
			[_request startAsynchronous];
		}
	}
}

- (void)pushData
{
	if (!KMNetworkConnected())
	{
		for (id<DataFetcherDelegate> delegate in _drDelegates)
		{
			if (delegate != nil)
			{
				if ([delegate respondsToSelector:@selector(dataPushFailed:error:)])	
				{
					[delegate dataPushFailed:self error:[NSError errorWithDomain:@"DataFetcher" code:errorTypeNetwork userInfo:nil]];
				}
			}	
		}
	}
	else
	{
		if (!_pushing)
		{
			_pushing = YES;

			self.formRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[self pushPrefixStr]]];
			NSDictionary *tmpDict = [self pushDataDictionary];
            for (NSString *key in tmpDict.allKeys) {
                [_formRequest setPostValue:[tmpDict objectForKey:key] forKey:key];
            }
            [_formRequest setDelegate:self];
            [_formRequest startAsynchronous];
		}
	}
}

#pragma mark - ASIHTTPRequestDelegate

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSData *responseData = [request responseData];
	NSDictionary *root = [NSDictionary dictionaryWithJSONData:responseData error:nil];

	[self handleJSONRoot:root];

	if (request == _request)
	{	
		// do sth.

		_fetching = NO;		
	}
	else if (request == _formRequest)
	{

		for (id<DataFetcherDelegate> delegate in _drDelegates)
		{
			if (delegate != nil)
			{
				if ([delegate respondsToSelector:@selector(dataPushed:)])	
				{
					[delegate dataPushed:self];
				}
			}	
		}		

		_pushing = NO;
	}
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
	if (request == _request)
	{
		[self notifyFetched:self error:[NSError errorWithDomain:@"DataFetcher" code:errorTypeFailed userInfo:nil]];

		_fetching = NO;
	}
	else if (request == _formRequest)
	{
		for (id<DataFetcherDelegate> delegate in _drDelegates)
		{
			if (delegate != nil)
			{
				if ([delegate respondsToSelector:@selector(dataPushFailed:error:)])	
				{
					[delegate dataPushFailed:self error:[NSError errorWithDomain:@"DataFetcher" code:errorTypeFailed userInfo:nil]];
				}
			}	
		}		

		_pushing = NO;	
	}
}

@end
