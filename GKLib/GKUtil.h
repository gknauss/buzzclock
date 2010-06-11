//
//  GKKit/GKUtil.h
//  Utility functions
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://eod.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioServices.h>

@interface GKUtil : NSObject {
}
+ (UIImage *)loadImage:(NSString *)imageResource ofType:(NSString *)imageType;
+ (AVAudioPlayer *)loadSound:(NSString *)soundResource ofType:(NSString *)soundType;
+ (BOOL)preventSleep:(BOOL)preventSleep;
@end
