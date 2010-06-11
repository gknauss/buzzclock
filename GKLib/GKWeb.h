//
//  GKKit/GKWeb.m
//  Web functions
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://eod.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import <UIKit/UIKit.h>

@interface GKWebViewController : UIViewController {
	UIWebView *webView;
}
- (id)initWithResource:(NSString *)resourceName andTitle:(NSString *)title;
@end
