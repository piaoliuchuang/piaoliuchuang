//
//  DrawPopupButton.h
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMPopupButton.h"

typedef enum {
	DRAW_TYPE_BRUSH,
	DRAW_TYPE_ERASER
} DRAW_TYPE;

@interface DrawPopupButton : KMPopupButton

- (id)initWithVisibleFrame:(CGRect)frame type:(DRAW_TYPE)drawType;
- (void)createItems;
- (void)setBrushNibColor:(UIColor *)nibColor;

@end
