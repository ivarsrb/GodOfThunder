//
//  TornadoSp.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Tornado that is rendered as sprite animation

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelDataCl.h"
#import "TornadoCl.h"

@interface TornadoSp : CCNode 
{	
	int status; //0 - not animating/moving , 1 - is animating moving 
	float spwidth; //width of tornado
	
	//tornado animation
	CCSprite *tInitSprite; //initial sprite used for animation
	CCSpriteSheet *tSpritesheet; //animation spritesheet 
	NSMutableString *animFileName; //file name for animation
	CCAnimation *tAnimation; //spritesheet animation
}

@property (readonly) float spwidth;

-(void) startAnimTwist;
-(void) stopAnimTwist;

-(void) setPositionByX: (float) x;

-(BOOL) isSilent;
-(BOOL) isAnimated;


@end
