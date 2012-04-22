//
//  DrSimpleIndicator.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-6.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "DrSimpleIndicator.h"

static DrSimpleIndicator *_shareIndicator = nil;

@implementation DrSimpleIndicator

+ (DrSimpleIndicator *)sharedIndicator
{
    @synchronized(self) {
        if (!_shareIndicator) {
            _shareIndicator = [[DrSimpleIndicator alloc] init];
        }
    }
    return _shareIndicator;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.rootVC.msgLabel.textColor = [UIColor colorWithHexString:@"de0c29"];
        self.rootVC.msgLabel.backgroundColor = [UIColor clearColor];
        self.rootVC.msgLabel.font = FONT_CHINESE(20.f);
        self.rootVC.msgLabel.textAlignment = UITextAlignmentCenter;
        self.rootVC.msgLabel.layer.cornerRadius = 8;
    }
    return self;
}

- (void)showMessage:(NSString *)msg withY:(CGFloat)y backgroundColor:(UIColor *)backgroundColor
{
    self.rootVC.msgLabel.backgroundColor = backgroundColor;
    
    [super showMessage:msg withY:y];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
