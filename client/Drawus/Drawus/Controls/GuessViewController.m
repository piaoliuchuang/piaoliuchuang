//
//  GuessViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-27.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "GuessViewController.h"
#import "DrNavigationController.h"
#import "ResultViewController.h"
#import "PickWordViewController.h"
#import "GuessBoardView.h"
#import "PickLetterView.h"
#import "RoundRectButton.h"
#import "KMKeyboardContainer.h"
#import "KMEnrollView.h"
#import "DrSimpleIndicator.h"
#import "GameDataFetcher.h"

#define PASS_BUTTON_FRAME CGRectMake(270, 5, 44, 40)
#define RESET_BUTTON_FRAME CGRectMake(240, 245, 74, 40)
#define REPLAY_BUTTON_FRAME CGRectMake(10, 5, 44, 40)

#define guess_board_height 366.f
#define WORD_PICK_VIEW_HEIGHT 120.f
#define input_field_width 240.f
#define input_field_height 32.f
#define padding 5.f

@interface CoverButton : UIButton

@end

@implementation CoverButton

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    drawGradient(context, rect, redGradientComponents2, 3);
}

@end

@interface GuessViewController () <ResultViewControllerDelegate, PickLetterViewDelegate, UITextFieldDelegate, GuessBoardViewDelegate> {

    DrNavigationController *_nav;
    NSString *_wordStr;
}

@property (nonatomic, retain) UIButton             *coverButton;
@property (nonatomic, retain) GuessBoardView       *guessBoard;
@property (nonatomic, retain) PickLetterView       *pickLetterView;
@property (nonatomic, retain) KMKeyboardContainer  *keyboardContainer;
@property (nonatomic, retain) UILabel              *inputLabel;
@property (nonatomic, retain) UITextField          *inputField;
@property (nonatomic, retain) ResultViewController *resultView;
@property (nonatomic, retain) RoundRectButton      *replayButton;
@property (nonatomic, retain) RoundRectButton      *passButton;
@property (nonatomic, retain) RoundRectButton      *resetButton;

@end

@implementation GuessViewController

@synthesize coverButton       =_coverButton;
@synthesize guessBoard        =_guessBoard;
@synthesize pickLetterView    =_pickLetterView;
@synthesize keyboardContainer =_keyboardContainer;
@synthesize inputLabel        =_inputLabel;
@synthesize inputField         =_inputField;
@synthesize resultView        =_resultView;
@synthesize replayButton      =_replayButton;
@synthesize passButton        =_passButton;
@synthesize resetButton       =_resetButton;

#pragma mark - private

- (void)leftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked:(id)sender
{
    self.resultView = [[[ResultViewController alloc] init] autorelease];
    _resultView.drDelegate = self;
    [UIView transitionFromView:_nav.animationView
                        toView:_resultView.view 
                      duration:0.7f 
                       options:UIViewAnimationOptionTransitionCurlDown
                    completion:nil];
}

- (void)passButtonClicked:(id)sender
{
    self.resultView = [[[ResultViewController alloc] init] autorelease];
    _resultView.drDelegate = self;
    [UIView transitionFromView:_nav.animationView
                        toView:_resultView.view 
                      duration:0.7f 
                       options:UIViewAnimationOptionTransitionCurlDown
                    completion:^(BOOL finished){
                        [[GameDataFetcher sharedFetcher] correctCurrentGame:YES];
                    }];
}

- (void)resetButtonClicked:(id)sender
{
    [_pickLetterView resetLetterButtons];
}

- (void)replayButtonClicked:(id)sender
{
    if (_coverButton.hidden == NO) {
        _coverButton.hidden = YES;
    }
    
    [_guessBoard displayGuessPicture];
}

- (void)setWordStr:(NSString *)wordStr
{
    [_wordStr release];
    _wordStr = [wordStr copy];
}

#pragma mark - public

