//
//  PickBlank.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-27.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "PickBlank.h"

#define BORDER_WIDTH 4.f

@implementation PickBlank

- (id)initWithFrame:(CGRect)frame solid:(BOOL)solid
{
    self = [super initWithFrame:frame];
    if (self) {
    	self.backgroundColor = [UIColor clearColor];
        
        _solid = solid;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

    CGContextSetStrokeColorSpace(context, space);
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithHexString:pick_blank_border_color_str].CGColor);
    if (_solid) {
        CGContextSetFillColorSpace(context, space);
        CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:pick_blank_border_color_str].CGColor);
    }

    CGContextSetLineWidth(context, BORDER_WIDTH);
    CGContextSetLineCap(context, kCGLineCapRound);

    CGFloat radius = rect.size.width / 3;

    CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);

    CGContextMoveToPoint(context, minX, midY);

    CGContextAddArcToPoint(context, minX, minY, midX, minY, radius);
    CGContextAddArcToPoint(context, maxX, minY, maxX, midY, radius);
    CGContextAddArcToPoint(context, maxX, maxY, midX, maxY, radius);
    CGContextAddArcToPoint(context, minX, maxY, minX, midY, radius);

    CGContextClosePath(context);

    CGContextDrawPath(context, _solid ? kCGPathFillStroke : kCGPathStroke);

    CGColorSpaceRelease(space);
}

@end
