//
//  iphone_sprintviewAppDelegate.h
//  iphone.sprintview
//
//  Created by wangjun on 10-12-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iphone_sprintviewViewController;

@interface iphone_sprintviewAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iphone_sprintviewViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iphone_sprintviewViewController *viewController;

@end

