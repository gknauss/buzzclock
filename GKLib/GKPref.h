//
//  GKKit/GKPref.h
//  Preference functions
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://eod.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import <Foundation/Foundation.h>

@interface GKPref : NSObject {
}
+ (void)setPreference:(char *)prefName toInteger:(int)prefValue;
+ (int)getPreferenceAsCInt:(char *)prefName withDefault:(int)prefDefault;
+ (int)getPreferenceAsCInt:(char *)prefName;
@end
