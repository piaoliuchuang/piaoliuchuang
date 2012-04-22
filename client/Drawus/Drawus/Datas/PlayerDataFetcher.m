//
//  PlayerDataFetcher.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-31.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "PlayerDataFetcher.h"
#import "ASIHTTPRequest.h"

#define URL_PREFIX @"sample.player.com"

static PlayerDataFetcher *_sharedFetcher = nil;

@interface PlayerDataFetcher ()

@property (nonatomic, retain) NSArray *recentPlayers;

@end

@implementation PlayerDataFetcher

@synthesize recentPlayers=_recentPlayers;

#pragma mark - class methods

+ (PlayerDataFetcher *)sharedFetcher
{
	@synchronized(self) {
		if (_sharedFetcher == nil)
		{
			_sharedFetcher = [[PlayerDataFetcher alloc] init];
		}
	}
	return _sharedFetcher;
}

+ (id)alloc
{
	NSAssert(_sharedFetcher == nil, @"Attempted to allocate a second instance of a singleton");
	return [super alloc];
}

#pragma mark - extended

- (NSString *)searchStr
{
	return [NSString stringWithFormat:@"%@", URL_PREFIX];
}

- (void)handleJSONRoot:(NSDictionary *)root
{
	_recentPlayers = [root objectForKey:@"recent_player"];
}

#pragma mark - public

- (NSArray *)recentPlayers
{
	return _recentPlayers;	
}

- (BOOL)checkUsername:(NSString *)username
{
	// a get request

	// NSURL *url = [NSURL URLWithString:@"http://allseeing-i.com"];
	// ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
	// [request startSynchronous];
	// NSError *error = [request error];
	// if (!error) {
	// 	NSString *response = [request responseString];

	// 	// handle response
	// }
	// else 
	// {
	// 	return YES;	
	// }

	return YES;
}

#pragma mark - default

- (id)init
{
	self = [super init];
	if (self)
	{
		self.recentPlayers = recentPlayers();
	}
	return self;
}

- (void)dealloc
{
	self.recentPlayers = nil;

	[super dealloc];
}

@end

