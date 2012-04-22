//
//  iphone_sprintviewViewController.m
//  iphone.sprintview
//
//  Created by wangjun on 10-12-1.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//
#import "iphone_sprintviewViewController.h"
#import <QuartzCore/QuartzCore.h> 
@implementation iphone_sprintviewViewController
@synthesize mySecondView,myDataPicker,myView;
-(void) viewDidLoad
{
	self.mySecondView=[[SecondView alloc] init];
	NSArray *array =[[NSBundle mainBundle] loadNibNamed:@"SecondView"
												  owner:self options:nil];
	self.mySecondView=[array objectAtIndex:0];
	//将图层的边框设置为圆脚 
    self.myView.layer.cornerRadius = 8; 
	self.myView.layer.masksToBounds = YES; 
    //给图层添加一个有色边框 
	self.myView.layer.borderWidth = 8; 
	self.myView.layer.borderColor = [[UIColor colorWithRed:0.52 green:0.09 blue:0.07 alpha:0.5] CGColor]; 
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidUnload {
	self.mySecondView=nil;
	self.myDataPicker=nil;
	self.myView=nil;
}
- (void)dealloc {
	[self.myView release];
	[self.mySecondView release];
	[self.myDataPicker release];
    [super dealloc];
}
-(IBAction)onClickButton:(id)sender
{
	if ([sender tag]==0) {
		[self.view addSubview:mySecondView];
	}else if ([sender tag]==1) {
		[mySecondView removeFromSuperview];
	}else {
		NSLog(@"==%@",self.myDataPicker.date);
		[mySecondView removeFromSuperview];
	}
}
@end
