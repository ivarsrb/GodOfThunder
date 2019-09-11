//
//  LightningEffect.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightningEffect.h"


@implementation LightningEffect

- (id) init
{
    self = [super init];
    if (self != nil) 
	{
		color = ccWHITE;
		
		// original values
		//displacement = 120;
		//minDisplacement = 4;
		
		displacement = 100;
		minDisplacement = 20;
		
		self.visible = NO; //dont drtaw it first time
		//strikePoint = ccp(0,0-3);// becouse sharp point is start off coordinate system here
		
		lightningTex = [[CCTextureCache sharedTextureCache] addImage: @"lightning.png"];
	}
    return self;
}

-(void) draw
{
	glColor4ub(color.r, color.g, color.b, opacity);
	//glLineWidth(3.0f);
	//glEnable(GL_LINE_SMOOTH); //iphone does not like it wikt line width
	
	if (opacity != 255)
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	
	[self drawLightning: ccp(0,0): strikeOrigin: displacement: minDisplacement: seed];
	//[self drawArrowHead: strikePoint];
	
	if (opacity != 255)
		glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

//call when want to draw lightning
- (void) strike
{
	seed = arc4random();

	self.opacity = 255;
	
	//strikePoint = self.position;
	
	[self runAction:[CCSequence actions: 
					 [CCShow action],
					 [CCFadeOut actionWithDuration:1],
					 nil]];
}

//actual lightningdraw method
-(void) drawLightning:(CGPoint) pt1: (CGPoint) pt2: (int) displace:(int) minDisplace: (unsigned long) randSeed
{
	CGPoint mid = ccpMult(ccpAdd(pt1,pt2), 0.5f);
	
	if (displace < minDisplace) 
	{
	    [self drawTexturedLine: pt1: pt2: 7];
		//ccDrawLine(pt1, pt2);
	}
	else 
	{
		int r = [self getNextRandom:&randSeed];
		mid.x += (((r % 101)/100.0)-.5)*displace;
		r = [self getNextRandom:&randSeed];
		mid.y += (((r % 101)/100.0)-.5)*displace;
		
		[self drawLightning: pt1:mid:displace/2:minDisplace:randSeed];
		[self drawLightning: pt2:mid:displace/2:minDisplace:randSeed];
	}
	
	//return mid;
} 

-(int) getNextRandom:(unsigned long *)gseed
{
	//taken off a linux site (linux.die.net)
	(*gseed) = (*gseed) * 1103515245 + 12345;
	return ((unsigned)((*gseed)/65536)%32768);
}


//textured line out of 2 triangles
- (void) drawTexturedLine:(CGPoint) pt1: (CGPoint) pt2: (float) halfWidth 
{
	//NSLog(@"1: %f - %f  2: %f - %f",pt1.x,pt1.y,pt2.x,pt2.y );
	
	CGPoint lineVerts[4];
	
	texCoordStuct texCoord[4];
	
	//CW, start with upper part
	lineVerts[0] = ccp(pt1.x-halfWidth, pt1.y);
	lineVerts[1] = ccp(pt1.x+halfWidth, pt1.y);
	lineVerts[2] = ccp(pt2.x-halfWidth, pt2.y);
	lineVerts[3] = ccp(pt2.x+halfWidth, pt2.y);
	
	//texture cords
	texCoord[0].u = 0;
	texCoord[0].v = 1;
	texCoord[1].u = 1;
	texCoord[1].v = 1;
	texCoord[2].u = 0;
	texCoord[2].v = 0;
	texCoord[3].u = 1;
	texCoord[3].v = 0;
	
	glBindTexture(GL_TEXTURE_2D, [lightningTex name]);
	
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY

	//glDisable(GL_TEXTURE_2D);
	//glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, lineVerts);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoord);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	//glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	//glEnable(GL_TEXTURE_2D);
}


//lightning bolt arrow
/*
- (void) drawArrowHead:(CGPoint) pt
{
	CGPoint arrowVerts[3];
	
	//NSLog(@"---------- %f ---------------", pt.x);
	
	arrowVerts[0] = ccp(pt.x, pt.y);
	arrowVerts[1] = ccp(pt.x-10, pt.y+20);
	arrowVerts[2] = ccp(pt.x+10, pt.y+20);
	
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, arrowVerts);
	
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 3);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
}
*/
 
@synthesize strikeOrigin;
@synthesize color;
@synthesize opacity;

@end

