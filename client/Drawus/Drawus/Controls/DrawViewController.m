//
//  DrawViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-21.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "DrawViewController.h"
#import "DrNavigationController.h"
#import "GuessViewController.h"

#import "DrawBoardView.h"
#import "DrawToolbar.h"
#import "DrawPopupButton.h"
#import "DrawColorButton.h"
#import "DrawPopupButtonView.h"
#import "RoundRectButton.h"

#import "GameDataFetcher.h"

#define COLOR_BUTTON_FRAME CGRectMake(0, 0, 34, 34)
#define POPUP_BUTTON_FRAME CGRectMake(0, 0, 40, 40)
#define CLEAR_BUTTON_FRAME CGRectMake(0, 0, 60, 40)
#define DONE_BUTTON_FRAME  CGRectMake(0, 0, 60, 40)
#define SETUP_BUTTON_FRAME CGRectMake(0, 0, 30, 30)

#define BOTTOM_BACKGROUND_HEIGHT 50.f
#define BOTTOM_TOOLBAR_HEIGHT 40.f
#define BRUSH_TITLE  @"画笔"
#define ERASER_TITLE @"橡皮擦"

#define PADDING 5.f
#define TOOLBAR_PADDING 5.f
#define POPUP_CENTER_COLOR_STRING @"#f5f3f2"

/*
 draw board height is 366.f
 */

@interface BoardBottomBackground : UIView

@end

@implementation BoardBottomBackground

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    drawGradient(context, rect, googleBlueGradientComponents, 4);
}

@end

@interface DrawViewController () <KMPopupButtonViewDelegate> {
    
    DrNavigationController *_nav;
}

@property (nonatomic, retain) DrawBoardView       *drawBoard;
@property (nonatomic, retain) DrawToolbar         *topToolbar;
@property (nonatomic, retain) DrawToolbar         *bottomToolbar;
@property (nonatomic, retain) DrawPopupButton     *brushBtn;
@property (nonatomic, retain) DrawPopupButton     *eraserBtn;
@property (nonatomic, retain) DrawPopupButtonView *popupView;

@end

@implementation DrawViewController

@synthesize word          =_word;
@synthesize drawBoard     =_drawBoard;
@synthesize topToolbar    =_topToolbar;
@synthesize bottomToolbar =_bottomToolbar;
@synthesize brushBtn      =_brushBtn;
@synthesize eraserBtn     =_eraserBtn;
@synthesize popupView     =_popupView;

- (void)dealloc
{
    self.word = nil;
    self.drawBoard     = nil;
    self.topToolbar    = nil;
    self.bottomToolbar = nil;
    self.brushBtn      = nil;
    self.eraserBtn     = nil;
    self.popupView     = nil;
    
    [super dealloc];
}

#pragma mark - private

- (void)leftBtnClicked:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)bottomItemActions:(id)sender
{
    DrawColorButton *btn = sender;

    if (!_drawBoard.eraser) {
        switch (btn.index) {
            case 0:
            {
                _drawBoard.strokeColor = [UIColor blackColor];
                _drawBoard.preStrokeColor = [UIColor blackColor];
                ((DrawPopupButton *)[_popupView.items objectAtIndex:0]).borderColor = [UIColor blackColor];
                [((DrawPopupButton *)[_popupView.items objectAtIndex:0]) setBrushNibColor:[UIColor blackColor]];
                break;
            }
            case 1:
            {
                _drawBoard.strokeColor = [UIColor redColor];
                _drawBoard.preStrokeColor = [UIColor redColor];
                ((DrawPopupButton *)[_popupView.items objectAtIndex:0]).borderColor = [UIColor redColor];
                [((DrawPopupButton *)[_popupView.items objectAtIndex:0]) setBrushNibColor:[UIColor redColor]];
                break;
            }
            case 2:
            {
                _drawBoard.strokeColor = [UIColor greenColor];
                _drawBoard.preStrokeColor = [UIColor greenColor];
                ((DrawPopupButton *)[_popupView.items objectAtIndex:0]).borderColor = [UIColor greenColor];
                [((DrawPopupButton *)[_popupView.items objectAtIndex:0]) setBrushNibColor:[UIColor greenColor]];
                break;
            }
            case 3:
            {
                _drawBoard.strokeColor = [UIColor blueColor];
                _drawBoard.preStrokeColor = [UIColor blueColor];
                ((DrawPopupButton *)[_popupView.items objectAtIndex:0]).borderColor = [UIColor blueColor];
                [((DrawPopupButton *)[_popupView.items objectAtIndex:0]) setBrushNibColor:[UIColor blueColor]];
                break;
            }
        }    
    }
}

