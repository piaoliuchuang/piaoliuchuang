//
//  Utilities.h
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#ifndef DrawBoard_Utilities_h
#define DrawBoard_Utilities_h

static inline void logFrame (CGRect rect, NSString *prefix) {

  NSLog (@"\n%@ frame: %f, %f, %f, %f", prefix, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
}

static inline CGFloat heightOfContent (NSString *contentStr, CGFloat fixWidth, UIFont *contentFont) {    
    CGFloat textHeight = 0;
    
    if ([contentStr length] > 0) {
        CGSize size = [contentStr sizeWithFont:contentFont
                             constrainedToSize:CGSizeMake(fixWidth, 9999.f)
                                 lineBreakMode:UILineBreakModeCharacterWrap];
        textHeight = size.height;
    }
    
    return textHeight;
}

#define FONT_DEFAULT(x) [UIFont systemFontOfSize:(x)]
#define FONT_BOLD_DEFAULT(x) [UIFont boldSystemFontOfSize:(x)]
#define FONT_ENGLISH(x) [UIFont fontWithName:ENGLISH_FONT_NAME size:(x)]
#define FONT_CHINESE(x) [UIFont fontWithName:CHINESE_FONT_NAME size:(x)]
#define FONT_TITLE(x) [UIFont fontWithName:TITLE_FONT_NAME size:(x)]
#define FONT_LETTER(x) [UIFont fontWithName:LETTER_FONT_NAME size:(x)]

#endif
