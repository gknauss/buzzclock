//
//  FlipsideViewController.h
//  Buzz Clock
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://buzzclockapp.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import <UIKit/UIKit.h>
#import "GKPref.h"
#import "GKWeb.h"

@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController {
	
	id <FlipsideViewControllerDelegate> delegate;
	IBOutlet UITableView *tableView;
	GKWebViewController *instructionsController;
}
@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end
