//
//  DrNavigationController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-30.
//  Copyright (c) 2012年 99fang. All rights reserved.
//
#import "DrNavigationController.h"
#import "CreateGameViewController.h"
#import "CreateUserViewController.h"
#import "ConnectViewController.h"
#import "GameDataFetcher.h"

@interface DrNavigationController () <KMPopViewControllerDelegate, 
                                      ConnectViewControllerDelegate>
{
    UILabel *_titleLabel;
}

@property (nonatomic, retain) CreateGameViewController *createGameVC;
@property (nonatomic, retain) CreateUserViewController *createUserVC;
@property (nonatomic, retain) ConnectViewController    *connectVC;

@end

@implementation DrNavigationController

@synthesize createGameVC =_createGameVC;
@synthesize createUserVC =_createUserVC;
@synthesize connectVC    =_connectVC;

#pragma mark - public

- (void)showPopViewByType:(popViewType)type
{
    if (type == popViewTypeCreateGame)
    {
        _createGameVC.view.hidden = NO;
        [self.view bringSubviewToFront:_createGameVC.view];
        [_createGameVC pop];
    }
    else if (type == popViewTypeCreateUser)
    {
        _createUserVC.view.hidden = NO;
        [self.view bringSubviewToFront:_createUserVC.view];
        [_createUserVC pop];
    }
    else if (type == popViewTypeConnect)
    {
        _connectVC.view.hidden = NO;
        [self.view bringSubviewToFront:_connectVC.view];
        [_connectVC pop];
        [_connectVC checkConnected];
    }
}

- (void)hidePopViewByType:(popViewType)type
{
    if (type == popViewTypeCreateGame)
    {
        _createGameVC.view.hidden = YES;
    }
    else if (type == popViewTypeCreateUser)
    {
        _createUserVC.view.hidden = YES;
    }
    else if (type == popViewTypeConnect)
    {
        _connectVC.view.hidden = YES;
    }
}

- (void)setDrTitle:(NSString *)drTitle type:(titleViewType)type
{
    _titleLabel.text = drTitle;
    
    CGRect tFrame = _titleLabel.frame;
    
    if (type == titleViewTypeNormal)
    {
        // frame not changed
    }
    else if (type == titleViewTypeLeftNil) 
    {
        tFrame.size.width += tFrame.origin.x;
        tFrame.origin.x = 0.f;
    }
    else if (type == titleViewTypeRightNil) 
    {
        tFrame.size.width += self.view.bounds.size.width - CGRectGetMaxX(tFrame);
    }
    
    _titleLabel.frame = tFrame;
    
    self.titleView = _titleLabel;
    
    logFrame(tFrame, @"title frame");
}

#pragma mark - ViewLifecycle

- (void)loadView
{
    [super loadView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = UITextAlignmentCenter;
    _titleLabel.font = FONT_TITLE(25.f);

    self.createGameVC = [[[CreateGameViewController alloc] init] autorelease];
    _createGameVC.kmDelegate = self;
    [self.view addSubview:_createGameVC.view];
    _createGameVC.view.hidden = YES;

    self.createUserVC = [[[CreateUserViewController alloc] init] autorelease];
    _createUserVC.kmDelegate = self;
    [_createUserVC setClosable:NO];
    [self.view addSubview:_createUserVC.view];
    _createUserVC.view.hidden = YES;

    self.connectVC = [[[ConnectViewController alloc] init] autorelease];
    _connectVC.kmDelegate = self;
    [_connectVC setClosable:NO];
    [self.view addSubview:_connectVC.view];
    _connectVC.view.hidden = YES;
    _connectVC.drDelegate = self;
}

- (void)dealloc
{
    self.createGameVC = nil;
    self.createUserVC = nil;
    self.connectVC    = nil;
    
    [_titleLabel release];

    [super dealloc];
}

#pragma mark - KMPopViewControllerDelegate

- (void)didHidePopViewController:(KMPopViewController *)popViewControler
{
    popViewControler.view.hidden = YES;
}

#pragma mark - ConnectViewControllerDelegate

- (void)connected:(ConnectViewController *)connectVC;
{
//    [self didHidePopViewController:_connectVC];
}

- (void)disconnected:(ConnectViewController *)connectVC;
{

}

@end

