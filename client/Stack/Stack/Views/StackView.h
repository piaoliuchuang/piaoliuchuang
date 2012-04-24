//
//  StackView.h
//  Stack
//
//  Created by Tianhang Yu on 12-4-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackView : UIView

@property (nonatomic, retain) NSArray *elements;

- (void)setPushTarget:(id)target selector:(SEL)selector;
- (void)setPopTarget:(id)target selector:(SEL)selector;

@end
