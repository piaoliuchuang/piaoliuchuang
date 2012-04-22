//
//  RoundRectButton.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-5.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "RoundRectButton.h"

@interface RoundRectButton () {
    
    UIView *_touchView;
    CGFloat _scale;     // 使 button 的实际大小大于可视区域
}

@property (nonatomic, retain) UILabel *coverLabel;

@end

@implementation RoundRectButton

@synthesize bgColor=_bgColor;
@synthesize coverLabel=_coverLabel;

#pragma mark - default

- (id)init
{
    self = [super init];
    if (self) {
        
        _scale = 0.8;
        
        self.coverLabel = [[[UILabel alloc] init] autorelease];
        _coverLabel.backgroundColor = [UIColor blackColor];
        _coverLabel.alpha = 0.6f;
        _coverLabel.hidden = YES;
        [self addSubview:_coverLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect subRect = self.bounds;
    subRect.size.width *= _scale;
    subRect.size.height *= _scale;
    subRect.origin.x = (self.bounds.size.width - subRect.size.width) / 2;
    subRect.origin.y = (self.bounds.size.height - subRect.size.height) / 2;
    
    _coverLabel.frame = subRect;
    _coverLabel.layer.cornerRadius = subRect.size.width / 8;
}

- (void)dealloc
{
    self.coverLabel = nil;
    
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect subRect = rect;
    subRect.size.width *= _scale;
    subRect.size.height *= _scale;
    subRect.origin.x = (rect.size.width - subRect.size.width) / 2;
    subRect.origin.y = (rect.size.height - subRect.size.height) / 2;
    
    CGFloat radius = subRect.size.width / 8;
    
    drawRoundRect(context, subRect, radius, _bgColor);
}

#pragma mark - UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    _coverLabel.hidden = NO;
    
    UITouch *touch = [touches anyObject];
    _touchView = touch.view;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    _coverLabel.hidden = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    _coverLabel.hidden = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    
    if (touch.view != _touchView) {
        _coverLabel.hidden = YES;
    }
}

@end
