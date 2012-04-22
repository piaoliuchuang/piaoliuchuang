//
//  ResultViewController.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-28.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultViewControllerDelegate;

@interface ResultViewController : UIViewController

@property (nonatomic, assign) id<ResultViewControllerDelegate> drDelegate;

@end

@protocol ResultViewControllerDelegate <NSObject>

- (void)didClickedNextButtonInResultViewController:(ResultViewController *)resultViewControler;

@end