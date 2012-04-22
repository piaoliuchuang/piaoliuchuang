//
//  WordPickButton.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LetterButtonDelegate;

@interface LetterButton : UIButton

@property (nonatomic, assign) id<LetterButtonDelegate> drDelegate;

@property (nonatomic) char letter;
@property (nonatomic) CGRect preFrame;
@property (nonatomic, retain) UIColor *borderColor;
@property (nonatomic, retain) UIColor *bgColor;

@end

@protocol LetterButtonDelegate <NSObject>

- (void)didClickedLetterButton:(LetterButton *)letterButton;

@end