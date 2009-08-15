//
//  NSFileManager+FileSize.m
//  BuildCleaner
//
//  Created by Dave DeLong on 8/13/09.
//  Copyright 2009 Home. All rights reserved.
//

#import "NSFileManager+FileSize.h"
#import "NSString+FSRef.h"


@implementation NSFileManager (FileSize)

- (NSUInteger) _sizeOfItemForFSRef:(FSRef *)theFileRef {
    FSIterator thisDirEnum = NULL;
    NSUInteger totalSize = 0;
	
    // Iterate the directory contents, recursing as necessary
    if (FSOpenIterator(theFileRef, kFSIterateFlat, &thisDirEnum) == noErr) {
        const ItemCount kMaxEntriesPerFetch = 40;
        ItemCount actualFetched;
        FSRef    fetchedRefs[kMaxEntriesPerFetch];
        FSCatalogInfo fetchedInfos[kMaxEntriesPerFetch];
		
		OSErr fsErr = FSGetCatalogInfoBulk(thisDirEnum,  
										   kMaxEntriesPerFetch, 
										   &actualFetched,
										   NULL, 
										   kFSCatInfoDataSizes | kFSCatInfoNodeFlags | kFSCatInfoRsrcSizes,
										   fetchedInfos,
										   fetchedRefs, 
										   NULL, 
										   NULL);
        while ((fsErr == noErr) || (fsErr == errFSNoMoreItems)) {
            ItemCount thisIndex;
            for (thisIndex = 0; thisIndex < actualFetched; thisIndex++) {
                // Recurse if it's a folder
                if (fetchedInfos[thisIndex].nodeFlags & kFSNodeIsDirectoryMask) {
                    totalSize += [self _sizeOfItemForFSRef:&fetchedRefs[thisIndex]];
                } else {
                    // add the size for this item
                    totalSize += fetchedInfos[thisIndex].dataLogicalSize;
                }
            }
			
            if (fsErr == errFSNoMoreItems) {
                break;
            } else {
                // get more items
                fsErr = FSGetCatalogInfoBulk(thisDirEnum,  
											 kMaxEntriesPerFetch, 
											 &actualFetched,
											 NULL, 
											 kFSCatInfoDataSizes | kFSCatInfoNodeFlags | kFSCatInfoRsrcSizes, 
											 fetchedInfos,
											 fetchedRefs, 
											 NULL, 
											 NULL);
            }
        }
        FSCloseIterator(thisDirEnum);
    }
    return totalSize;
}

- (NSUInteger) sizeOfItemAtPath:(NSString *)filePath {
	FSRef theFileRef = [filePath fsref];
	return [self _sizeOfItemForFSRef:&theFileRef];
}

@end
