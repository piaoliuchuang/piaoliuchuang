//
//  PickBlank.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-27.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickBlank : UIView {
    
    BOOL _solid;
}

- (id)initWithFrame:(CGRect)frame solid:(BOOL)solid;

@end
