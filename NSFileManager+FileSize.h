//
//  NSFileManager+FileSize.h
//  BuildCleaner
//
//  Created by Dave DeLong on 8/13/09.
//  Copyright 2009 Home. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSFileManager (FileSize)

- (NSUInteger) sizeOfItemAtPath:(NSString *)filePath;

@end
