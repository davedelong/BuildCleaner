//
//  NSString+FSRef.m
//  BuildCleaner
//
//  Created by Dave DeLong on 8/13/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "NSString+FSRef.h"


@implementation NSString (FSRef)

- (FSRef) fsref {
	FSRef output;
	
	// convert the NSString to a C-string
	const char *filePathAsCString = [self UTF8String];
	
	CFURLRef url = CFURLCreateWithBytes(
							kCFAllocatorDefault,            // CFAllocatorRef
							(const UInt8 *)filePathAsCString,              // the bytes
							strlen(filePathAsCString),      // the length
							kCFStringEncodingUTF8,          // encoding
							NULL);                          // CFURLRef baseURL
	
	CFURLGetFSRef(url, &output);
	CFRelease(url);

	return output;
}

@end
