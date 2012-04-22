//
//  MainViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-21.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "MainViewController.h"
#import "DrNavigationController.h"
#import "DrawViewController.h"
#import "GuessViewController.h"
#import "PickWordViewController.h"

#import "RecentPlayerCell.h"
#import "CurrentGameCell.h"

#import "GameDataFetcher.h"
#import "PlayerDataFetcher.h"
#import "ShakeDetector.h"
#import "AudioManager.h"

#define TABLE_VIEW_WIDTH 300.f

enum {
    CurrentGameSection,     // KMAccodionListSection
    RecentPlayerSection,    // KMRadioListSection
    FindFriendSection       // KMNormalListSection
};

@interface TitleCell : UITableViewCell

@end

@implementation TitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:title_cell_background_color_str];
        self.textLabel.textColor = [UIColor colorWithHexString:title_cell_text_color_str];
        self.textLabel.font = FONT_CHINESE(17.f);
        self.textLabel.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

@end

@interface MainViewController () <UITableViewDataSource, 
                                  UITableViewDelegate,
                                  CurrentGameCellDelegate, 
                                  DataFetcherDelegate, 
                                  ShakeDetectorDelegate>
{
    int _expandedGame;      // -1 means no expanded
    int _selectedPlayer;    // -1 means no selected
    
    DrNavigationController *_nav;
}

@property (nonatomic, retain) UITableView        *tableView;
@property (nonatomic, retain) NSArray            *currentGames;
@property (nonatomic, retain) NSArray            *recentPlayers;

@end

@implementation MainViewController

@synthesize tableView     =_tableView;
@synthesize currentGames  =_currentGames;
@synthesize recentPlayers =_recentPlayers;

#pragma mark - private

- (void)rightBtnClicked:(id)sender
{
    [super rightBarBtnTapped:sender];
}

- (void)leftBtnClicked:(id)sender
{
    [super leftBarBtnTapped:sender];
}

- (void)usernameChanged:(NSNotification *)notification
{
    [[GameDataFetcher sharedFetcher] fetchData];
    [[PlayerDataFetcher sharedFetcher] fetchData];
    
    [_tableView reloadData];
}

#pragma mark - Viewlifecycle

- (id)init
{
    self = [super init];
    if (self) 
    {
        self.currentGames = currentGames();
        self.recentPlayers = recentPlayers();
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(usernameChanged:) 
                                                     name:USER_DEFAULT_KEY_USERNAME 
                                                   object:nil];
        
        _expandedGame = -1;
        _selectedPlayer = -1;
        
        [[GameDataFetcher sharedFetcher] addDelegate:self];
        [[PlayerDataFetcher sharedFetcher] addDelegate:self];
        
        [[ShakeDetector sharedDetector] addDelegate:self];
    }
    return self;
}

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor colorWithHexString:main_vc_background_color_str];

    CGRect vFrame = VIEW_CONTROLLERS_FRAME;

    CGRect tFrame = vFrame;
    tFrame.origin.x = (vFrame.size.width - TABLE_VIEW_WIDTH) / 2;
    tFrame.size.width = TABLE_VIEW_WIDTH;

    self.tableView = [[[UITableView alloc] initWithFrame:tFrame style:UITableViewStyleGrouped] autorelease];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _nav = (DrNavigationController *)self.navigationController;
    
    UIButton *setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupBtn setTitle:@"设置" forState:UIControlStateNormal];
    setupBtn.titleLabel.font = FONT_CHINESE(16.f);
    setupBtn.frame = CGRectMake(0, 0, 60, 44);
    setupBtn.backgroundColor = [UIColor orangeColor];
    [setupBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *guideBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [guideBtn setTitle:@"帮助" forState:UIControlStateNormal];
    guideBtn.titleLabel.font = FONT_CHINESE(16.f);
    guideBtn.frame = CGRectMake(0, 0, 60, 44);
    guideBtn.backgroundColor = [UIColor orangeColor];
    [guideBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    _nav.leftView  = setupBtn;
    _nav.rightView = guideBtn;
    
    [_nav setDrTitle:@"画点啥" type:TITLE_VIEW_TYPE_NORMAL];
    [_nav.kmNavigationBar showShadow:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [_navController showPopViewByType:popViewTypeConnect];
    [[GameDataFetcher sharedFetcher] fetchData];
//    [[PlayerDataFetcher sharedFetcher] fetchData];
    
    [[ShakeDetector sharedDetector] startDetect];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[ShakeDetector sharedDetector] stopDetect];
}

- (void)dealloc
{
    self.tableView = nil;
    self.currentGames = nil;
    self.recentPlayers = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_DEFAULT_KEY_USERNAME object:nil];

    [[GameDataFetcher sharedFetcher] removeDelegate:self];
    [[PlayerDataFetcher sharedFetcher] removeDelegate:self];
    
    [[ShakeDetector sharedDetector] removeDelegate:self];
    
    [super dealloc];
}

