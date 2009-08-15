//
//  Cleaner.h
//  BuildCleaner
//
//  Created by Dave DeLong on 2/26/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Cleaner : NSObject {
	NSMetadataQuery * query;
	NSUInteger totalSavedSpace;
}

- (void) clean;

- (NSDate *) _lastModificationDateForDirectory:(NSString *)dir;

@end
