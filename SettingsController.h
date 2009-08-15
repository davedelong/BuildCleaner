//
//  SettingsController.h
//  BuildCleaner
//
//  Created by Dave DeLong on 2/27/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SettingsController : NSWindowController {
	NSMutableArray * ignoreFiles;
	
	NSTableView * projectList;
	NSButton * removeButton;
	NSPopUpButton * cutoff;
}

@property (nonatomic, assign) IBOutlet NSTableView * projectList;
@property (nonatomic, assign) IBOutlet NSButton * removeButton;
@property (nonatomic, assign) IBOutlet NSPopUpButton * cutoff;

- (IBAction) addProjectFile:(id)sender;
- (IBAction) removeSelectedProjectFile:(id)sender;
- (IBAction) changedCutoff:(id)sender;

@end
