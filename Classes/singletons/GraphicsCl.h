//
//  GraphicsCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Singleton
// Resource loading, graphics helper class

#import <Foundation/Foundation.h>
#import "cocos2d.h"

//texture structure
struct texCoordStuct {
	CGFloat u;
	CGFloat v;
};
typedef struct texCoordStuct texCoordStuct;


@interface GraphicsCl : NSObject 
{

}

+(GraphicsCl*)sharedSingleton;

- (void) loadGraphics;

@end
