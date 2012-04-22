//
//  PickWordView.m
//  Drawus
//
//  Created by Tianhang Yu on 12-3-25.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import "PickLetterView.h"
#import "WordModel.h"
#import "LetterButton.h"
#import "PickBlank.h"
#import "DrSimpleIndicator.h"

const char unused = '0';

#define POOL_LINE_COUNT 2
#define POOL_LINE_LETTER_COUNT 8
#define VERTICAL_MARGIN 3.f
#define LETTER_BUTTON_TAG_PREFIX 100 * 10	// means prefix is 100
#define PICK_BLAND_TAG_PREFIX 	 101 * 10

@interface PickLetterView () <LetterButtonDelegate> {

	NSInteger length;
	CGFloat letterSquare;
	CGFloat horizontalMargin;

	NSInteger pickedCount;

	NSMutableArray *_letterBtnAry;
	NSMutableArray *_pickBlankAry;
	NSMutableArray *_pickedBtnAry;

	NSMutableString *_guessWord;
}

@end

@implementation PickLetterView

@synthesize drDelegate=_drDelegate;
@synthesize word=_word;

#pragma mark - private

- (NSArray *)randomLocations:(int)wordLength inRange:(int)range
{
    NSMutableArray *locations = [NSMutableArray array];
    
    do {
        int randomNumber = arc4random()%range;
        
        BOOL included = NO;
        
        for (NSNumber *number in locations) {
            if ([number intValue] == randomNumber) {
                included = YES;
                break;
            }
        }
        
        if (!included) {
            [locations addObject:[NSNumber numberWithInt:randomNumber]];
        }    
        
//        NSLog(@"location:%@", [locations objectAtIndex:[locations count] - 1]);
    } while ([locations count] < wordLength);
    
    [locations sortUsingSelector:@selector(compare:)];
    
//    NSLog(@"sorted locations:%@", locations);
    
    return locations;
}

- (NSArray *)randomLetters:(NSString *)word needLength:(int)needLength
{
    NSMutableArray *letters = [NSMutableArray array];
    
    NSArray *locations = [self randomLocations:[word length] inRange:POOL_LINE_COUNT * POOL_LINE_LETTER_COUNT];
    
    int index = 0;
    do {
        if (index < word.length && [letters count] == [[locations objectAtIndex:index] intValue]) 
        {    
            [letters addObject:[NSNumber numberWithChar:[word characterAtIndex:index]]];
            index ++;
        }
        else
        {
            int randomLetter = 'a' + arc4random()%26;
            [letters addObject:[NSNumber numberWithInt:randomLetter]];
        }
        
//        NSLog(@"letter:%@", [letters objectAtIndex:[letters count] - 1]);
    } while ([letters count] < needLength);
    
    return letters;
}

- (int)addCharToGuessWord:(char)pickChar
{
	BOOL added = NO;
	int i;
    
    for (i = 0; i < _guessWord.length; i++) {
        char c = [_guessWord characterAtIndex:i];
        
        if (c == unused)
		{
			[_guessWord replaceCharactersInRange:NSMakeRange(i, 1) withString:[NSString stringWithFormat:@"%c", pickChar]];
			added = YES;
            
			break;
		}
    }

	if (!added)
	{
		[_guessWord appendFormat:@"%c", pickChar];
	}

	return i;
}

#pragma mark - public

- (void)setWord:(WordModel *)word
{
	[_word release];
	_word = [word retain];

	length = [_word.wordStr length];

	CGRect vFrame = self.bounds;

	letterSquare = (vFrame.size.height - (POOL_LINE_COUNT + 3) * VERTICAL_MARGIN) / (POOL_LINE_COUNT + 1);
	horizontalMargin = (vFrame.size.width - letterSquare * POOL_LINE_LETTER_COUNT) / (POOL_LINE_LETTER_COUNT + 1);

	CGRect pbFrame = self.bounds; // CGRectMake(0, 0, vFrame.size.width, letterSquare + 2*VERTICAL_MARGIN);

	UIView *pickedBgView = [[UIView alloc] initWithFrame:pbFrame];
	pickedBgView.alpha = 0.4;
	pickedBgView.backgroundColor = [UIColor colorWithHexString:@"#cde4fc"];
	[self addSubview:pickedBgView];
	[pickedBgView release];

	CGFloat subviewsX      = horizontalMargin;
	CGFloat subviewsY      = VERTICAL_MARGIN;
	CGFloat subviewsWidth  = letterSquare;
	CGFloat subviewsHeight = letterSquare;

	for (int i = 0; i < POOL_LINE_LETTER_COUNT; ++i)
	{
		PickBlank *blank = [[PickBlank alloc] initWithFrame:CGRectMake(subviewsX, subviewsY, subviewsWidth, subviewsHeight) 
                                                      solid:(i >= [_word.wordStr length])];
		blank.tag = PICK_BLAND_TAG_PREFIX + i;
		[self addSubview:blank];
		[_pickBlankAry addObject:blank];
		[blank release];

		subviewsX += letterSquare + horizontalMargin;
	}

	subviewsX = horizontalMargin;
	subviewsY += letterSquare + 2*VERTICAL_MARGIN;

    NSArray *letters = [self randomLetters:word.wordStr needLength:POOL_LINE_COUNT * POOL_LINE_LETTER_COUNT];
    
	for (int j = 0; j < POOL_LINE_COUNT * POOL_LINE_LETTER_COUNT; ++j)
	{
		LetterButton *letterBtn = [[LetterButton alloc] initWithFrame:CGRectMake(subviewsX, subviewsY, subviewsWidth, subviewsHeight)];
		letterBtn.drDelegate = self;
        letterBtn.letter = [[letters objectAtIndex:j] charValue];
        letterBtn.borderColor = [UIColor clearColor];
        letterBtn.bgColor = [UIColor colorWithHexString:letter_button_background_color_str];
		letterBtn.tag = LETTER_BUTTON_TAG_PREFIX + j;
		[self addSubview:letterBtn];
		[_letterBtnAry addObject:letterBtn];
		[letterBtn release];

		if (j == POOL_LINE_LETTER_COUNT - 1)
		{
			subviewsY += letterSquare + VERTICAL_MARGIN;
			subviewsX = horizontalMargin;
		}
		else
		{
			subviewsX += letterSquare + horizontalMargin;
		}
	}
}

