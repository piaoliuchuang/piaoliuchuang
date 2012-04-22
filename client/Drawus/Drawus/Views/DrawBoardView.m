//
//  DrawBoardView.m
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-21.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DrawBoardView.h"
#import "DrawPathModel.h"

#define BACKGROUND_COLOR_STRING   @"#ffffff"

@interface DrawBoardView () {

    BOOL _recording;
    
    CGPoint _startPoint;
    CGPoint _endPoint;

    NSDate *_lastTime;
}

@property (nonatomic, retain) UIView *fromAnimationView;
@property (nonatomic, retain) UIView *toAnimationView;

@end

@implementation DrawBoardView

@synthesize drDelegate        =_drDelegate;
@synthesize pathAry           =_pathAry;
@synthesize strokeColor       =_strokeColor;
@synthesize preStrokeColor    =_preStrokeColor;
@synthesize eraser            =_eraser;
@synthesize lineWidth         =_lineWidth;
@synthesize fromAnimationView =_fromAnimationView;
@synthesize toAnimationView   =_toAnimationView;

#pragma mark - public

- (void)clearDrawing
{
    DrawPathModel *path = [[DrawPathModel alloc] init];
    path.clear = YES;
    [_pathAry addObject:path];
    [path release];

    [self setNeedsDisplay];

    if ([[[UIDevice currentDevice] systemVersion] compare:@"5.1" options:NSNumericSearch] == NSOrderedSame) {
        
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

- (void)finishDrawing
{
    _recording = NO;
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR_STRING];

        self.strokeColor = [UIColor blackColor];

        _lineWidth   = firstLevelLineWidth;

        _pathAry = [[NSMutableArray alloc] init];

        self.fromAnimationView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
        [self addSubview:_fromAnimationView];
        
        self.toAnimationView = [[[UIView alloc] initWithFrame:self.bounds] autorelease];
    }
    return self;
}

- (void)dealloc
{
    self.preStrokeColor    = nil;
    self.strokeColor       = nil;
    self.fromAnimationView = nil;
    self.toAnimationView   = nil;

    [_pathAry release];
    _pathAry = nil;

    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{    
    CGContextRef context = UIGraphicsGetCurrentContext();

    for (int i = 0; i < [_pathAry count]; ++i)
    {
        DrawPathModel *path = [_pathAry objectAtIndex:i];

        CGContextSetLineWidth(context, path.lineWidth);

        if (path.clear)
        {
            clearDraw(context, rect, self.backgroundColor);
        }
        else
        {
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
    
    _startPoint = _endPoint;
}

#pragma mark - UITouch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _startPoint = [[touches anyObject] locationInView:self];

    if (!_recording) {
        _recording = YES;
        
        [_lastTime release];
        _lastTime = [[NSDate date] retain];    
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    _endPoint = [[touches anyObject] locationInView:self];

    DrawPathModel *path = [[DrawPathModel alloc] init];
    path.strokeColor  = _strokeColor;
    path.eraser       = _eraser;
    path.lineWidth    = _lineWidth;

    NSDate *now = [NSDate date];
    path.lastInterval = [now timeIntervalSinceDate:_lastTime];
    
    [_lastTime release];
    _lastTime = [now retain];
    
    path.startPoint   = _startPoint;
    path.endPoint     = _endPoint;
    [_pathAry addObject:path];
    [path release];
        
    [self setNeedsDisplay];
}

@end
