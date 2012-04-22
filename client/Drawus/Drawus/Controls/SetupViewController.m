//
//  SetupViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-1.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "SetupViewController.h"
#import "SetupView.h"

#define HORIZONTAL_PADDING 10.f
#define VERTICAL_PADDING 25.f

@interface SetupViewController () <UIAlertViewDelegate>

@property (nonatomic, retain) SetupView *setupView;

@end

@implementation SetupViewController

@synthesize setupView=_setupView;

#pragma mark - public

- (void)setVisible:(BOOL)visible
{
    if (!visible) 
    {

    }
    
    [super setVisible:visible];
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor colorWithHexString:setup_vc_background_color_str];

    self.setupView = [[[SetupView alloc] initWithFrame:self.view.bounds] autorelease];
    [self.view addSubview:_setupView];
}

- (void)dealloc
{
    self.setupView = nil;
    
    [super dealloc];
}

@end
