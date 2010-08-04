//
//  FlipsideViewController.m
//  Buzz Clock
//
//  Author:  Greg Knauss <greg@eod.com>
//  Site:    http://buzzclockapp.com
//  License: http://creativecommons.org/licenses/by/3.0/
//

#import "FlipsideViewController.h"
#import "GKWeb.h"

@implementation FlipsideViewController
@synthesize delegate;

int prefInterval = 1;

// UITableView delegates *******************************************************
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 3;
		case 1:
			return 4;
	}
	return 0;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return @"Interval";
		case 1:
			return @"About";
			break;
	}
	return nil;
}

- (NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	switch (section) {
		case 0:
			// return @"Foot 1";
		case 1:
			// return @"Foot 2";
			break;
	}
	return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView2 cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	UITableViewCell *cell = nil;

	switch (indexPath.section) {
		case 0:
		{
			NSString *names[3] = {
				@"5 Minutes",
				@"15 Minutes",
				@"30 Minutes"
			};
			
			cell = [tableView2 dequeueReusableCellWithIdentifier:@"pref"];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"pref"];
			}
			cell.textLabel.text = names[indexPath.row];
			if ((prefInterval >= 0) && (indexPath.row == prefInterval)) {
				cell.accessoryType = UITableViewCellAccessoryCheckmark;
				prefInterval = -1;
			}
			break;
		}
		case 1:
		{
			NSString *text;
			NSString *detail;
			UITableViewCellAccessoryType accessory;
			BOOL selectable;
			
			cell = [tableView2 dequeueReusableCellWithIdentifier:@"info"];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"info"];
			}
			
			detail = @"";
			accessory = UITableViewCellAccessoryNone;
			selectable = YES;
			switch (indexPath.row) {
				case 0:
					text = @"Instructions";
					accessory = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case 1:
					text = @"Website";
					detail = @"buzzclockapp.com";
					accessory = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case 2:
					text = @"Version";
					detail = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"]];
					accessory = UITableViewCellAccessoryDisclosureIndicator;
					break;
				case 3:
					text = @"Author";
					detail = @"Greg Knauss";
					selectable = NO;
					break;
			}
			cell.textLabel.text = text;
			cell.detailTextLabel.text = detail;
			cell.accessoryType = accessory;
			cell.selectionStyle = (selectable)?UITableViewCellSelectionStyleBlue:UITableViewCellSelectionStyleNone;
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView2 didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch (indexPath.section) {
		case 0: {
			[GKPref setPreference:"interval" toInteger:indexPath.row];

			for (int i = 0; i < [tableView2 numberOfRowsInSection:indexPath.section]; i++) {
				[tableView2 cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:indexPath.section]].accessoryType = (indexPath.row == i)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
			}
			[tableView2 deselectRowAtIndexPath:indexPath animated:YES];
			break;
		}
		case 1:
			switch (indexPath.row) {
				case 0:
					[self.navigationController pushViewController:instructionsController animated:YES];
					[tableView2 deselectRowAtIndexPath:indexPath animated:NO];
					break;
				case 1:
					[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://buzzclockapp.com"]];
					break;
				case 2:
					[self.navigationController pushViewController:changelogController animated:YES];
					[tableView2 deselectRowAtIndexPath:indexPath animated:NO];
					break;
			}
			break;
	}
}

// UIViewController delegates **************************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
	
	prefInterval = [GKPref getPreferenceAsCInt:"interval" withDefault:1];
	instructionsController = [[GKWebViewController alloc] initWithResource:@"about" andTitle:@"Instructions"];
	changelogController = [[GKWebViewController alloc] initWithResource:@"change" andTitle:@"Versions"];
}

- (void)viewDidUnload {	
	[super viewDidUnload];
	[instructionsController release];
	[changelogController release];
}

@end
