//
//  GKKit/GKPref.m
//  Preference functions
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://eod.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "GKPref.h"

@implementation GKPref

+ (void)setPreference:(char *)prefName toInteger:(int)prefValue {
	CFStringRef tempName;
	CFNumberRef tempValue;
	
	tempName = CFStringCreateWithCString(NULL, prefName, kCFStringEncodingASCII);
	tempValue = CFNumberCreate(NULL, kCFNumberIntType, &prefValue);

	CFPreferencesSetAppValue(tempName, tempValue, kCFPreferencesCurrentApplication);
	
	CFRelease(tempName);
	CFRelease(tempValue);
	
	CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
}

+ (int)getPreferenceAsCInt:(char *)prefName withDefault:(int)prefDefault {
	CFStringRef tempName;
	CFNumberRef tempValue;
	int prefValue = prefDefault;

	tempName = CFStringCreateWithCString(NULL, prefName, kCFStringEncodingASCII);
	tempValue = (CFNumberRef)CFPreferencesCopyAppValue(tempName, kCFPreferencesCurrentApplication);

	if (tempValue) {
		CFNumberGetValue(tempValue, kCFNumberIntType, &prefValue);
		CFRelease(tempValue);
	}
	CFRelease(tempName);
	
	return prefValue;
}

+ (int)getPreferenceAsCInt:(char *)prefName {
	return [GKPref getPreferenceAsCInt:prefName withDefault:0];
}

@end
