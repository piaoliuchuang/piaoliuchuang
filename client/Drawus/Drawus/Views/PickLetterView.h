//
//  PickWordView.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordModel;
@protocol PickLetterViewDelegate;

@interface PickLetterView : UIView

@property (nonatomic, retain) id<PickLetterViewDelegate> drDelegate;
@property (nonatomic, retain) WordModel *word;

- (void)resetLetterButtons;

@end

@protocol PickLetterViewDelegate <NSObject>

- (void)correctWord:(PickLetterView *)pickLetterView;

@end