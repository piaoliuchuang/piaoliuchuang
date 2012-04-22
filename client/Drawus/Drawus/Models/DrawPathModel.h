//
//  DrawLineModel.h
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DrawPathModel : NSObject

@property (nonatomic, retain) UIColor *strokeColor;

@property (nonatomic) BOOL clear;
@property (nonatomic) BOOL eraser;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) NSTimeInterval lastInterval;

@end
