//
//  GhostSp.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GhostSp.h"


@implementation GhostSp

-(id) init
{
	self = [super init];
	if (self != nil) 
	{
		//TODO set normal coords
		dimensions.width = 20;
		dimensions.height = 20;
		
		hitExtra = 4;
		
		animFileName = [[NSMutableString stringWithString: @"ghost_fly"] retain]; //without file extention
		
		//create spritesheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",animFileName]];
		gInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
		gInitSprite.anchorPoint = ccp(0.5,0); //affects bounding box
		gSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",animFileName]];
		
		gSpritesheet.visible = NO;
		
		//set up animation
		int frameCount = 4;
		//create frames
		NSMutableArray *animFrames = [NSMutableArray array];
		for(int i = 1; i < frameCount + 1; i++) {
			
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",animFileName,i]];
			[animFrames addObject:frame];
		}
		//set animation
		gAnimation = [[CCAnimation animationWithName:@"ghost" delay:0.07f frames:animFrames] retain];
		
		[gSpritesheet addChild:gInitSprite];
		[self addChild:gSpritesheet];
		
		[self reset];
	}
	return self;
}

-(void) reset
{
	status = 0;
}


//start sprite animation process for flying
//startPos - position where enemy got destroyed
-(void) startAnimFly: (CGPoint) startPos
{
	self.position = startPos;
	
	gSpritesheet.visible = YES;
	
	status = 1;
	
	//actions are secuence of animation and flying vertically
	//TODO - set flying height and time
	CCAction *gAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:gAnimation restoreOriginalFrame:NO] ];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(stopAnimFly)];
	id actionSequence = [CCSequence actions: [CCMoveBy actionWithDuration:3 position:ccp(0, 100)],actionCallFunc,nil];
	
	[gInitSprite runAction: gAnimAction];  //animation
	[self runAction: actionSequence]; //movement
}

//stop animation and hide it
-(void) stopAnimFly
{
	[self stopAllActions];
	[gInitSprite stopAllActions];
	
	gSpritesheet.visible = NO; //hide tornado
	status = 0;
}

//weather ghost is active
-(BOOL) isGhostFlying
{
	return (status == 1);
}



-(void)dealloc 
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[animFileName release];
	[gAnimation release];
    [super dealloc];
}

@synthesize dimensions;
@synthesize hitExtra;

@end
