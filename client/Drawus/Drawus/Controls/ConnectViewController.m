//
//  ConnectViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-2.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "ConnectViewController.h"

#define TEXT_LABEL_WIDTH 100.f
#define TEXT_LABEL_FONT_SIZE 18.f

/*
 Oops，没有网络连接，
 请退出并连接WiFi或者3G网络，
 然后别忘了回到游戏哦! >_<
 */

/*
 Oops, no connect,
 please press HOME to exit and turn on WiFi or WWAN, 
 and don't forget come back later >_<
 */

#define CHECK_TEXT @"正在同步云端数据"
#define NO_CONNECT_TEXT @"Oops，没有网络连接，请退出并连接WiFi或者3G网络，然后别忘了回到游戏哦！ >_<"
 
@interface ConnectViewController ()

@property (nonatomic, retain) UILabel *textLabel;

@end

@implementation ConnectViewController

@synthesize drDelegate =_drDelegate;
@synthesize textLabel  =_textLabel;

- (void)dealloc
{
    self.textLabel = nil;
    
    [super dealloc];
}

#pragma mark - public

- (void)checkConnected
{
    if (KMNetworkConnected())
    {
        if (_drDelegate != nil)
        {
            if ([_drDelegate respondsToSelector:@selector(connected:)])
            {
                [_drDelegate connected:self];
            }
        }
    }
    else
    {
        if (_drDelegate != nil)
        {
            if ([_drDelegate respondsToSelector:@selector(disconnected:)])
            {
                [_drDelegate disconnected:self];
            }
        }
    }
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
#warning 风火轮

    self.textLabel = [[[UILabel alloc] init] autorelease];
    _textLabel.text = CHECK_TEXT;
    _textLabel.font = FONT_CHINESE(TEXT_LABEL_FONT_SIZE);
    [_textLabel heightToFit:TEXT_LABEL_WIDTH];
    _textLabel.center = self.view.center;

    [self.view addSubview:_textLabel];
}

#pragma mark - default

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
