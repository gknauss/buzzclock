//
//  MainViewController.h
//  Buzz Clock
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://buzzclockapp.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "FlipsideViewController.h"
#include <UIKit/UIKit.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate> {
	IBOutlet UIImageView *imageView;
	IBOutlet UITextView *messagesView;
	IBOutlet UIButton *infoButton;
}
@property (nonatomic,retain) UITextView *messagesView;
@property (nonatomic,retain) UIButton *infoButton;
- (IBAction)showInfo;
- (void)setMain:(BOOL)flag;  // Oh, C derivatives. Prototypes for forward calls are so 1980s.
@end
