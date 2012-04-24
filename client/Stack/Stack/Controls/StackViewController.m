//
//  StackViewController.m
//  Stack
//
//  Created by Tianhang Yu on 12-4-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "StackViewController.h"
#import "StackView.h"
#import "TodoModel.h"

@interface StackViewController ()

@property (nonatomic, retain) StackView *stackView;

@end

@implementation StackViewController

@synthesize stackView=_stackView;

- (void)dealloc
{
	self.stackView = nil;

	[super dealloc];
}

- (void)loadView
{
	CGRect vFrame = [UIScreen mainScreen].applicationFrame;

	self.stackView = [[[StackView alloc] initWithFrame:vFrame] autorelease];
	_stackView.backgroundColor = [UIColor clearColor];

	[_stackView setPushTarget:self selector:@selector(stackView:push:)];
	[_stackView setPopTarget:self selector:@selector(stackViewPop:)];

	self.view = _stackView;
}

#pragma mark - private

- (void)stackView:(StackView *)stackView push:(NSString *)text
{
	[TodoModel push:text];
}

- (void)stackViewPop:(StackView *)stackView
{
	[TodoModel pop];
}

@end
