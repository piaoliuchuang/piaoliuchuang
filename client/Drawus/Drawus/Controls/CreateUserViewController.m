//
//  CreateUserViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-2.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "CreateUserViewController.h"
#import "KMKeyboardContainer.h"
#import "KMEnrollView.h"
#import "PlayerDataFetcher.h"

#define PADDING 10.f
#define TEXT_LABEL_WIDTH 200.f
#define TEXT_LABEL_FONT_SIZE 18.f
#define TEXT_LABEL_CENTER_Y 150.f
#define INPUT_VIEW_WIDTH 240.f
#define INPUT_VIEW_HEIGHT 32.f

/*
 您还没有选择或输入您的用户名哦，
 您开始游戏通过用户名呢？
 用户名呢？
 还是，用户名呢？
 sorry，本小站目前只支持用户名登陆，
 近期将加入email登陆，
 新浪微博用户名登陆，
 敬请期待！ >_<
 */

#define CREATE_USER_TEXT @"您还没有注册您的用户名哦！\n您开始游戏通过用户名呢？\n用户名呢？\n还是，用户名呢？ \nsorry，本小站目前只支持用户名登陆，\n近期将加入email登陆，\n新浪微博用户名登陆，\n敬请期待！ >_< "
#define USERNAME_TITLE   @"请输入您的用户名："
#define USERNAME_RULE    @"* 4到16个英文字符或数字，区分大小写"
#define USERNAME_BEEN_USED @"您期望的用户名已经被他人抢先啦！换一个吧！"

@interface CreateUserViewController () <KMEnrollViewDelegate>

@property (nonatomic, retain) KMKeyboardContainer *keyboardContainer;
@property (nonatomic, retain) UILabel             *textLabel;
@property (nonatomic, retain) KMEnrollView        *inputView;

@end

@implementation CreateUserViewController

@synthesize keyboardContainer =_keyboardContainer;
@synthesize textLabel         =_textLabel;
@synthesize inputView         =_inputView;

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    CGRect vFrame = self.view.bounds;

    self.keyboardContainer = [[[KMKeyboardContainer alloc] initWithFrame:vFrame] autorelease];
    [self.view addSubview:_keyboardContainer];

    self.textLabel = [[[UILabel alloc] init] autorelease];
    _textLabel.text = CREATE_USER_TEXT;
    _textLabel.font = FONT_CHINESE(TEXT_LABEL_FONT_SIZE);
    [_textLabel heightToFit:TEXT_LABEL_WIDTH];
    _textLabel.center = CGPointMake(_keyboardContainer.center.x, TEXT_LABEL_CENTER_Y);
    
    [_keyboardContainer addSubview:_textLabel];
    
	CGRect uFrame      = _textLabel.frame ;
	uFrame.origin.x    = (_keyboardContainer.frame.size.width - INPUT_VIEW_WIDTH) / 2;
	uFrame.origin.y    += _textLabel.frame.size.height + PADDING;
	uFrame.size.width  = INPUT_VIEW_WIDTH;
	uFrame.size.height = INPUT_VIEW_HEIGHT;

    self.inputView = [[[KMEnrollView alloc] initWithFrame:uFrame 
                                                    title:USERNAME_TITLE 
                                              placeholder:@"用户名"
                                                     rule:USERNAME_RULE] autorelease];
    _inputView.kmDelegate = self;
    _inputView.minNum = 4;
    _inputView.maxNum = 16;
    
    [_keyboardContainer addSubview:_inputView];

	CGRect cFrame   = CLOSE_BUTTON_FRAME;
	cFrame.origin.x = _textLabel.frame.origin.x + _textLabel.frame.size.width - cFrame.size.width / 2;
	cFrame.origin.y = _textLabel.frame.origin.y - cFrame.size.height / 2;
	
    [self setCloseBtnFrame:cFrame];
}

- (void)dealloc
{
	self.keyboardContainer = nil;
	self.textLabel         = nil;
	self.inputView         = nil;

    [super dealloc];
}

#pragma mark - KMEnrollViewDelegate

- (void)enrollView:(KMEnrollView *)enrollView textFieldDidEndEditing:(UITextField *)textField
{
    // check username enable
    
    NSString *username = textField.text;
    
    BOOL available = [[PlayerDataFetcher sharedFetcher] checkUsername:username];
    
    if (available) 
    {
        setUsername(username);
        
        [self hide];
    }
    else
    {
        _textLabel.text = USERNAME_BEEN_USED;
        _textLabel.textColor = [UIColor redColor];
        [_textLabel heightToFit:TEXT_LABEL_WIDTH];
    }
}

@end
