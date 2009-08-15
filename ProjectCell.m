//
//  TSBadgeCell.m
//  Tahsis
//
//  Created by Matteo Bertozzi on 11/29/08.
//  Copyright 2008 Matteo Bertozzi. All rights reserved.
//

#import "ProjectCell.h"



@implementation ProjectCell

#define BUFFER_LEFT				4
#define ICON_SIZE				14
#define ICON_HEIGHT_OFFSET		1


- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView*)controlView {

	// Draw Icon
	NSImage * image = [NSImage imageNamed:@"docicon.icns"];
	[image setFlipped:YES];
	NSRect iconRect = cellFrame;
	iconRect.origin.y += ICON_HEIGHT_OFFSET;
	iconRect.size.height = ICON_SIZE;
	iconRect.size.width = ICON_SIZE;
	[image drawInRect:iconRect fromRect:NSZeroRect
			operation:NSCompositeSourceOver fraction:1.0];

	// Draw Rect
	NSRect labelRect = cellFrame;
	labelRect.origin.x += ICON_SIZE + BUFFER_LEFT;
	labelRect.size.width -= (ICON_SIZE + BUFFER_LEFT);
	[super drawInteriorWithFrame:labelRect inView:controlView];
}

@end
