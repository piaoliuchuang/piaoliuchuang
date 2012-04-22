//
//  DrawBoardView.h
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-21.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DrawBoardViewDelegate;

@interface DrawBoardView : UIView 

@property (nonatomic, assign) id<DrawBoardViewDelegate> drDelegate;
@property (nonatomic, readonly) NSMutableArray *pathAry;

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *preStrokeColor;
@property (nonatomic) BOOL eraser;
@property (nonatomic) CGFloat lineWidth;

- (void)clearDrawing;
- (void)finishDrawing;

@end

@protocol DrawBoardViewDelegate <NSObject>

@end