- (void)resetLetterButtons
{
    if (pickedCount != 0) {
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             for (LetterButton *btn in _pickedBtnAry) {
                                 btn.frame = btn.preFrame;
                             }
                         }
                         completion:^(BOOL finished){
                             [_pickedBtnAry removeAllObjects];
                             
                             [_guessWord release];
                             _guessWord = nil;
                             _guessWord = [[NSMutableString alloc] init];
                             
                             pickedCount = 0;
                         }];    
    }
}

#pragma mark - LetterButtonDelegate

- (void)didClickedLetterButton:(LetterButton *)letterButton
{
    if ([_pickedBtnAry containsObject:letterButton]) 
    {
        int index = [_pickedBtnAry indexOfObject:letterButton];
        [_guessWord replaceCharactersInRange:NSMakeRange(index, 1) withString:[NSString stringWithFormat:@"%c", unused]];
        [_pickedBtnAry replaceObjectAtIndex:index withObject:[NSNull null]];
        
        pickedCount --;
        
        CGRect aFrame = letterButton.preFrame;
        [UIView animateWithDuration:0.3 
                         animations:^{
                             letterButton.frame = aFrame;
                         }
                         completion:^(BOOL finished){
                         }];
    }
    else
    {
        if (pickedCount < length)
		{
			int index = [self addCharToGuessWord:letterButton.letter];
            
            if (index < [_pickedBtnAry count]) 
            {
                [_pickedBtnAry replaceObjectAtIndex:index withObject:letterButton];
            }
            else 
            {
                [_pickedBtnAry addObject:letterButton];
            }
            
            pickedCount ++;
            
			CGRect aFrame = ((PickBlank *)[_pickBlankAry objectAtIndex:index]).frame;
			[UIView animateWithDuration:0.3 
		                     animations:^{
                                 letterButton.preFrame = letterButton.frame;
                                 letterButton.frame = aFrame;
		                     }
		                     completion:^(BOOL finished){
                                 
                 if (pickedCount == length)
                 {
                     if ([_guessWord isEqualToString:_word.wordStr])
                     {
                         if (_drDelegate != nil)
                         {
                             if ([_drDelegate respondsToSelector:@selector(correctWord:)])
                             {
                                 [_drDelegate correctWord:self];
                             }
                         }
                     }
                     else
                     {
                         [[DrSimpleIndicator sharedIndicator] showMessage:@"单词错误" withY:280.f];
                     }
                 }	
             }];
        }
    }
}

#pragma mark - default

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        pickedCount = 0;

        _letterBtnAry = [[NSMutableArray alloc] init];
        _pickBlankAry = [[NSMutableArray alloc] init];
        _pickedBtnAry = [[NSMutableArray alloc] init];

        _guessWord = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)dealloc
{
	[_letterBtnAry release];
	_letterBtnAry = nil;

	[_pickBlankAry release];
	_pickBlankAry = nil;

	[_pickedBtnAry release];
	_pickedBtnAry = nil;

	[_guessWord release];
	_guessWord = nil;

	self.word = nil;

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

//char randomLetter ()
//{
//	int i;
//	char c;
//    
//	srand((unsigned)time(NULL) + rand());
//    
//    //	i=rand()&1; // i用来控制产生的字母是大写还是小写
//    
//    i = 1;
//    
//	if(i==0)
//		c='A'+rand()%26;
//	else
//		c='a'+rand()%26;
//    
//	printf("%c\n",c);
//    
//    return c;
//}
//
//int* randomLocations (int wordLength, int range)
//{
//	srand((unsigned)time(NULL) + rand());
//    
//	int *locations = (int *)malloc(wordLength + 1);
//    
//    int length = 0;
//    do {
//        int random = rand()%range;
//    	bool included = false;
//        
//        for (int i = 0; i < length; ++i)
//        {
//        	if (random == locations[i])
//        	{
//        		included = true;
//        		break;
//        	}
//        }
//        
//    	if (included == false)
//    	{
//    		locations[length] = random;
//            
//    		printf("%d\n", locations[length]);
//    		
//            length ++;
//    	}
//    } while (length < wordLength);
//    
//	return locations;
//}
//
//char* randomLetters (const char* word, int wordLength, int needLength)
//{
//	char *letters = (char *)malloc(needLength + 1);
//	int length = 0;
//    
//	int  *locations = malloc(wordLength + 1);
//    locations = randomLocations(wordLength, needLength);
//    
//	int index = 0;	// locations 的索引
//    
//	do {
//		if (length == locations[index])
//		{
//			letters[length] = word[index];
//			length ++;
//			index ++;
//		}
//		else
//		{
//			char c = randomLetter();
//            
//			bool included = false;
//            
//			for (int i = 0; i < wordLength; ++i)
//			{
//				if (c == word[i])
//				{
//					included = true;
//					break;
//				}
//			}
//	        
//	        if (included == false)
//	        {
//	        	letters[length] = c;
//				length ++;		
//	        }
//		}  	
//	} while (length < needLength);
//    
//    //    free(locations);
//	
//    return letters;
//}

