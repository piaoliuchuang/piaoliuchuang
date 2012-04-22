//
//  ConnectViewController.h
//  Drawus
//
//  Created by Tianhang Yu on 12-4-2.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "KMPopViewController.h"

@protocol ConnectViewControllerDelegate;

@interface ConnectViewController : KMPopViewController

@property (nonatomic, assign) id<ConnectViewControllerDelegate> drDelegate;

- (void)checkConnected;

@end

@protocol ConnectViewControllerDelegate <NSObject>

- (void)connected:(ConnectViewController *)connectVC;
- (void)disconnected:(ConnectViewController *)connectVC;

@end