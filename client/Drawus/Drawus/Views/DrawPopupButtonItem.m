//
//  DrawPopupButtonItem.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DrawPopupButtonItem.h"

@implementation DrawPopupButtonItem

@synthesize lineWidth=_lineWidth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	// CGContext
	CGContextRef context = UIGraphicsGetCurrentContext();

	CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

	CGContextSetFillColorSpace(context, space);
	CGContextSetFillColor(context, whiteComponents);

	CGRect centerRect = CGRectMake(CGRectGetMidX(rect) - _lineWidth/2,
                                   CGRectGetMidY(rect) - _lineWidth/2,
                                   _lineWidth,
                                   _lineWidth);
	CGContextFillEllipseInRect(context, centerRect);

	CGColorSpaceRelease(space);
}

@end
