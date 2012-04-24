//
//  CurrentGameCell.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "CurrentGameCell.h"
#import "GameModel.h"
#import "PlayerModel.h"
#import "GameStatView.h"
#import "KMRoundRectButton.h"

#define CELL_PADDING 5.f
#define PLAY_BUTTON_FRAME CGRectMake(0, 0, 80, 34)
//#define STAT_BUTTON_FRAME CGRectMake(0, 0, 80, 15)
#define DELETE_BUTTON_FRAME CGRectMake(0, CELL_PADDING, 80, 34)
#define STATUS_LABEL_WIDTH 100.f
#define STATUS_LABEL_FONT_SIZE 13.f
#define STATUS_LABEL_ORIGIN_X 100.f

@interface CurrentGameCell () {

	PLAYER_STATUS _playerStatus;
}

@property (nonatomic, retain) KMRoundRectButton *playBtn;
@property (nonatomic, retain) KMRoundRectButton *statBtn; 	// stat 统计；
@property (nonatomic, retain) UILabel        *currentOwnerLabel;
@property (nonatomic, retain) UILabel        *statusLabel;
@property (nonatomic, retain) GameStatView   *statView;
@property (nonatomic, retain) KMRoundRectButton *deleteBtn;

@end

@implementation CurrentGameCell

@synthesize drDelegate        =_drDelegate;
@synthesize indexPath         =_indexPath;
@synthesize game              =_game;
@synthesize expanded          =_expanded;
@synthesize playerStatus      =_playerStatus;

@synthesize playBtn           =_playBtn;
@synthesize statBtn           =_statBtn;
@synthesize currentOwnerLabel =_currentOwnerLabel;
@synthesize statusLabel       =_statusLabel;
@synthesize statView          =_statView;
@synthesize deleteBtn         =_deleteBtn;