- (void)clearBtnClicked:(id)sender
{
    [_drawBoard clearDrawing];
}

- (void)doneBtnClicked:(id)sender
{
    [_drawBoard finishDrawing];
    
    [[GameDataFetcher sharedFetcher] updateCurrentGameWithWord:_word path:_drawBoard.pathAry];

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (NSArray *)bottomItems
{
    NSMutableArray *bottomItems = [NSMutableArray array];

    DrawColorButton *blackBtn = [DrawColorButton buttonWithType:UIButtonTypeCustom];
    blackBtn.frame = COLOR_BUTTON_FRAME;
    [blackBtn addTarget:self action:@selector(bottomItemActions:) forControlEvents:UIControlEventTouchUpInside];
    blackBtn.colorComponents = blackComponents;
    [bottomItems addObject:blackBtn];

    DrawColorButton *redBtn = [DrawColorButton buttonWithType:UIButtonTypeCustom];
    redBtn.frame = COLOR_BUTTON_FRAME;
    [redBtn addTarget:self action:@selector(bottomItemActions:) forControlEvents:UIControlEventTouchUpInside];
    redBtn.colorComponents = redComponents;
    [bottomItems addObject:redBtn];

    DrawColorButton *greenBtn = [DrawColorButton buttonWithType:UIButtonTypeCustom];
    greenBtn.frame = COLOR_BUTTON_FRAME;
    [greenBtn addTarget:self action:@selector(bottomItemActions:) forControlEvents:UIControlEventTouchUpInside];
    greenBtn.colorComponents = greenComponents;
    [bottomItems addObject:greenBtn];

    DrawColorButton *blueBtn = [DrawColorButton buttonWithType:UIButtonTypeCustom];
    blueBtn.frame = COLOR_BUTTON_FRAME;
    [blueBtn addTarget:self action:@selector(bottomItemActions:) forControlEvents:UIControlEventTouchUpInside];
    blueBtn.colorComponents = blueComponents;
    [bottomItems addObject:blueBtn];

    return bottomItems;
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

    // bottom background
    BoardBottomBackground *bottomBg = [[BoardBottomBackground alloc] init];
    bottomBg.frame = CGRectMake(0.f, 
                                vFrame.size.height - BOTTOM_BACKGROUND_HEIGHT,
                                vFrame.size.width, 
                                BOTTOM_BACKGROUND_HEIGHT);
    [self.view addSubview:bottomBg];
    [bottomBg release];

    // popup buttons
    NSMutableArray *popupItems = [NSMutableArray array];

    CGRect aFrame = POPUP_BUTTON_FRAME;
    
    aFrame.origin.y = vFrame.size.height - BOTTOM_BACKGROUND_HEIGHT + (BOTTOM_BACKGROUND_HEIGHT - aFrame.size.height) / 2 - vFrame.origin.y;
    aFrame.origin.x = TOOLBAR_PADDING;

    CGRect aFrame2 = aFrame;

    DrawPopupButton *brushBtn = [[DrawPopupButton alloc] initWithVisibleFrame:aFrame type:DRAW_TYPE_BRUSH];
    self.brushBtn = brushBtn;
    brushBtn.borderColor = [UIColor blackColor];
    brushBtn.centerColor = [UIColor colorWithHexString:POPUP_CENTER_COLOR_STRING];
    [brushBtn createItems];
    [popupItems addObject:brushBtn];
    [brushBtn release];

    aFrame.origin.x += aFrame.size.width + TOOLBAR_PADDING;
    DrawPopupButton *eraserBtn = [[DrawPopupButton alloc] initWithVisibleFrame:aFrame type:DRAW_TYPE_ERASER];
    self.eraserBtn = eraserBtn;
    eraserBtn.borderColor = [UIColor grayColor];
    eraserBtn.centerColor = [UIColor colorWithHexString:POPUP_CENTER_COLOR_STRING];
    [eraserBtn createItems];
    [popupItems addObject:eraserBtn];
    [eraserBtn release];

    aFrame2.size.width = aFrame2.origin.x + CGRectGetMaxX(aFrame);

    self.popupView = [[[DrawPopupButtonView alloc] initWithFrame:vFrame visibleFrame:aFrame2] autorelease];
    _popupView.kmDelegate = self;
    _popupView.items = popupItems;
    [self.view addSubview:_popupView];
    
    // draw board
    self.drawBoard = [[[DrawBoardView alloc] initWithFrame:CGRectMake(0, 
                                                                      0.f, 
                                                                      vFrame.size.width, 
                                                                      vFrame.size.height - BOTTOM_BACKGROUND_HEIGHT)] autorelease];
    [self.view addSubview:_drawBoard];
    [self.view bringSubviewToFront:_drawBoard];
    

    RoundRectButton *clearBtn = [[[RoundRectButton alloc] init] autorelease];
    
    CGRect cFrame = CLEAR_BUTTON_FRAME;
    cFrame.origin.x = PADDING;
    cFrame.origin.y = PADDING;
    clearBtn.frame = cFrame;
    
    clearBtn.titleLabel.font = FONT_CHINESE(13.f);
    clearBtn.bgColor = [UIColor colorWithHexString:@"#ca534a"];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn addTarget:self action:@selector(clearBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:clearBtn];
    
    RoundRectButton *doneBtn = [[[RoundRectButton alloc] init] autorelease];
    
    CGRect dFrame = DONE_BUTTON_FRAME;
    dFrame.origin.x = vFrame.size.width - dFrame.size.width - PADDING;
    dFrame.origin.y = PADDING;
    doneBtn.frame = dFrame;
    
    doneBtn.titleLabel.font = FONT_CHINESE(13.f);
    doneBtn.bgColor = [UIColor colorWithHexString:@"#ca534a"];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneBtn];        
    
    // bottom bar
    self.bottomToolbar = [[[DrawToolbar alloc] initWithFrame:CGRectMake((POPUP_BUTTON_FRAME.size.width + TOOLBAR_PADDING) * 2, 
                                                                        vFrame.size.height - (BOTTOM_BACKGROUND_HEIGHT  + BOTTOM_TOOLBAR_HEIGHT)/ 2, 
                                                                        vFrame.size.width - (POPUP_BUTTON_FRAME.size.width + TOOLBAR_PADDING) * 2, 
                                                                        BOTTOM_TOOLBAR_HEIGHT)] autorelease];
    _bottomToolbar.orderType = TOOLBAR_ORDER_HORIZONTAL_RIGHT_TO_LEFT;
    _bottomToolbar.bgComponents = clearComponents;
    
    _bottomToolbar.items = [self bottomItems];
    
    [self.view addSubview:_bottomToolbar];
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
    _nav.rightView = nil;
    [_nav setDrTitle:_word.wordStr type:titleViewTypeRightNil];
    
    [_nav.kmNavigationBar showShadow:YES];
}

