//
//  GKKit/GKUtil.m
//  Utility functions
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://eod.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "GKUtil.h"

@implementation GKUtil

+ (UIImage *)loadImage:(NSString *)imageResource ofType:(NSString *)imageType {
	NSString *imageFile;
	UIImage *image = nil;
	
	imageFile = [[NSBundle mainBundle] pathForResource:imageResource ofType:imageType];
	if (imageFile) {
		image = [[UIImage alloc] initWithContentsOfFile:imageFile];
	}
	
	return image;
}

+ (AVAudioPlayer *)loadSound:(NSString *)soundResource ofType:(NSString *)soundType {
	NSString *soundFile;
	NSURL *soundUrl;
	AVAudioPlayer *sound = nil;
	
	soundFile = [[NSBundle mainBundle] pathForResource:soundResource ofType:soundType];
	if (soundFile) {
		soundUrl = [[NSURL alloc] initFileURLWithPath:soundFile];
		if (soundUrl) {
			sound = [[AVAudioPlayer alloc] initWithContentsOfURL:soundUrl error:nil];
			if (sound) {
				[sound prepareToPlay];
			}
			[soundUrl release];
		}
	}
	
	return sound;
}

// This code is based on Marco Peluso's iPhone Insomnia, http://github.com/marcop/iPhoneInsomnia.
// It's been modified to set various session properties before setting it active, so any currently
// playing sounds will continue to play.

NSTimer *sleepTimer = nil;
AVAudioPlayer *sleepSound = nil;

+ (void)preventSleepCallback {
	[sleepSound play];
}

+ (BOOL)preventSleep:(BOOL)preventSleep {

	if (sleepTimer) {
		[sleepTimer invalidate];
		sleepTimer = nil;
		AudioSessionSetActive(false);
	}
	if (preventSleep) {
		UInt32 argument;

		AudioSessionInitialize(NULL,NULL,NULL,NULL);
		argument = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,sizeof(argument),&argument);
		argument = true;
		if (AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers,sizeof(argument),&argument) != 0) {
			return NO;
		}
		if (AudioSessionSetActive(true) != kAudioSessionNoError) {
			return NO;
		}

		sleepSound = [GKUtil loadSound:@"GKUtil Silence" ofType:@"wav"];
		if (!sleepSound) {
			AudioSessionSetActive(false);
			return NO;
		}
		[sleepSound setVolume:0.0];
		
		sleepTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(preventSleepCallback) userInfo:nil repeats:YES];
	}

	return YES;
}

@end
