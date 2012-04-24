//
//  StackView.m
//  Stack
//
//  Created by Tianhang Yu on 12-4-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "StackView.h"
#import "KMKeyboardContainer.h"
#import "KMRoundRectButton.h"
#import "KMSimpleIndicator.h"

#define TOTAL_NUMBER_TEXT(x) [NSString stringWithFormat:@"总共 %d 条", (x)] 

#define HARD_NUMBER 50

#define HARD_TEXT 			 @"你的任务已经堆积如山"
#define LIGHT_TEXT(x) 		 [NSString stringWithFormat:@"恭喜你，只剩 %d 个任务了", (x)] 
#define AWESOME_TEXT 		 @"Awesome! 都解决了，你的任务栈现在是空的"

#define BUTTON_BOUNDS CGRectMake(0, 0, 74, 44)

#define PADDING 10.f
#define INPUT_VIEW_HEIGHT 50.f
#define INPUT_VIEW_EXTEND_HEIGHT 150.f

#define TEXT_FONT_SIZE 18.f

@interface TitleCell : UITableViewCell

@end

@implementation TitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = FONT_DEFAULT(17.f);
        self.textLabel.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

@end

@interface IntroCell : UITableViewCell

@property (nonatomic, retain) UILabel *introLabel;

@end

@implementation IntroCell

@synthesize introLabel=_introLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.introLabel = [[[UILabel alloc] init] autorelease];
        [self.contentView addSubview:_introLabel];
    }
    return self;
}

@end

@interface ElementCell : UITableViewCell

@end

@implementation ElementCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@interface StackView () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, retain) KMKeyboardContainer *container;
@property (nonatomic, retain) UITextView          *inputView;
@property (nonatomic, retain) KMRoundRectButton   *pushButton;
@property (nonatomic, retain) UITableView         *listView;
@property (nonatomic, retain) KMRoundRectButton   *popButton;
@property (nonatomic, retain) UILabel             *introLabel;

@property (nonatomic, assign) id pushTarget;
@property (nonatomic, assign) SEL pushSelector;
@property (nonatomic, assign) id popTarget;
@property (nonatomic, assign) SEL popSelector;

@end

@implementation StackView {
    
    CGFloat _cellWidth;
}

@synthesize elements=_elements;

@synthesize container  =_container;
@synthesize inputView  =_inputView;
@synthesize pushButton =_pushButton;
@synthesize listView   =_listView;
@synthesize popButton  =_popButton;
@synthesize introLabel =_introLabel;

@synthesize pushTarget   =_pushTarget;
@synthesize pushSelector =_pushSelector;
@synthesize popTarget    =_popTarget;
@synthesize popSelector  =_popSelector;

- (void)dealloc
{
    self.container  = nil;
    self.inputView  = nil;
    self.pushButton = nil;
	self.listView   = nil;
	self.popButton  = nil;
    self.introLabel = nil;

    self.pushTarget   = nil;
    self.pushSelector = nil;
    self.popTarget    = nil;
    self.popSelector  = nil;

	[super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) 
    {
        CGRect vFrame = self.bounds;

        self.container = [[[KMKeyboardContainer alloc] initWithFrame:vFrame] autorelease];
        [self addSubview:_container];

        // input view
        CGRect iFrame = vFrame;
        iFrame.size.height = INPUT_VIEW_HEIGHT;
        
        self.inputView = [[[UITextView alloc] initWithFrame:iFrame] autorelease];
        _inputView.delegate = self;
        _inputView.backgroundColor = [UIColor clearColor];

        [self addSubview:_inputView];

        // push button
        self.pushButton = [[[KMRoundRectButton alloc] initWithFrame:BUTTON_BOUNDS] autorelease];
        _pushButton.backgroundColor = [UIColor clearColor];
        [_pushButton addTarget:self
                        action:@selector(pushButtonClicked:) 
              forControlEvents:UIControlEventTouchUpInside];

        [self addSubview:_pushButton];

        // list view
        CGRect lFrame = vFrame;
        lFrame.origin.y += INPUT_VIEW_HEIGHT;
        lFrame.size.height -= INPUT_VIEW_HEIGHT;
        
    	self.listView = [[[UITableView alloc] initWithFrame:lFrame] autorelease];
        _listView.dataSource = self;
        _listView.delegate   = self;
    	_listView.backgroundColor = [UIColor clearColor];

    	[self addSubview:_listView];
        
        _cellWidth = _listView.bounds.size.width;

        // pop button
    	self.popButton = [[[KMRoundRectButton alloc] initWithFrame:BUTTON_BOUNDS] autorelease];
    	_popButton.backgroundColor = [UIColor clearColor];
        [_popButton addTarget:self
                        action:@selector(popButtonClicked:) 
              forControlEvents:UIControlEventTouchUpInside];

    	[self addSubview:_popButton];
    }

    return self;
}

#pragma mark - private

- (void)pushButtonClicked:(id)sender
{
    if ([_inputView.text length] > 0)
    {
        if (_pushTarget && [_pushTarget respondsToSelector:_pushSelector])
        {
            NSMethodSignature *signature = [_pushTarget methodSignatureForSelector:_pushSelector];
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:_pushTarget];
            [invocation setSelector:_pushSelector];
            [invocation setArgument:&self atIndex:2];
            [invocation setArgument:_inputView.text atIndex:3];
            [invocation invoke];
        }       
    }
    else
    {
        [[KMSimpleIndicator sharedIndicator] showMessage:@"输入为空" withY:140.f];
    }
}

