//
//  ResultViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-28.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "ResultViewController.h"
#import "GameDataFetcher.h"
#import "KMRoundRectButton.h"

#define CORRECT_TEXT @"恭喜你，答对了！\n 被猜得词为："
#define PASS_TEXT    @"很遗憾，没有猜中。\n 被猜的词为："
#define NEXT_BUTTON_FRAME CGRectMake(0, 0, 74, 44)
#define TEXT_LABEL_WIDTH 200.f
#define PADDING 10.f

@interface GradientBackgroundView : UIView

@end

@implementation GradientBackgroundView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    drawGradient(context, rect, orangeGradientComponents2, 3);
}

@end

@interface ResultViewController ()

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *wordLabel;
@property (nonatomic, retain) KMRoundRectButton *nextButton;

@end

@implementation ResultViewController

@synthesize drDelegate =_drDelegate;
@synthesize wordLabel=_wordLabel;
@synthesize textLabel=_textLabel;
@synthesize nextButton=_nextButton;

#pragma mark - private

- (void)nextButtonClicked:(id)sender
{
    if (_drDelegate != nil)
    {
        if ([_drDelegate respondsToSelector:@selector(didClickedNextButtonInResultViewController:)])
        {
            [_drDelegate didClickedNextButtonInResultViewController:self];
        }
    }
}

#pragma mark - public

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor clearColor];
    
    GradientBackgroundView *background = [[GradientBackgroundView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:background];
    [background release];

    self.textLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)] autorelease];
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.font = FONT_CHINESE(18.f);
    _textLabel.textAlignment = UITextAlignmentCenter;
    _textLabel.center = CGPointMake(self.view.center.x, self.view.center.y - _textLabel.frame.size.height / 2);
    [self.view addSubview:_textLabel];

    self.wordLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 60)] autorelease];
    _wordLabel.backgroundColor = [UIColor clearColor];
    _wordLabel.font = FONT_ENGLISH(18.f);
    [self.view addSubview:_wordLabel];

    self.nextButton = [[[KMRoundRectButton alloc] init] autorelease];
    [_nextButton addTarget:self action:@selector(nextButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _nextButton.titleLabel.font = FONT_CHINESE(13.f);
    _nextButton.frame = NEXT_BUTTON_FRAME;
    _nextButton.bgColor = [UIColor colorWithHexString:@"#ca534a"];
    [_nextButton setTitle:@"下一轮" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _nextButton.frame = NEXT_BUTTON_FRAME;

    [self.view addSubview:_nextButton];
    
    // result vc is used for transition, so viewWillAppear method won't be called
    
    DrawingModel *drawing = [[GameDataFetcher sharedFetcher] currentDrawing];
    if (drawing.guessed)
    {
        _textLabel.text = CORRECT_TEXT;
    }
    else
    {
        _textLabel.text = PASS_TEXT;
    }
    
    [_textLabel heightToFit:TEXT_LABEL_WIDTH];
    _textLabel.center = CGPointMake(self.view.center.x, 150.f);
    
    _wordLabel.text = drawing.word.wordStr;
    [_wordLabel sizeToFit];
    _wordLabel.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_textLabel.frame) + _wordLabel.frame.size.height / 2 + PADDING);
    
    _nextButton.center = CGPointMake(self.view.center.x, CGRectGetMaxY(_wordLabel.frame) + _nextButton.frame.size.height / 2 + PADDING);
}

- (void)dealloc
{
    self.wordLabel = nil;
    self.textLabel = nil;
    self.nextButton = nil;

    [super dealloc];
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
