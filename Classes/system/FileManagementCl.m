//
//  FileManagementCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "FileManagementCl.h"


@implementation FileManagementCl

- (id)readPlist:(NSString *)fileName 
{  
	NSData *plistData;  
	NSString *error;  
	NSPropertyListFormat format;  
	id plist;  

	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];  
	plistData = [NSData dataWithContentsOfFile:localizedPath];   

	plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
	if (!plist) 
	{  
		   NSLog(@"Error reading file '%s', error - '%s'", [localizedPath UTF8String], [error UTF8String]);  
		   [error release];  
	}  

	return plist;  
}  
  

- (NSDictionary *)getDictionary:(NSString *)fileName 
{  
   return (NSDictionary *)[self readPlist:fileName];  
} 

/*
- (NSArray *)getArray:(NSString *)fileName 
{  
	return (NSArray *)[self readPlist:fileName];  
}   

- (void)writePlist:(id)plist fileName:(NSString *)fileName 
{  
	NSData *xmlData;  
	NSString *error;   

	NSString *localizedPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];  
	xmlData = [NSPropertyListSerialization dataFromPropertyList:plist format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];  
	if (xmlData) 
	{  
		[xmlData writeToFile:localizedPath atomically:YES];  
	} else 
	{  
		NSLog(@"Error writing plist to file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);  
		[error release];  
	}  
}  
*/

@end
