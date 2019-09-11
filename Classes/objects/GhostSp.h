//
//  GhostSp.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Sprite and actions that appeer after enemy is destroyed
// Ghosts do NOT appear after TORNADO hit
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GhostSp : CCNode
{
	int status; // 0 - not active, 1 - active/flying 
	CGSize dimensions; //dimensions if enemy itself, but not of sprite file
	float hitExtra; //stores extra pixels to all 4 sides, that user can hit ghost
	
	//ghost animation
	CCSprite *gInitSprite; //initial sprite used for animation
	CCSpriteSheet *gSpritesheet; //animation spritesheet 
	NSMutableString *animFileName; //file name for animation
	CCAnimation *gAnimation; //spritesheet animation
}

@property (readonly) CGSize dimensions;
@property (readonly) float hitExtra;

-(void) startAnimFly: (CGPoint) startPos;
-(void) stopAnimFly;
-(BOOL) isGhostFlying;
-(void) reset;

@end