#pragma mark - DataFetcherDelegate

- (void)dataFetched:(DataFetcher *)dataFetcher error:(NSError *)error
{
    // refresh current games
    // refresh recent player
    
    if (dataFetcher == [GameDataFetcher sharedFetcher])
    {
        self.currentGames = [[GameDataFetcher sharedFetcher] currentGames];  
        -
        [_navController hidePopViewByType:popViewTypeConnect]; 
    }
    else if (dataFetcher == [PlayerDataFetcher sharedFetcher])
    {
        self.recentPlayers= [[PlayerDataFetcher sharedFetcher] recentPlayers];
    }
}

- (void)dataFetchFailed:(DataFetcher *)dataFetcher error:(NSError *)error
{

}

#pragma mark - ShakeDetectorDelegate

- (void)shakeDetectorCallback:(ShakeDetector *)shakedetector
{
    if ([[[UIDevice currentDevice] systemVersion] compare:@"5.1" options:NSNumericSearch] == NSOrderedSame) {
        
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 0.7f;
        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.fillMode = kCAFillModeForwards;
        animation.removedOnCompletion = YES;
        animation.type = @"rippleEffect"; // 103
        
        [_nav.view.layer addAnimation:animation forKey:@"animation"];    
    }
    
    [[AudioManager sharedManager] playSoundByType:SHORT_SOUND_TYPE_SHAKE];
    
    // add a new game in current game cells
}

#pragma mark - CurrentGameCellDelegate

- (void)didClickedPlayBtnInCurrentGameCell:(CurrentGameCell *)currentGameCell
{   
    if (currentGameCell.playerStatus == PLAYER_STATUS_WAITING_YOU_DRAWING)
    {       
        PickWordViewController *control = [[PickWordViewController alloc] init];
        [self.navigationController pushViewController:control animated:YES];
        [control release];
    }
    else if (currentGameCell.playerStatus == PLAYER_STATUS_WAITING_YOU_GUESSING)
    {
       GuessViewController *control = [[GuessViewController alloc] init];
       [self.navigationController pushViewController:control animated:YES];
       [control release];
    }

    [[GameDataFetcher sharedFetcher] setCurrentIndex:currentGameCell.indexPath.row];
}

