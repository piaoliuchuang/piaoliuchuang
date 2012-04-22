//
//  DrawusAppDelegate.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-21.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "DrNavigationController.h"
#import "DrNavigationBar.h"
#import "MainViewController.h"
#import "SetupViewController.h"
#import "GuideViewController.h"

#import "ShakeDetector.h"
#import "MobClick.h"

@interface AppDelegate () {
    
    NSString *_token;
}

@property (nonatomic, retain) DrNavigationController *navController;
@property (nonatomic, retain) SetupViewController    *leftViewController;
@property (nonatomic, retain) GuideViewController    *rightViewController;

@end

@implementation AppDelegate

@synthesize window              =_window;
@synthesize navController       =_navController;
@synthesize leftViewController  =_leftViewController;
@synthesize rightViewController =_rightViewController;

#pragma mark - public

- (void)makeLeftViewVisible
{
    self.navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navController.view.layer.shadowOpacity = 0.4f;
    self.navController.view.layer.shadowOffset = CGSizeMake(-12.0, 1.0f);
    self.navController.view.layer.shadowRadius = 7.0f;
    self.navController.view.layer.masksToBounds = NO;
    
    [self.leftViewController  setVisible:YES];
    [self.rightViewController setVisible:NO];
}

- (void)makeRightViewVisible 
{
    self.navController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.navController.view.layer.shadowOpacity = 0.4f;
    self.navController.view.layer.shadowOffset = CGSizeMake(12.0, 1.0f);
    self.navController.view.layer.shadowRadius = 7.0f;
    self.navController.view.layer.masksToBounds = NO;

    [self.rightViewController setVisible:YES];
    [self.leftViewController  setVisible:NO];
}

#pragma mark - default

- (void)dealloc
{
    [_window release];
    [_navController release];
    [_leftViewController release];
    [_rightViewController release];
    
    [_token release];

    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    setGameMode(game_mode_type_three);
    setGameLanguage(game_language_type_chinese);
    setAppSkin(app_skin_type_google_blue);
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | 
                                                                          UIRemoteNotificationTypeAlert |
                                                                          UIRemoteNotificationTypeSound]; 
    
    [MobClick startWithAppkey:@"4f8b0069527015624b00001d" reportPolicy:REALTIME channelId:nil];

    // left view
    self.leftViewController = [[[SetupViewController alloc] init] autorelease];
    _leftViewController.view.frame = CGRectMake(0, 
                                                20, 
                                                _leftViewController.view.frame.size.width, 
                                                _leftViewController.view.frame.size.height);
    [_window addSubview:_leftViewController.view];

    // right view
    self.rightViewController = [[[GuideViewController alloc] init] autorelease];
    _rightViewController.view.frame = CGRectMake(320-self.rightViewController.view.frame.size.width, 
                                                     20, 
                                                     _rightViewController.view.frame.size.width, 
                                                     _rightViewController.view.frame.size.height);
    [_window addSubview:_rightViewController.view];

    // invisible left and right view
    [self.leftViewController  setVisible:NO];
    [self.rightViewController setVisible:NO];
    
    MainViewController *root = [[MainViewController alloc] init];
    
    DrNavigationController *nav = [[DrNavigationController alloc] initWithRootViewController:root];
    DrNavigationBar *navBar = [[[DrNavigationBar alloc] initWithFrame:nav.navigationBar.frame] autorelease];
    nav.kmNavigationBar = navBar;
    self.navController = nav;
    self.window.rootViewController = nav;
    [root release];
    [nav release];   
    
    [_navController showPopViewByType:popViewTypeConnect];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [[ShakeDetector sharedDetector] enrollWhenAppActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - APNs

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"fail to register notificatoin:%@", error);
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [_token release];
    _token = [[[[[deviceToken description]
                             stringByReplacingOccurrencesOfString: @"<" withString: @""] 
                             stringByReplacingOccurrencesOfString: @">" withString: @""] 
                             stringByReplacingOccurrencesOfString: @" " withString: @""] retain];
    
    NSLog(@"token:%@", _token);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // handle userInfo
}

@end






