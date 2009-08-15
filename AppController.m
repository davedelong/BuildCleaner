//
//  AppController.m
//  BuildCleaner
//
//  Created by CS Webmaster on 2/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "Cleaner.h"
#import "SettingsController.h"

static NSString * units[8] = {@"B", @"KB", @"MB", @"GB", @"TB", @"PB", @"EB", @"YB"};

@implementation AppController

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenu:) name:BCCleanFinished object:nil];
	
	// Initialize the status bar item.
	NSStatusBar * systemStatusBar = [NSStatusBar systemStatusBar];
	statusItem = [[systemStatusBar statusItemWithLength:NSVariableStatusItemLength] retain];
	[statusItem setImage:[NSImage imageNamed:@"Debugger 32.tif"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:[self statusItemMenu]];
	
	//fires once every 5 minutes
	cleaner = [[Cleaner alloc] init];
	cleanTimer = [[NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(clean:) userInfo:nil repeats:YES] retain];
}

- (void) updateMenu:(NSNotification *)note {
	[statusItem setMenu:[self statusItemMenu]];
}

- (void) clean:(NSTimer *)aTimer {
	[cleaner clean];
}

- (NSMenu *) statusItemMenu {
	NSMenu * menu = [[NSMenu alloc] init];
	[menu addItemWithTitle:@"About BuildCleaner..." action:@selector(showAbout:) keyEquivalent:@""];
	[menu addItem:[NSMenuItem separatorItem]];
	
	float totalSaved = [[NSUserDefaults standardUserDefaults] floatForKey:@"totalSaved"];
	int unit = 0;
	while (totalSaved > 1024) { 
		totalSaved = totalSaved / 1024;
		unit++;
		if (unit == 7) { break; }
	}
	NSString * title = [NSString stringWithFormat:@"Cleaned %.2f %@", totalSaved, units[unit]];
	[menu addItemWithTitle:title action:nil keyEquivalent:@""];
	
	[menu addItem:[NSMenuItem separatorItem]];
	[menu addItemWithTitle:@"Clean now" action:@selector(clean:) keyEquivalent:@""];
	[menu addItemWithTitle:@"Settings..." action:@selector(showSettings:) keyEquivalent:@""];
	[menu addItem:[NSMenuItem separatorItem]];
	NSMenuItem * quit = [[NSMenuItem alloc] init];
	[quit setTitle:@"Quit"];
	[quit setTarget:NSApp];
	[quit setAction:@selector(terminate:)];
	[quit setKeyEquivalent:@"q"];
	[menu addItem:quit];
	[quit release];
	return [menu autorelease];
}

- (void) showSettings:(id)sender {
	if (settings == nil) { settings = [[SettingsController alloc] init]; }
	[NSApp activateIgnoringOtherApps:YES];
	[settings showWindow:self];
}

- (void) showAbout:(id)sender {
	[NSApp activateIgnoringOtherApps:YES];
	[NSApp orderFrontStandardAboutPanel:sender];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[[NSUserDefaults standardUserDefaults] synchronize];
	
	if (settings) { [settings release]; }
	[statusItem release];
	[cleaner release];
	[cleanTimer invalidate];
	[cleanTimer release];	
}

@end
