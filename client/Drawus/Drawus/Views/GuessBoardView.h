//
//  GuessBoardView.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuessBoardViewDelegate;

@interface GuessBoardView : UIView

@property (nonatomic, retain) id<GuessBoardViewDelegate> drDelegate;
@property (nonatomic, retain) NSArray *pathAry;

- (void)displayGuessPicture;

@end

@protocol GuessBoardViewDelegate <NSObject>

@optional
- (void)didFinishPlaybackGuessBoard:(GuessBoardView *)guessBoard;

@end
