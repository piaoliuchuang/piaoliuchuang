//
//  Drawus-Colors.h
//  Drawus
//
//  Created by Tianhang Yu on 12-3-24.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TestAvalibles.h"
#import "PlayerModel.h"

#define USERNAME_MAXIMUM 20

// player status
typedef enum {
	PLAYER_STATUS_WAITING_OTHERS_GUESSING,
	PLAYER_STATUS_WAITING_OTHERS_DRAWING,
	PLAYER_STATUS_WAITING_YOU_GUESSING,
	PLAYER_STATUS_WAITING_YOU_DRAWING
} PLAYER_STATUS;

#define PLAYER_STATUS_WAITING_OTHERS_GUESSING_STR @"其他人正在猜"
#define PLAYER_STATUS_WAITING_OTHERS_DRAWING_STR  @"其他人正在画"
#define PLAYER_STATUS_WAITING_YOU_GUESSING_STR    @"等待你猜"
#define PLAYER_STATUS_WAITING_YOU_DRAWING_STR     @"等待你画"

// colors
#define main_vc_background_color_str          @"#cde4fc"
#define title_cell_background_color_str       @"#e1e1e1"
#define title_cell_text_color_str             @"#ca534a"
#define create_game_cell_background_color_str @"#8cc0f9"
#define setup_vc_background_color_str         @"#f1f1f1"
#define setup_segment_tint_color_str          @"00b3f9"
#define letter_button_background_color_str    @"#27a7ff"
#define pick_blank_border_color_str 		  @"#77c9ff"

// line widths
#define LEVELS_LINE_WIDTH 4

extern CGFloat firstLevelLineWidth;
extern CGFloat secondLevelLineWidth;
extern CGFloat thirdLevelLineWidth;
extern CGFloat forthLevelLineWidth;

// user default
#define USER_DEFAULT_KEY_USERNAME @"user_default_key_username"
#define user_default_key_game_mode @"user_default_key_game_mode"	// unused, will add this next version

static inline void setUsername (NSString *username) {

	[[NSUserDefaults standardUserDefaults] setObject:username forKey:USER_DEFAULT_KEY_USERNAME];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DEFAULT_KEY_USERNAME object:nil];
}

static inline NSString* username () {

	return [[NSUserDefaults standardUserDefaults] stringForKey:USER_DEFAULT_KEY_USERNAME];
}

typedef enum {
    game_mode_type_three,
    game_mode_type_two
} game_mode_type;

static inline void setGameMode (game_mode_type gameModeType) {

	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:gameModeType] forKey:user_default_key_game_mode];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

static inline game_mode_type gameMode () {
	
	return [[[NSUserDefaults standardUserDefaults] objectForKey:user_default_key_game_mode] intValue];
}

#define user_default_key_game_language @"user_default_key_game_language"

typedef enum {
	game_language_type_chinese,
	game_language_type_english
} game_language_type;

static inline void setGameLanguage (game_language_type gameLanguageType) {

	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:gameLanguageType] forKey:user_default_key_game_language];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

static inline game_language_type gameLanguage () {

	return [[[NSUserDefaults standardUserDefaults] objectForKey:user_default_key_game_language] intValue];
}

#define user_default_key_app_skin @"user_default_key_app_skin"

typedef enum {
    app_skin_type_google_blue,
    app_skin_type_path_red
} app_skin_type;

static inline void setAppSkin (app_skin_type appSkinType) {

	[[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:appSkinType] forKey:user_default_key_app_skin];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

static inline app_skin_type appSkin () {

	return [[[NSUserDefaults standardUserDefaults] objectForKey:user_default_key_app_skin] intValue];
}

// me
static inline PlayerModel* me () {

	PlayerModel *me = [[PlayerModel alloc] init];
	me.username = username();

	return me;
}

@interface Drawus_Constants : NSObject

@end








