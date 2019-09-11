//
//  FileManagementCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/3/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  plist file management helper class

#import <Foundation/Foundation.h>


@interface FileManagementCl : NSObject 
{

}

- (id)readPlist:(NSString *)fileName;
- (NSDictionary *)getDictionary:(NSString *)fileName;
//- (NSArray *)getArray:(NSString *)fileName;
//- (void)writePlist:(id)plist fileName:(NSString *)fileName;
@end
