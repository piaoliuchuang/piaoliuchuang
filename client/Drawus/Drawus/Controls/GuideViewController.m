//
//  GuideViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-3.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "GuideViewController.h"

#define TEXT_LABEL_WIDTH 200.f
#define TEXT_LABEL_FONT_SIZE 13.f

 #define TEXT @"游戏帮助"

@interface GuideViewController ()

@property (nonatomic, retain) UILabel *textLabel;

@end

@implementation GuideViewController

@synthesize textLabel=_textLabel;

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    self.textLabel = [[[UILabel alloc] init] autorelease];
    _textLabel.text = TEXT;
    _textLabel.font = FONT_CHINESE(TEXT_LABEL_FONT_SIZE);
    [_textLabel heightToFit:TEXT_LABEL_WIDTH];
    _textLabel.center = self.view.center;

    [self.view addSubview:_textLabel];
}

- (void)dealloc
{
    self.textLabel = nil;
    
    [super dealloc];
}

@end
