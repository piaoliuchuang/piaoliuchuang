//
//  DrNavigationBar.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-3.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DrNavigationBar.h"

@implementation DrNavigationBar

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    drawGradient(context, rect, googleBlueGradientComponents, 4);
    
    UIColor *cornerColor = [UIColor colorWithHexString:@"000000"];

    CGFloat cornerRadius = 5.f;
    drawRoundCorner(context, rect, cornerRadius, CORNER_TYPE_TOP_LEFT, cornerColor);
    drawRoundCorner(context, rect, cornerRadius, CORNER_TYPE_TOP_RIGHT, cornerColor);
}

@end