- (void)popButtonClicked:(id)sender
{
	if (_popTarget && [_popTarget respondsToSelector:_popSelector])
    {
        NSMethodSignature *signature = [_popTarget methodSignatureForSelector:_popSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:_popTarget];
        [invocation setSelector:_popSelector];
        [invocation setArgument:&self atIndex:2];
        [invocation invoke];
    }   
}


#pragma mark - public

- (void)setPushTarget:(id)target selector:(SEL)selector
{
    self.pushTarget   = target;
    self.pushSelector = selector;
}

- (void)setPopTarget:(id)target selector:(SEL)selector
{
    self.popTarget   = target;
    self.popSelector = selector;
}

- (void)layoutSubviews
{
    CGRect vFrame = self.bounds;
    
    CGRect iFrame = _inputView.frame;
    iFrame.origin.x = 0.f;
    iFrame.origin.y = 0.f;
    iFrame.size.width = vFrame.size.width - BUTTON_BOUNDS.size.width;
    iFrame.size.height = INPUT_VIEW_HEIGHT;
    
    _inputView.frame = iFrame;
    
    CGRect puFrame = BUTTON_BOUNDS;
    puFrame.origin.x = CGRectGetMaxX(_inputView.frame);
    puFrame.origin.y = CGRectGetMinY(_inputView.frame);

    _pushButton.frame = puFrame;
    
    CGRect lFrame = _listView.frame;
    lFrame.origin.x  = CGRectGetMinX(_inputView.frame);
    lFrame.origin.y = CGRectGetMaxY(_inputView.frame);
    lFrame.size.width = vFrame.size.width;
    lFrame.size.height = vFrame.size.height - _inputView.frame.size.height;
    
    _listView.frame = lFrame;
    
    CGRect poFrame = BUTTON_BOUNDS;
    poFrame.origin.x = vFrame.size.width - poFrame.size.width - PADDING;
    poFrame.origin.y = vFrame.size.height - poFrame.size.height - PADDING;
    
    _popButton.frame = poFrame;
}

- (void)setElements:(NSArray *)elements
{
    [_elements release];
    _elements = [elements retain];

    int count = [_elements count];

    NSString *introString = nil;

    if (count >= HARD_NUMBER)
    {
        introString = HARD_TEXT;    
    }
    else if (count == 0)
    {
        introString = AWESOME_TEXT;
    }
    else 
    {
        introString = LIGHT_TEXT(count);
    }

    _introLabel.text = introString;
    [_introLabel heightToFit:_cellWidth];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect iFrame = _inputView.frame;
    iFrame.size.height = INPUT_VIEW_EXTEND_HEIGHT;

    CGRect lFrame = _listView.frame;
    lFrame.origin.y += INPUT_VIEW_EXTEND_HEIGHT - INPUT_VIEW_HEIGHT;

    [UIView animateWithDuration:0.5f
                     animations:^{
                         _inputView.frame = iFrame;
                         _listView.frame = lFrame;
                     }];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGRect iFrame = _inputView.frame;
    iFrame.size.height = INPUT_VIEW_HEIGHT;
    
    CGRect lFrame = _listView.frame;
    lFrame.origin.y -= INPUT_VIEW_EXTEND_HEIGHT - INPUT_VIEW_HEIGHT;
    
    [UIView animateWithDuration:0.5f
                     animations:^{
                         _inputView.frame = iFrame;
                         _listView.frame = lFrame;
                     }];
    
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSections:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [_elements count];
    }
    else 
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCellIdentifier = @"title_cell_identifier";
    static NSString *introCellIdentifier = @"intro_cell_identifier";
    static NSString *elementCellIdentifier = @"element_cell_identifier";

    UITableViewCell *cell = nil;

    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:titleCellIdentifier];

            if (cell == nil)
            {
                cell = [[[TitleCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                         reuseIdentifier:titleCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.textLabel.text = @"当前任务";
        }
        else if (indexPath.row == 1)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:elementCellIdentifier];

            if (cell == nil)
            {
                cell = [[[ElementCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:elementCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.textLabel.text = [_elements objectAtIndex:0];
        }
        else if (indexPath.row == 2)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:introCellIdentifier];

            if (cell == nil)
            {
                cell = [[[IntroCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:introCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            ((IntroCell *)cell).introLabel = _introLabel;
        }
        else 
        {
            cell = [tableView dequeueReusableCellWithIdentifier:elementCellIdentifier];

            if (cell == nil)
            {
                cell = [[[ElementCell alloc] initWithStyle:UITableViewCellStyleDefault 
                                           reuseIdentifier:elementCellIdentifier] autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.textLabel.text = [_elements objectAtIndex:indexPath.row - 2];
        }
    }

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightOfRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat ret = 0.f;

    if (indexPath.section == 0)
    {   
        if (indexPath.row == 0)
        {
            ret = 60.f;
        }
        else if (indexPath.row == 1)
        {
            NSString *element = [_elements objectAtIndex:0];
            
            ret = [element sizeWithFont:FONT_DEFAULT(TEXT_FONT_SIZE) 
                      constrainedToSize:CGSizeMake(_cellWidth, 9999.f)].height;
        }
        else if (indexPath.row == 2)
        {
            ret = _introLabel.bounds.size.height;
        }
        else 
        {
            NSString *element = [_elements objectAtIndex:indexPath.row + 2];
            
            ret = [element sizeWithFont:FONT_DEFAULT(TEXT_FONT_SIZE) 
                      constrainedToSize:CGSizeMake(_cellWidth, 9999.f)].height;
        }
    }

    return ret;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do nothing
}

@end
















