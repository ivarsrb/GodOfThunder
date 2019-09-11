//
//  LightningEffect.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Draws lightning from one point to another

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GraphicsCl.h"

//OPTI if is to slow, look at example where c functions were used outside class

@interface LightningEffect : CCNode<CCRGBAProtocol> //CCTextureProtocol 
{
	CGPoint strikeOrigin; //point from where the lightning will strike (x = relative to strike position)
	//CGPoint strikePoint; //point to which lightning strikes
	
	
	ccColor3B	color;
	GLubyte		opacity;
	
	int displacement;
	int minDisplacement;
	
	unsigned long seed;
	
	CCTexture2D	*lightningTex;	
}

@property CGPoint strikeOrigin;

@property ccColor3B color;
@property GLubyte opacity;


-(void) strike;
-(void) drawLightning:(CGPoint) pt1: (CGPoint) pt2: (int) displace:(int) minDisplace: (unsigned long) randSeed;
-(int)  getNextRandom:(unsigned long *)seed;

- (void) drawTexturedLine:(CGPoint) pt1: (CGPoint) pt2: (float) halfWidth;

//- (void) drawArrowHead:(CGPoint) pt;
@end
