//
//  CreateGameViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-1.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "CreateGameViewController.h"
#import "KMKeyboardContainer.h"
#import "KMEnrollView.h"

#define PADDING 10.f
#define TEXT_LABEL_WIDTH 220.f
#define TEXT_LABEL_FONT_SIZE 18.f
#define TEXT_LABEL_CENTER_Y 150.f
#define INPUT_VIEW_WIDTH 240.f
#define INPUT_VIEW_HEIGHT 32.f

/*
 您没有选择任何玩家参与当前游戏，
 您可以输入好友的用户名开始游戏，
 您和好友开始游戏通过用户名呢？
 用户名呢？
 还是，用户名呢？
 sorry，本小站目前只支持用户名登陆，
 近期将加入email登陆，
 新浪微博用户名登陆，
 敬请期待！ >_<
 */

#define CREATE_GAME_TEXT @"您没有选择任何玩家参与当前游戏。\n您可以输入好友的用户名开始游戏。\n您和好友开始游戏通过用户名呢？\n用户名呢？\n还是，用户名呢？\nsorry，本小站目前只支持用户名登陆，\n近期将加入email登陆，\n新浪微博用户名登陆，\n敬请期待！ >_<"
#define USERNAME_TITLE   @"请输入其他玩家的用户名："
#define USERNAME_RULE    @"* 4到16个英文字符或数字，区分大小写"

@interface CreateGameViewController () <KMEnrollViewDelegate>

@property (nonatomic, retain) KMKeyboardContainer *keyboardContainer;
@property (nonatomic, retain) UILabel             *textLabel;
@property (nonatomic, retain) KMEnrollView        *inputView;

@end

@implementation CreateGameViewController

@synthesize keyboardContainer =_keyboardContainer;
@synthesize textLabel         =_textLabel;
@synthesize inputView         =_inputView;

- (void)dealloc
{
    self.keyboardContainer = nil;
    self.textLabel         = nil;
    self.inputView         = nil;
    
    [super dealloc];
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    CGRect vFrame = self.view.bounds;

    self.keyboardContainer = [[[KMKeyboardContainer alloc] initWithFrame:vFrame] autorelease];
    [self.view addSubview:_keyboardContainer];

    self.textLabel = [[[UILabel alloc] init] autorelease];
    _textLabel.text = CREATE_GAME_TEXT;
    _textLabel.font = FONT_CHINESE(TEXT_LABEL_FONT_SIZE);
    [_textLabel heightToFit:TEXT_LABEL_WIDTH];
    _textLabel.center = CGPointMake(_keyboardContainer.center.x, TEXT_LABEL_CENTER_Y);
    
    [_keyboardContainer addSubview:_textLabel];
    
    CGRect iFrame = _textLabel.frame ;
    iFrame.origin.x = (_keyboardContainer.frame.size.width - INPUT_VIEW_WIDTH) / 2;
    iFrame.origin.y += _textLabel.frame.size.height + PADDING;
    iFrame.size.width = INPUT_VIEW_WIDTH;
    iFrame.size.height = INPUT_VIEW_HEIGHT;

    self.inputView = [[[KMEnrollView alloc] initWithFrame:iFrame 
                                                    title:USERNAME_TITLE 
                                              placeholder:@"用户名" 
                                                     rule:USERNAME_RULE] autorelease];
    _inputView.kmDelegate = self;
    _inputView.minNum = 4;
    _inputView.maxNum = 16;
    
    [_keyboardContainer addSubview:_inputView];

    CGRect cFrame = CLOSE_BUTTON_FRAME;
    cFrame.origin.x = _textLabel.frame.origin.x + _textLabel.frame.size.width - cFrame.size.width / 2;
    cFrame.origin.y = _textLabel.frame.origin.y - cFrame.size.height / 2;
    [self setCloseBtnFrame:cFrame];
}

#pragma mark - KMEnrollViewDelegate

- (void)enrollView:(KMEnrollView *)enrollView textFieldDidEndEditing:(UITextField *)textField
{
    // push notify
}

@end
