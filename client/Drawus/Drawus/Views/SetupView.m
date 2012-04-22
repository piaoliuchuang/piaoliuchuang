//
//  SetupView.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-9.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "SetupView.h"

#define introductoinText @"\n您现在在设置页面。主页面摇一摇就可以随即产生一个新游戏哦，赶快去试试吧！"
#define languageOptionText @"词库选择："
#define languageTipText @"词库选择将在你创建新游戏，加入一个新的游戏时决定您这局游戏期间所用的词库"
#define viewWidth 290.f
#define introLabelWidth 200.f
#define padding 20.f
#define languageLabelOriginY 220.f
#define languageLabelWidth 120.f

@interface SetupView ()

@property (nonatomic, retain) UIImageView        *iconView;
@property (nonatomic, retain) UILabel            *introLabel;
@property (nonatomic, retain) UILabel            *shakeView;
@property (nonatomic, retain) UILabel            *langOptionLabel;
@property (nonatomic, retain) UISegmentedControl *langOptionSegment;
@property (nonatomic, retain) UILabel *langTipLabel;

@end

@implementation SetupView

@synthesize iconView          =_iconView;
@synthesize introLabel        =_introLabel;
@synthesize shakeView         =_shakeView;
@synthesize langOptionLabel   =_langOptionLabel;
@synthesize langOptionSegment =_langOptionSegment;
@synthesize langTipLabel=_langTipLabel;

// - (void)usernameButtonClicked:(id)sender
// {
//     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"用户名修改"
//                                                        message:@"请输入用户名/n（* 4到16个英文字符或数字，区分大小写）"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"确定", nil];

//     alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    
//     [alertView show];
//     [alertView release];
// }

- (void)languageOptionActions:(id)sender
{
    UISegmentedControl *seg = sender;
    
    setGameLanguage(seg.selectedSegmentIndex);
}

- (void)dealloc
{
	self.iconView          = nil;  
	self.introLabel        = nil;
	self.shakeView         = nil; 
	self.langOptionLabel   = nil;
	self.langOptionSegment = nil;
    self.langTipLabel = nil;

	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
		self.iconView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]] autorelease];
		_iconView.center = CGPointMake(viewWidth / 2, 
                                       self.frame.origin.y + padding + _iconView.frame.size.height / 2);
		[self addSubview:_iconView];

		self.introLabel = [[[UILabel alloc] init] autorelease];	
        _introLabel.backgroundColor = [UIColor clearColor];
        _introLabel.textAlignment = UITextAlignmentCenter;
		_introLabel.text = [NSString stringWithFormat:@"hi %@!%@", username(), introductoinText];
		[_introLabel heightToFit:introLabelWidth];
		_introLabel.center = CGPointMake(viewWidth / 2, 
                                         CGRectGetMaxY(_iconView.frame) + padding + _introLabel.frame.size.height / 2);
		[self addSubview:_introLabel];

		self.langOptionLabel = [[[UILabel alloc] init] autorelease];
		_langOptionLabel.font = FONT_CHINESE(18.f);
		_langOptionLabel.text = languageOptionText;
		_langOptionLabel.backgroundColor = [UIColor clearColor];
//        [_langOptionLabel heightToFit:languageLabelWidth];
        [_langOptionLabel sizeToFit];
		_langOptionLabel.frame = CGRectMake(padding, 
                                            languageLabelOriginY,
                                            _langOptionLabel.frame.size.width, 
                                            _langOptionLabel.frame.size.height);
		[self addSubview:_langOptionLabel];

		self.langOptionSegment = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"中文词库", @"英文词库", nil]] autorelease];
		[_langOptionSegment addTarget:self action:@selector(languageOptionActions:) forControlEvents:UIControlEventValueChanged];
		_langOptionSegment.segmentedControlStyle = UISegmentedControlStyleBar;
		_langOptionSegment.selectedSegmentIndex = gameLanguage();
		_langOptionSegment.tintColor = [UIColor colorWithHexString:setup_segment_tint_color_str];
		_langOptionSegment.frame = CGRectMake((viewWidth - 200) / 2, 
                                              CGRectGetMaxY(_langOptionLabel.frame) + padding, 
                                              200,
                                              35);
		[self addSubview:_langOptionSegment];
        
        self.langTipLabel = [[[UILabel alloc] init] autorelease];
        _langTipLabel.font = FONT_DEFAULT(13.f);
        _langTipLabel.text = languageTipText;
        _langTipLabel.textColor = [UIColor grayColor];
        [_langTipLabel heightToFit:languageLabelWidth];
        _langTipLabel.frame = CGRectMake(viewWidth - padding - languageLabelWidth, 
                                         CGRectGetMaxY(_langOptionSegment.frame) + padding,
                                         _langTipLabel.frame.size.width, 
                                         _langTipLabel.frame.size.height);
        [self addSubview:_langTipLabel];

		// self.usernameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		// _usernameButton.frame = CGRectMake(45, CGRectGetMaxY(_usernameLabel.frame) + VERTICAL_PADDING, 200, 40);
		// _usernameButton.titleLabel.font = FONT_ENGLISH(15.f);
		// [_usernameButton setTitle:@"点击修改用户名" forState:UIControlStateNormal];
		// [_usernameButton addTarget:self action:@selector(usernameButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
		// [self.view addSubview:_usernameButton];
    }
    return self;
}

// #pragma mark - UIAlertViewDelegate

// - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
// {
//     if (buttonIndex == alertView.cancelButtonIndex) {
        
//     }
//     else {
//         UITextField *textField = [alertView textFieldAtIndex:0];
        
//         setUsername(textField.text);
        
//         _usernameLabel.text = [NSString stringWithFormat:@"当前用户名：%@", username()];
//         [_usernameLabel sizeToFit];
//     }
// }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
