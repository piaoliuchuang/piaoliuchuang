//
//  GuessBoardView.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "GuessBoardView.h"
#import "DrawPathModel.h"

#define BACKGROUND_COLOR_STRING   @"#ffffff"

@interface GuessBoardView () {

    int _index;\
}

@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, retain) UIView  *fromAnimationView;
@property (nonatomic, retain) UIView  *toAnimationView;

@end

@implementation GuessBoardView

@synthesize drDelegate        =_drDelegate;
@synthesize pathAry           =_pathAry;
@synthesize timer             =_timer;
@synthesize fromAnimationView =_fromAnimationView;
@synthesize toAnimationView   =_toAnimationView;

#pragma mark - private

- (void)playbackDidFinish
{
    if (_drDelegate != nil)
    {
        if ([_drDelegate respondsToSelector:@selector(didFinishPlaybackGuessBoard:)]) {
            [_drDelegate didFinishPlaybackGuessBoard:self];
        }
    }
}

- (void)drawFrame
{
    if (_index < [_pathAry count]) 
    {
        [self setNeedsDisplay];

        DrawPathModel *path = [_pathAry objectAtIndex:_index];

        if (path.clear)
        {
            if ([[[UIDevice currentDevice] systemVersion] compare:@"5.1" options:NSNumericSearch] == NSOrderedSame) 
            {
                CATransition *animation = [CATransition animation];
                animation.delegate = self;
                animation.duration = 0.7f;
                animation.timingFunction = UIViewAnimationCurveEaseInOut;
                animation.fillMode = kCAFillModeForwards;
                animation.removedOnCompletion = YES;
                animation.type = @"suckEffect"; // 103
                
                [self.layer addAnimation:animation forKey:@"animation"];    
            }
            else
            {
                [UIView transitionFromView:_fromAnimationView 
                                    toView:_toAnimationView 
                                  duration:0.7
                                   options:UIViewAnimationOptionTransitionCurlUp
                                completion:^(BOOL finished) {
                                    [_fromAnimationView removeFromSuperview];
                                    self.fromAnimationView = _toAnimationView;
                                    [self addSubview:_fromAnimationView];
                                    self.toAnimationView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
                                }];
            }   
        }
        
        _index ++;
        
        if (_index < [_pathAry count]) {
            DrawPathModel *nextPath = [_pathAry objectAtIndex:_index];
            
            [_timer invalidate];
            self.timer = [NSTimer timerWithTimeInterval:nextPath.lastInterval > 30.0 ? 30.0 : nextPath.lastInterval
                                                 target:self
                                               selector:@selector(drawFrame)
                                               userInfo:nil
                                                repeats:NO];
            
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];   
        }
        else {
            [_timer invalidate];
            self.timer = nil;
            
            [self playbackDidFinish];
        }
    }
}

#pragma mark - public

- (void)displayGuessPicture
{
    _index = 0;

    [self drawFrame];  
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR_STRING];

        self.fromAnimationView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        [self addSubview:_fromAnimationView];
        
        self.toAnimationView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.timer = nil;
    self.fromAnimationView = nil;
    self.toAnimationView   = nil;

	[super dealloc];
}

- (void)drawRect:(CGRect)rect
{    
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (int i = 0; i < _index; ++i)
    {
        DrawPathModel *path = [_pathAry objectAtIndex:i];

        if (path.clear)
        {
            clearDraw(context, rect, self.backgroundColor);
        }
        else
        {
            CGContextSetLineWidth(context, path.lineWidth);

            if (path.eraser)
            {
                CGContextSetBlendMode(context, kCGBlendModeCopy);    
            }
            else
            {
                CGContextSetBlendMode(context, kCGBlendModeNormal);   
            }
            
            CGContextSetLineCap(context, kCGLineCapRound);
            CGContextSetStrokeColorWithColor(context, path.strokeColor.CGColor);
            CGContextSetFillColorWithColor(context, path.strokeColor.CGColor);

            CGContextBeginPath(context);
            CGContextMoveToPoint(context, path.startPoint.x, path.startPoint.y);
            CGContextAddLineToPoint(context, path.endPoint.x, path.endPoint.y);
            CGContextStrokePath(context);             
        }
    }
}

@end
