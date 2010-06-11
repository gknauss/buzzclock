//
//  MainViewController.m
//  Buzz Clock
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://buzzclockapp.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "MainViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "GKUtil.h"


@implementation MainViewController

@synthesize label;

// MainViewController delegates ************************************************

// Creation and destruction ====================================================
UIImage* stillImage;
UIImage* buzzImage;
FlipsideViewController* flipsideViewController;
UINavigationController* flipsideNavigationController;
NSTimer*                mainTimer;
NSDateFormatter*        mainFormat;
int                     mainInterval;
NSTimer*                buzzTimer;
int                     buzzTimes[3] = {5, 15, 30};
int                     buzzFlags[4+(60/5)*2+1];
int                     buzzIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		
		// Load up everything we're going to deal with from this screen
		stillImage = [GKUtil loadImage:@"head_norm" ofType:@"png"];
		buzzImage = [GKUtil loadImage:@"head_buzz" ofType:@"png"];

		flipsideViewController = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
		flipsideViewController.delegate = self;
			
		flipsideNavigationController = [[UINavigationController alloc] initWithRootViewController:flipsideViewController];
		flipsideNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
		flipsideNavigationController.navigationBar.topItem.title = @"Buzz Clock";
		flipsideNavigationController.navigationBar.topItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(flipsideViewControllerDidFinish:)];

		mainFormat = [[NSDateFormatter alloc] init];
		[mainFormat setDateFormat:@"mm"];

		mainInterval = [GKPref getPreferenceAsCInt:"interval" withDefault:1];
    }	
	
	return self;
}

- (void)viewDidLoad {

	[super viewDidLoad];
	
	// Bail if we're not an iPhone
	if (![[[[UIDevice currentDevice] model] substringToIndex:6] isEqualToString:@"iPhone"]) {
		[[[[UIAlertView alloc] initWithTitle:[[UIDevice currentDevice] model] message:@"\n\nBuzz Clock only runs on a\niPhone, because it requires\nthe vibration function. Sorry!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease] show];
	}
	
	// Init the deep-sleep preventer, so that the phone doesn't go to sleep while it's running and
	// we can continue to buzz.
	if (![GKUtil preventSleep:YES]) {
		[[[[UIAlertView alloc] initWithTitle:[[UIDevice currentDevice] model] message:@"\n\nBuzz Clock couldn't convince\nthe phone to stay awake! Sorry!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil] autorelease] show];
	}

	// Turn on the buzzing when the view becomes available
	[self toggleMain];
}

- (void)viewDidUnload {
	[GKUtil preventSleep:NO];
}

- (void)dealloc {
	[stillImage release];
	[buzzImage release];
	
	[flipsideNavigationController.navigationBar.topItem.leftBarButtonItem release];
	[flipsideNavigationController release];
	[flipsideViewController release];

	[mainFormat release];
	
    [super dealloc];
}

// Button handling ==============================================================
- (IBAction)showInfo {
	
	// Don't buzz while we're showing the information view
	[self toggleMain];
	
	// Flip to the information
	[self presentModalViewController:flipsideNavigationController animated:YES];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	// Flip to the main view
	[self dismissModalViewControllerAnimated:YES];
	
	// Turn buzzing back on
	[self toggleMain];
	
	// Get any new interval value
	mainInterval = [GKPref getPreferenceAsCInt:"interval"];
}

// Buzz handling ===============================================================
- (void)callbackBuzz {
	
	// If we've reached the end of the sequence, shut it down
	if (buzzFlags[buzzIndex] == -1) {
		if (buzzTimer) {
			[buzzTimer invalidate];
			buzzTimer = nil;
#ifdef DEBUG
			label.text = [NSString stringWithFormat:@"%@",[NSDate date]];
#endif
		}
		return;
	}
	
	// Buzz, and show the appropriate image
	if (buzzFlags[buzzIndex]) {
		imageView.image = buzzImage;
		AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
#ifdef DEBUG
		label.text = @"Buzz!";
#endif
	}
	else {
		imageView.image = stillImage;
#ifdef DEBUG
			label.text = @"Pause...";
#endif
	}
	
	buzzIndex++;
}

- (void)startBuzz:(int)count {

	// Stop any current sequence
	buzzIndex = 0;
	buzzFlags[0] = -1;
	[self callbackBuzz];

	// Build the buzz sequence
	int size = sizeof(buzzFlags)/sizeof(buzzFlags[0]);
	for (int i = 0; i < size-1; i++) {
		buzzFlags[i] = (i < 3) || (((i-4)%2 == 0) && (i-4 < count*2));
	}
	buzzFlags[size-1] = -1;
	
	// Start the timer
	buzzIndex = 0;
	buzzTimer = [NSTimer scheduledTimerWithTimeInterval:0.525 target:self selector:@selector(callbackBuzz)  userInfo:nil repeats:YES];
}

- (void)callbackMain {
	int minuteCurrent;
	static int minuteLast = -1;

	// Get the current minute
	minuteCurrent = [[mainFormat stringFromDate:[NSDate date]] intValue];
	if (minuteLast == -1)
	{
		minuteLast = minuteCurrent;
	}
	
	// If we haven't already gone off on this minute and it's one we care about...
	if ((minuteCurrent != minuteLast) &&
		(minuteCurrent%(buzzTimes[mainInterval]) == 0)) {

		minuteLast = minuteCurrent;

		// Buzz, damn you!  Buzz!
		[self startBuzz:minuteCurrent/buzzTimes[mainInterval]];
	}
}

- (void)toggleMain {
	if (buzzTimer) {
		[buzzTimer invalidate];
		buzzTimer = nil;
	}
	if (mainTimer) {
		[mainTimer invalidate];
		mainTimer = nil;
	}
	else {
		mainTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(callbackMain) userInfo:nil repeats:YES];
	}
}

@end
