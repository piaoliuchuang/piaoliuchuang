//
//  WordPickButton.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "LetterButton.h"

#define BORDER_WIDTH 2.f

@interface LetterButton () {

    CGFloat _scale;
}

@end

@implementation LetterButton

@synthesize drDelegate  = _drDelegate;
@synthesize letter      =_letter;
@synthesize preFrame    =_preFrame;
@synthesize borderColor =_borderColor;
@synthesize bgColor     =_bgColor;

#pragma mark - private

- (void)btnClicked:(id)sender
{
    if (_drDelegate != nil)
    {
        if ([_drDelegate respondsToSelector:@selector(didClickedLetterButton:)])
        {
            [_drDelegate didClickedLetterButton:self];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();

   CGRect subRect = self.bounds;
   subRect.size.width *= _scale;
   subRect.size.height *= _scale;
   subRect.origin.x = (self.bounds.size.width - subRect.size.width) / 2;
   subRect.origin.y = (self.bounds.size.height - subRect.size.height) / 2;
   
   CGFloat radius = subRect.size.width / 4;
   
   drawBorderRoundRect(context, subRect, radius, _bgColor, _borderColor, BORDER_WIDTH);
}

#pragma mark - public

- (void)setLetter:(char)letter
{
	_letter = letter;

    [self setTitle:[NSString stringWithFormat:@"%c", _letter] forState:UIControlStateNormal];
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _scale = 0.88;
        
        self.titleLabel.font = FONT_LETTER(20.f);
        [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
