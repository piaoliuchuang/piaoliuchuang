//
//  PickWordViewController.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-27.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "PickWordViewController.h"
#import "DrawViewController.h"
#import "DrNavigationController.h"
#import "GameDataFetcher.h"
#import "KMKeyboardContainer.h"
#import "KMEnrollView.h"

#define TABLE_VIEW_WIDTH 270.f
#define CELL_HEIGHT 40.f
#define TABLE_VIEW_ORIGIN_UP 180.f
#define BACKGROUND_COLOR_STR @"#8dcaea"

#define PADDING 10.f
#define WORD_TITLE   @"或直接输入英文单词："
#define WORD_RULE    @"* 1到8个小写英文字符"
#define INPUT_VIEW_WIDTH 240.f
#define INPUT_VIEW_HEIGHT 32.f

@interface TitleCell2 : UITableViewCell

@end

@implementation TitleCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"f6a54f"];
        self.textLabel.textColor = [UIColor colorWithHexString:title_cell_text_color_str];
        self.textLabel.font = FONT_CHINESE(17.f);
        self.textLabel.textAlignment = UITextAlignmentCenter;
    }
    return self;
}

@end

@interface PickWordViewController () <UITableViewDataSource, UITableViewDelegate, KMEnrollViewDelegate> {

    DrNavigationController *_nav;
    NSArray *_words;
}

@property (nonatomic, retain) KMKeyboardContainer *keyboardContainer;
@property (nonatomic, retain) UITableView         *tableView;
@property (nonatomic, retain) KMEnrollView        *inputView;
@property (nonatomic, retain) NSArray             *words;

@end

@implementation PickWordViewController

@synthesize keyboardContainer =_keyboardContainer;
@synthesize tableView         =_tableView;
@synthesize inputView         =_inputView;
@synthesize words             =_words;

#pragma mark - private

- (void)leftBtnClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - public
#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];

    self.view.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR_STR];
    
    CGRect vFrame = VIEW_CONTROLLERS_FRAME;

    self.keyboardContainer = [[[KMKeyboardContainer alloc] initWithFrame:vFrame] autorelease];
    [self.view addSubview:_keyboardContainer];

    CGRect tFrame = vFrame;
    tFrame.origin.x    = (tFrame.size.width - TABLE_VIEW_WIDTH) / 2;
    tFrame.size.width  = TABLE_VIEW_WIDTH;

    self.tableView = [[[UITableView alloc] initWithFrame:tFrame style:UITableViewStyleGrouped] autorelease];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    [_tableView setBackgroundView:nil];
    _tableView.backgroundColor = [UIColor clearColor];
    [_keyboardContainer addSubview:_tableView];

    CGRect iFrame = _tableView.frame;
    iFrame.origin.x = (_tableView.frame.size.width - INPUT_VIEW_WIDTH) / 2;
    iFrame.origin.y += (_tableView.frame.size.height - CELL_HEIGHT * ([_words count] + 1)) / 2 + PADDING + 20.f;
    iFrame.size.width = INPUT_VIEW_WIDTH;
    iFrame.size.height = INPUT_VIEW_HEIGHT;

    self.inputView = [[[KMEnrollView alloc] initWithFrame:iFrame 
                                                    title:WORD_TITLE 
                                              placeholder:@"" 
                                                     rule:WORD_RULE] autorelease];
    _inputView.kmDelegate = self;
    _inputView.minNum = 1;
    _inputView.maxNum = 8;
    
    [_tableView addSubview:_inputView];
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
    
    [_nav setDrTitle:@"挑一个吧" type:TITLE_VIEW_TYPE_NORMAL];
    [_nav.kmNavigationBar showShadow:YES];
    
    self.words = [[GameDataFetcher sharedFetcher] randomWords];
    
    [_tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    self.keyboardContainer = nil;
    self.tableView         = nil;
    self.inputView         = nil;
    self.words             = nil;

    [super dealloc];
}

#pragma mark - KMEnrollViewDelegate

- (void)enrollView:(KMEnrollView *)enrollView textFieldDidEndEditing:(UITextField *)textField
{
    DrawViewController *control = [[DrawViewController alloc] init];
    
    WordModel *word = [[WordModel alloc] init];
    word.wordStr = textField.text;
    word.wordType = WORD_TYPE_USER_MAKE;
    
    control.word = word;
    [word release];
    
    [self.navigationController pushViewController:control animated:YES];
    [control release];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return (tableView.frame.size.height - CELL_HEIGHT * ([_words count] + 1) - TABLE_VIEW_ORIGIN_UP) / 2;
    }
    else {
        return 0.f;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [_words count] + 1;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *titleCell2Identifier = @"title_cell_identifier";
    static NSString *wordCellIdentifier  = @"word_cell_identifier";

    if (indexPath.row == 0)
    {
        UITableViewCell *cell = nil;

        cell = [tableView dequeueReusableCellWithIdentifier:titleCell2Identifier];
        if (cell == nil)
        {
            cell = [[[TitleCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleCell2Identifier] autorelease];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        if (indexPath.section == 0)
        {
            cell.textLabel.text = @"候选词";
        }

        return cell;
    }
    else if (indexPath.section == 0)
    {
        UITableViewCell *cell = nil;
        
        cell = [tableView dequeueReusableCellWithIdentifier:wordCellIdentifier];
        if (cell ==  nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:wordCellIdentifier] autorelease];
        }
        cell.textLabel.text = ((WordModel *)[_words objectAtIndex:indexPath.row - 1]).wordStr;
        
        return cell;
    }
    else
    {
        return nil;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        // do nothing
    }
    else 
    {
        if (indexPath.section == 0) {
            DrawViewController *control = [[DrawViewController alloc] init];
            control.word = [_words objectAtIndex:indexPath.row - 1];
            [self.navigationController pushViewController:control animated:YES];
            [control release];
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
