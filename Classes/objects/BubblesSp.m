//
//  BubblesSp.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "BubblesSp.h"


@implementation BubblesSp

-(id) init
{
	self = [super init];
	if (self != nil) 
	{
		animFileName = [[NSMutableString stringWithString: @"bubbles_flow"] retain]; //without file extention
		
		//create spritesheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",animFileName]];
		gInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
		gInitSprite.anchorPoint = ccp(0,0); //affects bounding box
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
		gAnimation = [[CCAnimation animationWithName:@"bubbles" delay:0.1f frames:animFrames] retain];
		
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


//start sprite animation process for flowing
//startPos - position where enemy got destroyed
-(void) startAnimFlow: (CGPoint) startPos
{
	self.position = startPos;
	
	gSpritesheet.visible = YES;
	
	status = 1;
	
	//actions are secuence of animation and flowing vertically
	CCAction *gAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:gAnimation restoreOriginalFrame:NO] ];
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(stopAnimFlow)];
	id actionSequence = [CCSequence actions: [CCMoveBy actionWithDuration:0.8 position:ccp(0, 0)],actionCallFunc,nil];
	
	[gInitSprite runAction: gAnimAction];  //animation
	[self runAction: actionSequence]; //movement
}

//stop animation and hide it
-(void) stopAnimFlow
{
	[self stopAllActions];
	[gInitSprite stopAllActions];
	
	gSpritesheet.visible = NO; //hide tornado
	status = 0;
}

//weather bubbles are flowing
-(BOOL) isBubblesFlowing
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

@end
