//
//  DrawPopupButton.m
//  DrawBoard
//
//  Created by Tianhang Yu on 12-3-22.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DrawPopupButton.h"
#import "DrawPopupButtonItem.h"

#define POPUP_CENTER_COLOR_STRING @"#dbdbdb"
#define POPUP_SELECT_COLOR_STRING @"#219df3"
#define ITEM_COUNT 4

@interface BrushButton : UIButton

@property (nonatomic, retain) UIColor *nibColor;

@end

@implementation BrushButton

@synthesize nibColor=_nibColor;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect subRect = rectWithPadding(rect, 3.f);

    drawBrush(context, subRect, _nibColor);       
}

@end

@interface EraserButton : UIButton

@end

@implementation EraserButton

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect subRect = rectWithPadding(rect, 3.f);
    
    drawEraser(context, subRect);       
}

@end

@implementation DrawPopupButton

- (void)setBrushNibColor:(UIColor *)nibColor
{
    ((BrushButton *)self.centerBtn).nibColor = nibColor;
    [self.centerBtn setNeedsDisplay];
}

- (void)createItems
{
	NSMutableArray *items = [[NSMutableArray alloc] init];

	for (int i = 0; i < LEVELS_LINE_WIDTH; ++i)
	{
		DrawPopupButtonItem *item = [[DrawPopupButtonItem alloc] init];
        item.backgroundColor = [UIColor colorWithHexString:POPUP_CENTER_COLOR_STRING];
        item.index = i;
		
        switch (i) {
        	case 0:
        	{
        		item.lineWidth = firstLevelLineWidth;
        		break;
        	}
        	case 1:
        	{
        		item.lineWidth = secondLevelLineWidth;
        		break;
        	}
        	case 2:
        	{
        		item.lineWidth = thirdLevelLineWidth;
        		break;
        	}
        	case 3:
        	{
        		item.lineWidth = forthLevelLineWidth;
        		break;
        	}
        }

		[items addObject:item];
		[item release];
	}

	self.itemAry = items;
	[items release];

	self.selectColor = [UIColor colorWithHexString:POPUP_SELECT_COLOR_STRING];
    self.unSelectColor = [UIColor colorWithHexString:POPUP_CENTER_COLOR_STRING];
}

- (id)initWithVisibleFrame:(CGRect)frame type:(DRAW_TYPE)drawType
{
    UIButton *centerBtn = nil;
    
    if (drawType == DRAW_TYPE_BRUSH)
    {
        centerBtn = [BrushButton buttonWithType:UIButtonTypeCustom];
    }
    else if (drawType == DRAW_TYPE_ERASER)
    {
        centerBtn = [EraserButton buttonWithType:UIButtonTypeCustom];
    }
    
    self = [super initWithVisibleFrame:frame itemCount:ITEM_COUNT centerBtn:centerBtn];
    
    if (self) {
        // do sth.
    }
    return self;
}

/*
- (void)drawRect:(CGRect)rect
{
	// draw code
}
*/

@end
