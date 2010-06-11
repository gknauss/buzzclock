//
//  GKKit/GKWeb.m
//  Web functions
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://eod.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "GKWeb.h"

@implementation GKWebViewController

- (id)initWithResource:(NSString *)resourceName andTitle:(NSString *)title {
	
	if ((self = [super initWithNibName:nil bundle:nil])) {
		NSString *resourceFile = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"html"];
		NSString *resourcePath = [resourceFile stringByDeletingLastPathComponent];
		NSURL *resourceUrl = [NSURL fileURLWithPath:resourcePath];
		NSString *htmlString = [[[NSString alloc] initWithContentsOfFile:resourceFile] autorelease];

		webView = [[UIWebView alloc] init];
		[webView loadHTMLString:htmlString baseURL:resourceUrl];
		[self setView:webView];
		self.navigationItem.title = title;
	}
	
	return self;
}

- (void)dealloc {
	
	[webView release];
    [super dealloc];
}

@end
