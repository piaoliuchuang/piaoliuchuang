//
//  iphone_sprintviewViewController.h
//  iphone.sprintview
//
//  Created by wangjun on 10-12-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondView.h"
@interface iphone_sprintviewViewController : UIViewController {
	SecondView *mySecondView;
	IBOutlet UIDatePicker *myDataPicker;
	IBOutlet UIView *myView;
}
@property (nonatomic,retain) SecondView *mySecondView;
@property (nonatomic,retain) UIDatePicker *myDataPicker;
@property (nonatomic,retain) UIView *myView;
-(IBAction)onClickButton:(id)sender;
@end

