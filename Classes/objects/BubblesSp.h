//
//  BubblesSp.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Bubbles that appear in water after enemy is drown
#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BubblesSp : CCNode
{
	int status; // 0 - not active, 1 - active/flowing 

	//bubbles animation
	CCSprite *gInitSprite; //initial sprite used for animation
	CCSpriteSheet *gSpritesheet; //animation spritesheet 
	NSMutableString *animFileName; //file name for animation
	CCAnimation *gAnimation; //spritesheet animation
}


-(void) startAnimFlow: (CGPoint) startPos;
-(void) stopAnimFlow;
-(BOOL) isBubblesFlowing;
-(void) reset;

@end
