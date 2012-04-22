//
//  GameStatView.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "GameStatView.h"
#import "GameModel.h"

#define VIEW_PADDING 5.f

@interface GameStatView ()

@property (nonatomic, retain) UILabel *roundLabel;

@end

@implementation GameStatView

@synthesize game=_game;
@synthesize roundLabel=_roundLabel;

#pragma mark - private
#pragma mark - public

- (void)setGame:(GameModel *)game
{
	[_game release];
	_game = [game retain];

	_roundLabel.text = [NSString stringWithFormat:@"回合：%@", _game.round];	
}

- (void)updateUI
{
    [_roundLabel sizeToFit];
	CGRect rFrame = _roundLabel.frame;
	rFrame.origin.x = VIEW_PADDING;
	rFrame.origin.y = VIEW_PADDING;
	_roundLabel.frame = rFrame;
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.roundLabel = [[[UILabel alloc] init] autorelease];
        _roundLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_roundLabel];
    }
    return self;
}

- (void)dealloc
{
	self.game = nil;
	self.roundLabel = nil;

	[super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
