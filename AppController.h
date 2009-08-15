//
//  AppController.h
//  BuildCleaner
//
//  Created by CS Webmaster on 2/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Cleaner;
@class SettingsController;

@interface AppController : NSObject {
	NSStatusItem * statusItem;
	NSTimer * cleanTimer;
	Cleaner * cleaner;
	SettingsController * settings;
}
- (NSMenu *) statusItemMenu;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification;

@end
