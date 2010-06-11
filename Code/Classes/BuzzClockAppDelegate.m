//
//  BuzzClockAppDelegate.m
//  Buzz Clock
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://buzzclockapp.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "BuzzClockAppDelegate.h"
#import "MainViewController.h"

@implementation BuzzClockAppDelegate

@synthesize window;
@synthesize mainViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	// This is all boilerplate that comes from the creation of the project.  It just causes
	// the view to load and get attached to the window.
	MainViewController *aController = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
	self.mainViewController = aController;
	[aController release];
	
    mainViewController.view.frame = [UIScreen mainScreen].applicationFrame;
	[window addSubview:[mainViewController view]];
    [window makeKeyAndVisible];
	
	return YES;
}

- (void)dealloc {
    [mainViewController release];
    [window release];
    [super dealloc];
}

@end