- (void)didClickedDeleteBtnInCurrentGameCell:(CurrentGameCell *)currentGameCell
{
    _expandedGame = -1;
    
    [[GameDataFetcher sharedFetcher] leaveGame:[_currentGames objectAtIndex:currentGameCell.indexPath.row - 1]];
    self.currentGames = [[GameDataFetcher sharedFetcher] currentGames];

    [_tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:currentGameCell.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == CurrentGameSection)
    {
        return [_currentGames count] + 1;
    } 
    else if (section == RecentPlayerSection)
    {
       return [_recentPlayers count] + 2;
    }
    else if (section == FindFriendSection)
    {
        return 1;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier  = @"title_cell_identifier";
    static NSString *gameCellIdentifier   = @"game_cell_identifier";
    static NSString *playerCellIdentifier = @"player_cell_identifier";
    static NSString *createCellIdentifier = @"create_cell_identifier";
    
    if (indexPath.row == 0)
    {
        UITableViewCell *cell = nil;

        cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];
        if (cell == nil)
        {
            cell = [[[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCellIdentifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.section == CurrentGameSection)
        {
            cell.textLabel.text = @"当前游戏"; 
        }
        else if (indexPath.section == RecentPlayerSection)
        {
            cell.textLabel.text = @"最近玩家";
        }
        else if (indexPath.section == FindFriendSection)
        {
            cell.textLabel.text = @"微博好友";
        }

        return cell;
    }
    else if (indexPath.section == CurrentGameSection)
    {
        CurrentGameCell *cell = nil;

        cell = [tableView dequeueReusableCellWithIdentifier:gameCellIdentifier];
        if (cell == nil)
        {
        cell = [[[CurrentGameCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:gameCellIdentifier] autorelease];
        }
        cell.drDelegate = self;
        cell.indexPath = indexPath;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.game = [_currentGames objectAtIndex:indexPath.row - 1];
        cell.expanded = _expandedGame == indexPath.row;
        [cell updateUI];

        return cell;
    } 
    else if (indexPath.section == RecentPlayerSection)
    {
        if (indexPath.row < [_recentPlayers count] + 1)
        {
            RecentPlayerCell *cell = nil;

            cell = [tableView dequeueReusableCellWithIdentifier:playerCellIdentifier];
            if (cell == nil)
            {
                cell = [[[RecentPlayerCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:playerCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.player = [_recentPlayers objectAtIndex:indexPath.row - 1];
            cell.accessoryType = _selectedPlayer == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            [cell updateUI];
            
            return cell;    
        }
        else
        {
            UITableViewCell *cell = nil;

            cell = [tableView dequeueReusableCellWithIdentifier:createCellIdentifier];
            if (cell == nil)
            {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:createCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;

            cell.backgroundColor = [UIColor colorWithHexString:create_game_cell_background_color_str];
            cell.textLabel.text = @"创建新游戏";
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = FONT_CHINESE(18.f);

            return cell;
        }
    }

    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == CurrentGameSection)
    {
        if (indexPath.row == _expandedGame)
        {
            return EXPANDED_GAME_CELL_HEIGHT;
        }
        else
        {
            return NORMAL_GAME_CELL_HEIGHT;
        }
    }
    else if (indexPath.section == RecentPlayerSection)
    {
        return NORMAL_PLAYER_CELL_HEIGHT;
    }
    else if (indexPath.section == FindFriendSection)
    {
        return 40.f;
    }

    return 44.f;    // cocoa default cell height
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // do nothing
    }
    else 
    {
        if (indexPath.section == CurrentGameSection)
        {
            if (_expandedGame == indexPath.row)
            {
                _expandedGame = -1;
            }
            else
            {
                _expandedGame = indexPath.row;        
            }
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic]; 
        }
        else if (indexPath.section == RecentPlayerSection)
        {
            if (indexPath.row < [_recentPlayers count] + 1)
            {
                if (_selectedPlayer == indexPath.row)
                {
                    _selectedPlayer = -1;
                }
                else
                {
                    _selectedPlayer = indexPath.row;    
                }
                
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone]; 
            }
            else
            {
                if (!username())
                {
                    [_nav showPopViewByType:POP_VIEW_TYPE_CREATE_USER];
                }
                else if (_selectedPlayer == -1) 
                {
                    [_nav showPopViewByType:POP_VIEW_TYPE_CREATE_GAME];
                }
                else
                {
                    [[GameDataFetcher sharedFetcher] addNewGameWithPlayer:[_recentPlayers objectAtIndex:_selectedPlayer]];   

                    PickWordViewController *control = [[PickWordViewController alloc] init];
                    [self.navigationController pushViewController:control animated:YES];
                    [control release];
                }
                
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        }       
    }
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
