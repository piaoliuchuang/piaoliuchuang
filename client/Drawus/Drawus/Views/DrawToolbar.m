//
//  DrawToolbar.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DrawToolbar.h"

@interface DrawToolbar ()

@property (nonatomic, retain) CALayer *topBorder;	// unused !

@end


@implementation DrawToolbar

@synthesize bgComponents=_bgComponents;
@synthesize topBorder=_topBorder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // do nothing
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();

	drawGradient (context, rect, _bgComponents, 3);
}

@end
