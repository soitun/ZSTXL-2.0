//
//  NSDictionary+Helper.m
//  ZSTXL
//
//  Created by LiuYue on 13-6-7.
//  Copyright (c) 2013年 com.zxcxco. All rights reserved.
//

#import "NSDictionary+Helper.h"

@implementation NSDictionary (Helper)

+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data
{
	// uses toll-free bridging for data into CFDataRef and CFPropertyList into NSDictionary
	CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (CFDataRef)data,
															   kCFPropertyListImmutable,
															   NULL);
	// we check if it is the correct type and only return it if it is
	if ([(id)plist isKindOfClass:[NSDictionary class]])
	{
		return [(NSDictionary *)plist autorelease];
	}
	else
	{
		// clean up ref
        if (plist) {
            CFRelease(plist);
        }
		return nil;
	}
}

@end
