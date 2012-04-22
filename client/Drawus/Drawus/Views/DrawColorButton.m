//
//  DrawColorButton.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-23.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DrawColorButton.h"
#import <QuartzCore/QuartzCore.h>

#define BORDER_WIDTH 2.f
#define BACKGROUND_COLOR_STRING @"#c0c0c0"

@interface DrawColorButton ()

@end


@implementation DrawColorButton

@synthesize colorComponents=_colorComponents;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

    CGContextSetStrokeColorSpace(context, space);
    CGContextSetFillColorSpace(context, space);
    CGContextSetStrokeColor(context, whiteComponents);
    CGContextSetFillColor(context, _colorComponents);
    
    CGContextSetLineWidth(context, BORDER_WIDTH);

    CGFloat gap = 2.f;
    CGFloat radius = (rect.size.width - 2*gap) / 4;

    CGFloat minX = CGRectGetMinX(rect) + gap, midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect) - gap;
    CGFloat minY = CGRectGetMinY(rect) + gap, midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect) - gap;

    CGContextMoveToPoint(context, minX, midY);

    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);

    CGContextClosePath(context);

    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGColorSpaceRelease(space);
}

@end
