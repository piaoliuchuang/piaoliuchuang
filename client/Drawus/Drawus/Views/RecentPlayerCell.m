//
//  RecentPlayerCell.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "RecentPlayerCell.h"
#import "PlayerModel.h"

#define CELL_PADDING 5.f


@interface RecentPlayerCell ()

@property (nonatomic, retain) UILabel *nameLabel;

@end


@implementation RecentPlayerCell

@synthesize player=_player;
@synthesize nameLabel=_nameLabel;

#pragma mark - public

- (void)setPlayer:(PlayerModel *)player
{
	[_player release];
	_player = [player retain];

	_nameLabel.text = _player.username;
}

- (void)updateUI
{
	CGRect frame = self.contentView.bounds;
	frame.size.width = 300.f;;

	[_nameLabel sizeToFit];
	CGRect aFrame = _nameLabel.frame;
	aFrame.origin.x = CELL_PADDING;
	aFrame.origin.y = (frame.size.height - aFrame.size.height) / 2;
	_nameLabel.frame = aFrame;
}

#pragma mark - default

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		self.nameLabel = [[[UILabel alloc] init] autorelease];
		_nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = FONT_ENGLISH(14.f);
		[self.contentView addSubview:_nameLabel];
    }
    return self;
}

- (void)dealloc
{
	self.nameLabel = nil;

	[super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
