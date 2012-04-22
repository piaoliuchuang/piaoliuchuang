//
//  AudioManager.m
//  Drawus
//
//  Created by Tianhang Yu on 12-4-3.
//  Copyright (c) 2012年 99fang. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "AudioManager.h"

@interface AudioManager () {
    
    SystemSoundID shortSound;
}

@end

static AudioManager *_sharedManager = nil;

@implementation AudioManager

#pragma mark - class methods

#pragma mark - class methods

+ (AudioManager *)sharedManager
{
	@synchronized(self) {
		if (_sharedManager == nil)
		{
			_sharedManager = [[AudioManager alloc] init];
		}
	}
	return _sharedManager;
}

+ (id)alloc
{
	NSAssert(_sharedManager == nil, @"Attempted to allocate a second instance of a singleton!");
	return [super alloc];
}

#pragma mark - public

- (void)playSoundByType:(SHORT_SOUND_TYPE)soundType
{
    if (soundType == SHORT_SOUND_TYPE_SHAKE) {
        
        // 播放声音
        // beep 1106
        // shutter 1108
        // shake 1109
        AudioServicesPlaySystemSound(1109);
        
        // 声音震动效果，没听出有什么区别
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}

#pragma mark - default

- (id)init
{
    self = [super init];
    if (self) {
        // 自定义音效
        // Get the full path of Sound12.aif
        NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"Sound12"
                                                              ofType:@"aif"];
        // If this file is actually in the bundle...
        if (soundPath) {
            // Create a file URL with this path
            NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
            
            // Register sound file located at that URL as a system sound
            OSStatus err = AudioServicesCreateSystemSoundID((CFURLRef)soundURL, 
                                                            &shortSound);
            if (err != kAudioServicesNoError)
                NSLog(@"Could not load %@, error code: %@", soundURL, err);
        }
    }
    return self;
}

@end
