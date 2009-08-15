//
//  SettingsController.m
//  BuildCleaner
//
//  Created by Dave DeLong on 2/27/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "SettingsController.h"

@implementation SettingsController

@synthesize projectList, removeButton, cutoff;

- (id)init {
	if (self = [super initWithWindowNibName:@"SettingsWindow"]) {
		ignoreFiles = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"ignoreFiles"]];
	}
	return self;
}

- (void)windowDidLoad {
	[projectList reloadData];
	[self tableViewSelectionDidChange:nil];
	[cutoff selectItemWithTag:[[NSUserDefaults standardUserDefaults] integerForKey:@"cutoffInterval"]];
}

- (IBAction) changedCutoff:(id)sender {
	[[NSUserDefaults standardUserDefaults] setInteger:[cutoff selectedTag] forKey:@"cutoffInterval"];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [ignoreFiles count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if ([[aTableColumn identifier] isEqualToString:@"image"]) {
		return [NSImage imageNamed:@"docicon.icns"];
	}
	return [ignoreFiles objectAtIndex:rowIndex];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
	NSInteger selectedRow = [projectList selectedRow];
	[removeButton setEnabled:(selectedRow >= 0)];
}

- (IBAction) addProjectFile:(id)sender {
	NSOpenPanel * panel = [NSOpenPanel openPanel];
	[panel beginSheetForDirectory:nil 
							 file:nil 
							types:[NSArray arrayWithObjects:@"xcodeproj", @"xcode", nil] 
				   modalForWindow:[self window] 
					modalDelegate:self 
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:) 
					  contextInfo:nil];
}

- (void)openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo {
	if (returnCode == NSOKButton) {
		[ignoreFiles addObjectsFromArray:[panel filenames]];
		[[NSUserDefaults standardUserDefaults] setObject:ignoreFiles forKey:@"ignoreFiles"];
		[projectList reloadData];
	}
}

- (IBAction) removeSelectedProjectFile:(id)sender {
	NSInteger selectedRow = [projectList selectedRow];
	[ignoreFiles removeObjectAtIndex:selectedRow];
	[[NSUserDefaults standardUserDefaults] setObject:ignoreFiles forKey:@"ignoreFiles"];
	[projectList reloadData];
}

- (void) dealloc {
	[ignoreFiles release];
	[super dealloc];
}

@end
