//
//  Drawus-Resources.h
//  Drawus
//
//  Created by Tianhang Yu on 12-4-3.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define iconName @"brush.png"

// images
#define DRAW_BOARD_BRUSH @"brush.png"
#define DRAW_BOARD_CLEAR @"clear.png"
#define MAIN_SETUP       @"setup.png"
#define MAIN_GUIDE       @"guide.png"
#define CLOSE            @"close.png"

// ttfs
#define ENGLISH_FONT_NAME @"Motor Oil 1937 M54"
#define CHINESE_FONT_NAME @"DFPShaoNvW5-GB"
#define TITLE_FONT_NAME   @"DFPMo-B5"
#define LETTER_FONT_NAME @"Maven Pro Black.otf"

// color components
extern CGFloat clearComponents[];
extern CGFloat redComponents[];
extern CGFloat greenComponents[];
extern CGFloat blueComponents[];
extern CGFloat blackComponents[];
extern CGFloat whiteComponents[];
extern CGFloat carmineComponents[]; // 洋红色
extern CGFloat pinkComponents[];
extern CGFloat wathetComponents[];	// wathet 浅蓝色

extern CGFloat cellGrayGradientComponents[];
extern CGFloat redGradientComponents2[];
extern CGFloat orangeGradientComponents2[];
extern CGFloat pathRedGradientComponents[];
extern CGFloat googleBlueGradientComponents[];
extern CGFloat grayGradientComponents[];
extern CGFloat greenGradientComponents[];
extern CGFloat redGradientComponents[];
extern CGFloat whiteGradientComponents[];
extern CGFloat blueGradientComponents[];

@interface Drawus_Resources : NSObject

@end