- (void)dealloc
{
	self.playBtn           = nil;
	self.statBtn           = nil;
	self.currentOwnerLabel = nil;
	self.statusLabel       = nil;
	self.statView          = nil;
	self.deleteBtn         = nil;
    
	[super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.playBtn = [[[KMRoundRectButton alloc] init] autorelease];
		[_playBtn setBackgroundColor:[UIColor clearColor]];
        _playBtn.bgColor = [UIColor colorWithHexString:@"#9ff309"]; // @"#ca534a"]; // 
        _playBtn.titleLabel.font = FONT_CHINESE(13.f);
		[_playBtn addTarget:self action:@selector(playBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[_playBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
		[_playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[self.contentView addSubview:_playBtn];
        
		/*  
         statBtn 在lite1.0中不表示统计信息，只表示详情 
         暂时弃用statBtn，点击cell获取详情
         */
        
        // self.statBtn = [[[RoundRectButton alloc] init] autorelease];
        // [_statBtn setBackgroundColor:[UIColor blueColor]];
        // [_statBtn addTarget:self action:@selector(statBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        // [_statBtn setTitle:@"游戏信息" forState:UIControlStateNormal];
        // [_playBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // [self.contentView addSubview:_statBtn];
        
        self.currentOwnerLabel = [[[UILabel alloc] init] autorelease];
        _currentOwnerLabel.backgroundColor = [UIColor clearColor];
        _currentOwnerLabel.font = FONT_ENGLISH(14.f);
        [self.contentView addSubview:_currentOwnerLabel];
        
        self.statusLabel = [[[UILabel alloc] init] autorelease];
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.font = FONT_CHINESE(STATUS_LABEL_FONT_SIZE);
        [self.contentView addSubview:_statusLabel];
        
        self.statView = [[[GameStatView alloc] init] autorelease];
        [self.contentView addSubview:_statView];
        
		self.deleteBtn = [[[KMRoundRectButton alloc] init] autorelease];
		[_deleteBtn setBackgroundColor:[UIColor clearColor]];
        _deleteBtn.bgColor = [UIColor colorWithHexString:@"#ff3e37"];
		_deleteBtn.titleLabel.font = FONT_CHINESE(13.f);
		[_deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
		[_deleteBtn setTitle:@"离开游戏" forState:UIControlStateNormal];
		[_deleteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		_deleteBtn.frame = DELETE_BUTTON_FRAME;
		[_statView addSubview:_deleteBtn];
    }
    return self;
}

#pragma mark - private

- (void)playBtnClicked:(id)sender
{
	if (_drDelegate != nil)
	{
		if ([_drDelegate respondsToSelector:@selector(didClickedPlayBtnInCurrentGameCell:)])
		{
			[_drDelegate didClickedPlayBtnInCurrentGameCell:self];
		}
	}
}

- (void)statBtnClicked:(id)sender
{
	
}

- (void)deleteBtnClicked:(id)sender
{
	if (_drDelegate != nil)
	{
		if ([_drDelegate respondsToSelector:@selector(didClickedDeleteBtnInCurrentGameCell:)])
		{
			[_drDelegate didClickedDeleteBtnInCurrentGameCell:self];
		}
	}
}

#pragma mark - public

- (void)setGame:(GameModel *)game
{
	/*
		多人模式时有可能需要添加其他的控制
		比如当前用户没有参与近期的两轮游戏，该如何处理
	*/

	[_game release];
	_game = [game retain];
    
//    NSLog(@"username:%@ roundType:%d owner:%@", username(), game.currentRoundType, _game.currentOwner.username);

	if ([_game.currentOwner.username isEqualToString:username()] && game.currentRoundType == CURRENT_ROUND_TYPE_NEW_DRAW)
	{
		_playerStatus     = PLAYER_STATUS_WAITING_OTHERS_GUESSING;
		_statusLabel.text = PLAYER_STATUS_WAITING_OTHERS_GUESSING_STR;

		_playBtn.hidden = YES;
	}	
	else if (![_game.currentOwner.username isEqualToString:username()] && game.currentRoundType == CURRENT_ROUND_TYPE_NEW_DRAW)
	{
		_playerStatus     = PLAYER_STATUS_WAITING_YOU_GUESSING;
		_statusLabel.text = PLAYER_STATUS_WAITING_YOU_GUESSING_STR;

		_playBtn.hidden = NO;
	}
	else if ([_game.currentOwner.username isEqualToString:username()] && game.currentRoundType == CURRENT_ROUND_TYPE_WAIT_DRAW)
	{
		_playerStatus     = PLAYER_STATUS_WAITING_YOU_DRAWING;
		_statusLabel.text = PLAYER_STATUS_WAITING_YOU_DRAWING_STR;

		_playBtn.hidden = NO;
	}
	else if (![_game.currentOwner.username isEqualToString:username()] && game.currentRoundType == CURRENT_ROUND_TYPE_WAIT_DRAW)
	{
		_playerStatus     = PLAYER_STATUS_WAITING_OTHERS_DRAWING;
		_statusLabel.text = PLAYER_STATUS_WAITING_OTHERS_DRAWING_STR;

		_playBtn.hidden = YES;
	}

	_currentOwnerLabel.text = _game.currentOwner.username;

	_statView.game = game;
}

- (void)updateUI
{
	CGRect vFrame = self.contentView.bounds;
    vFrame.size.width = 280.f;
	vFrame.size.height = NORMAL_GAME_CELL_HEIGHT;

	CGRect aFrame = PLAY_BUTTON_FRAME;
	aFrame.origin.x = vFrame.size.width - aFrame.size.width - CELL_PADDING;
	aFrame.origin.y = (NORMAL_GAME_CELL_HEIGHT - aFrame.size.height) / 2;
	_playBtn.frame = aFrame;

	// aFrame = STAT_BUTTON_FRAME;
	// aFrame.origin.x = CELL_PADDING;
	// aFrame.origin.y = NORMAL_GAME_CELL_HEIGHT - aFrame.size.height;
	// _statBtn.frame = aFrame;

	[_currentOwnerLabel sizeToFit];
	CGRect aFrame3 = _currentOwnerLabel.frame;
	aFrame3.origin.x = CELL_PADDING;
	aFrame3.origin.y = (NORMAL_GAME_CELL_HEIGHT - aFrame3.size.height) / 2;
    aFrame3.size.width = aFrame3.size.width > (STATUS_LABEL_ORIGIN_X - CELL_PADDING) ? 
                            STATUS_LABEL_ORIGIN_X - CELL_PADDING : 
                            aFrame3.size.width;
    _currentOwnerLabel.frame = aFrame3;
    
    [_statusLabel sizeToFit];
	CGRect aFrame4 = _statusLabel.frame;
	aFrame4.origin.x = STATUS_LABEL_ORIGIN_X;
	aFrame4.origin.y = (NORMAL_GAME_CELL_HEIGHT - aFrame4.size.height) / 2;
	_statusLabel.frame = aFrame4;

    CGRect aFrame2 = vFrame;
    aFrame2.origin.y = NORMAL_GAME_CELL_HEIGHT;
    aFrame2.size.height = EXPANDED_GAME_CELL_HEIGHT - NORMAL_GAME_CELL_HEIGHT;

	if (!_expanded)
	{
		aFrame2.size.height = 0.f;
	}
    
//    logFrame (self.frame, @"self");
//    logFrame (self.contentView.frame, @"content");
//    logFrame (aFrame3, @"frame3");

	_statView.frame = aFrame2;
	[_statView updateUI];
    
    aFrame2 = _deleteBtn.frame;
    aFrame2.origin.x = _playBtn.frame.origin.x;
    _deleteBtn.frame = aFrame2;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    _expanded = selected;
//
//    [self updateUI];
//}

@end

