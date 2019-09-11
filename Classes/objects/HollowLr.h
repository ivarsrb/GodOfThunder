//
//  HollowLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Class that defines hollow entity, to collect rain nwater and draws it

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelDataCl.h"
#import "RainCl.h"

@interface HollowLr : CCColorLayer 
{
	int indexLeft; //indexes in heightmap array, that holds left and right side points of hollow
	int indexRight;
	CGPoint positionLeft; //hollow left and right side coordinates
	CGPoint positionRight;
	float baseY; //lowest point of the hollow
	int status;  //0 - empty, 1 - filling, 2 - drying
	float fillFactor; //relative rate in which water is filling
    float relFillFactor; //fill factor that is determined by hollow size
    float decreaseFactor; //factor in which water dries
	float fillLevel; //water height in pixls
	
}
- (id) initWithIndexes: (int) indexL :(int) indexR;

-(void) setEmpty;
-(void) setFilling;
-(void) setDrying;

-(BOOL) isEmpty;
-(BOOL) isFilling;
-(BOOL) isDrying;

-(float) getFillFactor;
-(BOOL) isDrowning: (CGPoint) objectPosition: (float) objectHeight;

-(float) exponentialFactor: (float) fill :(float) hollowDepth;

@end
