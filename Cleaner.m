//
//  Cleaner.m
//  BuildCleaner
//
//  Created by Dave DeLong on 2/26/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "Cleaner.h"
#import "NSFileManager+FileSize.h"


@implementation Cleaner

- (id) init {
	if (self = [super init]) {
		query = [[NSMetadataQuery alloc] init];
		[query setPredicate:[NSPredicate predicateWithFormat:@"kMDItemContentType = 'com.apple.xcode.project' && kMDItemDisplayName != '___PROJECTNAME___.xcodeproj'"]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryNotification:) name:nil object:query];
	}
	return self;
}

- (void) processXcodeprojFile:(NSString *)xcodeproj {
	NSArray * ignoreFiles = [[NSUserDefaults standardUserDefaults] objectForKey:@"ignoreFiles"];
	if ([ignoreFiles containsObject:xcodeproj]) { 
		NSLog(@"Ignoring %@", xcodeproj);
		return;
	}
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	NSString * projectDir = [xcodeproj stringByDeletingLastPathComponent];
	NSString * buildDir = [projectDir stringByAppendingPathComponent:@"build"];
	
	BOOL isDir = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:buildDir isDirectory:&isDir] && isDir == YES) {
		NSDate * now = [NSDate date];
		NSTimeInterval interval = [[NSUserDefaults standardUserDefaults] integerForKey:@"cutoffInterval"];
		if (interval == 0) { interval = 3600; }
		
		NSDate * modDate = [self _lastModificationDateForDirectory:buildDir];
		modDate = [modDate addTimeInterval:interval];
		NSDate * laterDate = [modDate laterDate:now];
		if ([laterDate isEqualToDate:now]) {
			NSUInteger dirSize = [[NSFileManager defaultManager] sizeOfItemAtPath:buildDir];
			//modDate + 1 hour is less than now (ie, it's more than an hour old)
			NSError * error = nil;
			if ([[NSFileManager defaultManager] removeItemAtPath:buildDir error:&error]) {
				//yay, we deleted the build folder!
				totalSavedSpace += dirSize;
				NSLog(@"Deleted: %@", buildDir);
			} else {
				NSLog(@"Failed to delete build directory at \"%@\" with error %@", buildDir, error);
			}
		}
	}
	[pool release];
}

- (void) queryNotification:(NSNotification *)note {
	if ([[note name] isEqualToString:NSMetadataQueryDidFinishGatheringNotification]) {
		NSArray * results = [query results];
		[query stopQuery];
		totalSavedSpace = [[NSUserDefaults standardUserDefaults] integerForKey:@"totalSaved"];
		for (NSMetadataItem * i in results) {
			[self processXcodeprojFile:[i valueForAttribute:(NSString *)kMDItemPath]];
		}
		[[NSUserDefaults standardUserDefaults] setInteger:totalSavedSpace forKey:@"totalSaved"];
		[[NSNotificationCenter defaultCenter] postNotificationName:BCCleanFinished object:self];
    }
}

- (void) clean {
	[query startQuery];
}

- (NSDate *) _lastModificationDateForDirectory:(NSString *)dir {
	NSDictionary * attrs = [[NSFileManager defaultManager] fileAttributesAtPath:dir traverseLink:NO];
	NSDate * d = [attrs objectForKey:NSFileModificationDate];
	BOOL isDir = NO;
	if ([[NSFileManager defaultManager] fileExistsAtPath:dir isDirectory:&isDir] == YES && isDir == NO) {
		return d;
	}
	NSDirectoryEnumerator * dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:dir];
	for(NSString * child in dirEnum) {
		NSDate * childDate = [[dirEnum fileAttributes] objectForKey:NSFileModificationDate];
		d = [d laterDate:childDate];
	}
	return d;
}

- (void) dealloc {
	[query release];
	[super dealloc];
}

@end
