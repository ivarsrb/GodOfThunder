//
//  TornadoSp.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TornadoSp.h"


@implementation TornadoSp

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		status = 0;
		
		animFileName = [[NSMutableString stringWithString: @"tornado_twist"] retain]; //without file extention
		
		//create twist spritesheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",animFileName]];
		tInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
		tInitSprite.anchorPoint = ccp(0.1,0.05); //affects bounding box
		tSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",animFileName]];
		tSpritesheet.visible = NO;
		
		spwidth = 40;
		//set up animation
		int frameCount = 6;
		//create frames
		NSMutableArray *animFrames = [NSMutableArray array];
		for(int i = 1; i < frameCount + 1; i++) {
			
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",animFileName,i]];
			[animFrames addObject:frame];
		}
		//set animation
		tAnimation = [[CCAnimation animationWithName:@"tornado_movement" delay:0.09f frames:animFrames] retain];
		
		
		[tSpritesheet addChild:tInitSprite];
		[self addChild:tSpritesheet];
		
		//set function for updating
		[self schedule:@selector(update:)];
		
		//set up start position
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		[self setPositionByX:winSize.width];
	}
	return self;
}


//update tornado movement
- (void)update:(ccTime)dt
{
	if(![[LevelDataCl sharedSingleton] levelInitialized])
		return;
	
	if([self isAnimated]) //update to next step
	{
		//OPTI - put this in one operation
		float x = self.position.x;
		x = x - [[TornadoCl sharedSingleton] speed] * dt; //moves backward
		[self setPositionByX:x];
	}
}

//get y and set it by x
-(void) setPositionByX: (float) x
{
	self.position = ccp(x, [[LevelDataCl sharedSingleton] getHeightByX:x]);
}


//start sprite animation process for twisting
-(void) startAnimTwist
{	
	//set start position of tornado
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[self setPositionByX:winSize.width];
	
	tSpritesheet.visible = YES;
	CCAction *tAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:tAnimation restoreOriginalFrame:NO] ];
	[tInitSprite runAction: tAnimAction];
	
	status = 1;
}

//stop animation and hide it
-(void) stopAnimTwist
{
	//set back start position of tornado
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	[self setPositionByX:winSize.width];
	
	[tInitSprite stopAllActions];
	tSpritesheet.visible = NO; //hide tornado
	status = 0;
}

-(BOOL) isSilent
{
	return (status == 0);
}

-(BOOL) isAnimated
{
	return (status == 1);
}


- (void)dealloc 
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[animFileName release];
	[tAnimation release];
    [super dealloc];
}


@synthesize spwidth;

@end