#pragma mark - View Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    CGRect vFrame = VIEW_CONTROLLERS_FRAME;

    CGRect gFrame = vFrame;
    gFrame.size.height = guess_board_height; 

    self.guessBoard = [[[GuessBoardView alloc] initWithFrame:gFrame] autorelease];
    _guessBoard.drDelegate = self;
    [self.view addSubview:_guessBoard];
    
    // fix bottom shadow bug
    UILabel *bottomBgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(_guessBoard.frame),
                                                                       320,
                                                                       vFrame.size.height - guess_board_height)];
    bottomBgLabel.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomBgLabel];
    [bottomBgLabel release];

    self.pickLetterView = [[[PickLetterView alloc] initWithFrame:CGRectMake(0, 
                                                                        vFrame.size.height - WORD_PICK_VIEW_HEIGHT,
                                                                        vFrame.size.width,
                                                                        WORD_PICK_VIEW_HEIGHT)] autorelease];
    _pickLetterView.drDelegate = self;
    [self.view addSubview:_pickLetterView];

    self.keyboardContainer = [[[KMKeyboardContainer alloc] initWithFrame:vFrame] autorelease];
    [self.view addSubview:_keyboardContainer];
    
    self.inputLabel = [[[UILabel alloc] init] autorelease];
    _inputLabel.text = @"请输入您猜到的词组：";
    _inputLabel.backgroundColor = [UIColor clearColor];
    _inputLabel.font = FONT_CHINESE(18.f);
    [_inputLabel sizeToFit];
    
    CGRect iFrame = CGRectMake(10.f, 
                               _keyboardContainer.frame.size.height - _inputLabel.frame.size.height - input_field_height - 2
                               *padding,
                               _inputLabel.frame.size.width,
                               _inputLabel.frame.size.height);
    
    _inputLabel.frame = iFrame;

    [_keyboardContainer addSubview:_inputLabel];

    self.inputField = [[[UITextField alloc] init] autorelease];
    _inputField.placeholder = @"提示：xx汉字";
    _inputField.delegate = self;
    _inputField.borderStyle = UITextBorderStyleRoundedRect;
    _inputField.backgroundColor = [UIColor colorWithRed:238 / 255. green:238 / 255. blue:238 / 255. alpha:1];
    _inputField.font = FONT_DEFAULT(20.f);
    _inputField.returnKeyType = UIReturnKeyDone;
    _inputField.frame = CGRectMake((_keyboardContainer.frame.size.width - input_field_width) / 2, 
                                   _keyboardContainer.frame.size.height - input_field_height - padding, 
                                   input_field_width, 
                                   input_field_height);
    
    [_keyboardContainer addSubview:_inputField];

    self.replayButton = [[[RoundRectButton alloc] init] autorelease];
    [_replayButton addTarget:self action:@selector(replayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _replayButton.titleLabel.font = FONT_CHINESE(13.f);
    _replayButton.bgColor = [UIColor colorWithHexString:@"#ca534a"];
    [_replayButton setTitle:@"重放" forState:UIControlStateNormal];
    [_replayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _replayButton.frame = REPLAY_BUTTON_FRAME;
    
    _replayButton.hidden = YES;     // do not support replay !
    
    [self.view addSubview:_replayButton];
    
    self.passButton = [[[RoundRectButton alloc] init] autorelease];
    [_passButton addTarget:self action:@selector(passButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _passButton.titleLabel.font = FONT_CHINESE(13.f);
    _passButton.bgColor = [UIColor colorWithHexString:@"#ca534a"];
    [_passButton setTitle:@"放弃" forState:UIControlStateNormal];
    [_passButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _passButton.frame = PASS_BUTTON_FRAME;

    [self.view addSubview:_passButton];

    self.resetButton = [[[RoundRectButton alloc] init] autorelease];
    [_resetButton addTarget:self action:@selector(resetButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _resetButton.titleLabel.font = FONT_CHINESE(13.f);
    _resetButton.bgColor = [UIColor colorWithHexString:@"#ca534a"];
    [_resetButton setTitle:@"重新选择" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _resetButton.frame = RESET_BUTTON_FRAME;

    [self.view addSubview:_resetButton];

    self.coverButton = [[[CoverButton alloc] init] autorelease];
    [_coverButton addTarget:self action:@selector(replayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _coverButton.titleLabel.font = FONT_CHINESE(23.f);
    _coverButton.backgroundColor = [UIColor clearColor];
    [_coverButton setTitle:@"点击查看画" forState:UIControlStateNormal];
    [_coverButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _coverButton.frame = self.view.bounds;

    [self.view addSubview:_coverButton];
}

- (void)viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
    _nav = (DrNavigationController *)self.navigationController;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setTitle:@"Back" forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(0, 0, 60, 40);
    [backBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _nav.leftView = backBtn;

    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.frame = CGRectMake(0, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    _nav.rightView = doneBtn;

    [_nav.kmNavigationBar showShadow:YES];

    DrawingModel *drawing = [[GameDataFetcher sharedFetcher] currentDrawing];
    
    _guessBoard.pathAry = drawing.pathAry;
    _pickLetterView.word = drawing.word;
    
    [self setWordStr:drawing.word.wordStr];
    
    [_nav setDrTitle:drawing.word.wordStr type:titleViewTypeRightNil];

    if (gameLanguage() == game_language_type_english)
    {
        _keyboardContainer.hidden = YES;
    }
    else if (gameLanguage() == game_language_type_chinese)
    {
        _pickLetterView.hidden = YES;
        _resetButton.hidden = YES;
    }
}

- (void)dealloc
{
    [_wordStr release];
    _wordStr = nil;
    
    self.guessBoard        = nil;
    self.pickLetterView    = nil;
    self.keyboardContainer = nil;
    self.inputLabel = nil;
    self.inputField        = nil;
    self.replayButton      = nil;
    self.passButton        = nil;
    self.resetButton       = nil;
    self.coverButton       = nil;

    [super dealloc];
}

#pragma mark - GuessBoardViewDelegate

- (void)didFinishPlaybackGuessBoard:(GuessBoardView *)guessBoard
{
    [[DrSimpleIndicator sharedIndicator] showMessage:@"已画完" withY:160.f];
}

#pragma mark - PickLetterViewDelegate

- (void)correctWord:(PickLetterView *)pickLetterView
{
    self.resultView = [[[ResultViewController alloc] init] autorelease];
    _resultView.drDelegate = self;
    [UIView transitionFromView:_nav.animationView
                        toView:_resultView.view 
                      duration:0.7f 
                       options:UIViewAnimationOptionTransitionCurlDown
                    completion:^(BOOL finished){
                        [[GameDataFetcher sharedFetcher] correctCurrentGame:NO];
                    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.resultView = [[[ResultViewController alloc] init] autorelease];
    _resultView.drDelegate = self;
    [UIView transitionFromView:_nav.animationView
                        toView:_resultView.view 
                      duration:0.7f 
                       options:UIViewAnimationOptionTransitionCurlDown
                    completion:^(BOOL finished){
                        [[GameDataFetcher sharedFetcher] correctCurrentGame:NO];
                    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location > [_wordStr length]) 
    {
        return NO;
    }
    else 
    {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text length] < [_wordStr length])
    {
        return NO;
    }
    else 
    {
        [textField resignFirstResponder];
        
        return YES; 
    }
}

#pragma mark - ResultViewControllerDelegate

- (void)didClickedNextButtonInResultViewController:(ResultViewController *)resultViewControler
{    
    PickWordViewController *control = [[PickWordViewController alloc] init];
    [self.navigationController pushViewController:control animated:NO];
    [control release];

    [UIView transitionFromView:_resultView.view
                        toView:_nav.animationView
                      duration:0.5f 
                       options:UIViewAnimationOptionTransitionCurlUp
                    completion:^(BOOL finished){
                        [_nav.view sendSubviewToBack:_nav.animationView]; 
                    }];
}

#pragma mark - default

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