#pragma mark - KMPopupButtonViewDelegate

- (void)popupButton:(KMPopupButton *)popupButton inPopupButtonView:(KMPopupButtonView *)popupButtonView didSelectItemAtIndex:(int)index
{
    switch (index) {
        case 0:
        {
            _drawBoard.lineWidth = firstLevelLineWidth;
            break;
        }
        case 1:
        {
            _drawBoard.lineWidth = secondLevelLineWidth;
            break;
        }
        case 2:
        {
            _drawBoard.lineWidth = thirdLevelLineWidth;
            break;
        }
        case 3:
        {
            _drawBoard.lineWidth = forthLevelLineWidth;
            break;
        }   
    }
}

- (void)popupButton:(KMPopupButton *)popupButton inPopupButtonView:(KMPopupButtonView *)popupButtonView didClickCenterBtn:(UIButton *)centerBtn
{
    if (popupButton == _brushBtn)
    {
        _drawBoard.strokeColor = _drawBoard.preStrokeColor;
        _drawBoard.eraser = NO;
    }
    else if (popupButton == _eraserBtn)
    {
        _drawBoard.strokeColor = [UIColor whiteColor];
        _drawBoard.eraser = YES;
    }

    [self.view bringSubviewToFront:_popupView];    
}

- (void)didClickedBackgroundBtnInPopupButtonView:(KMPopupButtonView *)popupButtonView delay:(CGFloat)delay
{
    [self performBlock:^{
        [self.view sendSubviewToBack:_popupView];
        for (UIView *v in self.view.subviews)
        {
            if ([v isKindOfClass:[BoardBottomBackground class]])
            {
                [self.view sendSubviewToBack:v];
            }
        }
    }
            afterDelay:delay];
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
