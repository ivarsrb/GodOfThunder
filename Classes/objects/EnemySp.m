//
//  EnemySp.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EnemySp.h"


@implementation EnemySp

//initialization with enemy type
- (id) initWithType: (int) eType
{
	self = [super init];
	if (self != nil) 
	{
		enemyType = eType;
		
		//initialize all instance variables
		switch (enemyType) 
		{
			case INFANTRY:
				startSpeed = 25; //px in second
				dimensions.height = 28;
				dimensions.width = 13; 
				drownHeight = 25;
				hitExtra = 5;
				walkAnimFileName = [[NSMutableString stringWithString: @"enemy_walk"] retain]; //without file extention
				crawlAnimFileName = [[NSMutableString stringWithString: @"enemy_crawl"] retain] ; //without file extention
				break;
			case CAVALRY:
				startSpeed = 35; //px in second
				dimensions.height = 32; 
				dimensions.width = 28;
				drownHeight = 16;
				hitExtra = 4;
				walkAnimFileName = [[NSMutableString stringWithString: @"horse_walk"] retain]; //without file extention
				crawlAnimFileName = [[NSMutableString stringWithString: @"horse_crawl"] retain]; //without file extention
				break;
		}
		
		
		
		//create walk spritesheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",walkAnimFileName]];
		walkInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",walkAnimFileName]];
		walkInitSprite.anchorPoint = ccp(0.5,0); //affects touch bounding box
		walkSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",walkAnimFileName]];
		//walkSpritesheet = [CCSpriteSheet spriteSheetWithTexture: [[CCTextureCache sharedTextureCache] addImage: [NSMutableString stringWithFormat:@"%@.png",walkAnimFileName] ]];
		
		walkSpritesheet.visible = NO;
		[self setSpriteAnimWalk: walkAnimFileName];
		
		//create crawl spritesheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",crawlAnimFileName]];
		crawlInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",crawlAnimFileName]];
		crawlInitSprite.anchorPoint = ccp(0.5,0);
		crawlSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",crawlAnimFileName]];
		crawlSpritesheet.visible = NO;
		[self setSpriteAnimCrawl: crawlAnimFileName];
		
		//walk
		[walkSpritesheet addChild:walkInitSprite];
		[self addChild:walkSpritesheet];

		//crawl
		[crawlSpritesheet addChild:crawlInitSprite];
		[self addChild:crawlSpritesheet];
		
		
		//set function for updating
		[self schedule:@selector(update:)];
		
		[self reset];
	}
	return self;
}

//--------------- Set up functions

-(void) reset
{
	objectFreeToReuse = NO;
	
	status = 0; //set alive
	walkStatus = 0; //free of movement
	
	oreintationAngle = 0; //flat
	
	speed = startSpeed;
	
	stoppedByTree = NO;
	
	[self setPositionByX: 0];
	
	
}

//set up sprite animations for later reuse
-(void) setSpriteAnimWalk: (NSMutableString*) fileName
{
	int frameCount = 4;
	//create frames
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 1; i < frameCount + 1; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",fileName,i]];
		[animFrames addObject:frame];
	}
	//set animation
	walkAnimation = [[CCAnimation animationWithName:@"enemy_movement" delay:0.07f frames:animFrames] retain];
}

-(void) setSpriteAnimCrawl: (NSMutableString*) fileName
{
	int frameCount = 4;
	//create frames
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 1; i < frameCount + 1; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",fileName,i]];
		[animFrames addObject:frame];
	}
	
	//set animation
	crawlAnimation = [[CCAnimation animationWithName:@"enemy_movement" delay:0.15f frames:animFrames] retain];
}

//---------------- Update functions

//get y and set it by x
-(void) setPositionByX: (float) x
{
	self.position = ccp(x, [[LevelDataCl sharedSingleton] getHeightByX:x]);

}

//update enemy data and states
- (void)update:(ccTime)dt
{
	if(![[LevelDataCl sharedSingleton] levelInitialized])
		return;
	
	float currentAngle;
	
	//WIND check
	if([self isAlive])
	{
		//wind blows
		if ([[WindCl sharedSingleton] blowing] == YES) 
		{
			if ([self isMoving]  && [self isFreeWalk]) 
			{
				[self stopAnimWalk];
				[self recieveWind: [[WindCl sharedSingleton] windSpeed]];
				[self startAnimCrawl];
			}	
		}
		
		//stop wind
		if ([[WindCl sharedSingleton] blowing] == NO) 
		{
			if ([self isMoving]  && [self isWindCrawl]) 
			{
				[self stopAnimCrawl];
				[self freeMovement];
				[self startAnimWalk];
			}	
		}
	}
	
	//--------------
	
	if([self isMoving]) //update to next step
	{
		//OPTI - put this in one operation
		float x = self.position.x;
		x = x + speed * dt;
		[self setPositionByX:x];
		
		//rotate enemy against terrain
		if(enemyType == CAVALRY && x > 0)
		{
			currentAngle = [[LevelDataCl sharedSingleton]  getTerrAngleByX: x];
			if(oreintationAngle != currentAngle)
			{
				//NSLog(@"%f", [[LevelDataCl sharedSingleton]  getTerrAngleByX: x]);
				//rotate only by difference of previous angle and current
				[self runAction: [CCRotateBy actionWithDuration:0.15 angle: currentAngle-oreintationAngle]];
				oreintationAngle = currentAngle;
			}
		}
	}
}

//---------------- Game state check and setting


//if enemy is alive and moving
-(BOOL) isMoving
{
	return (status == 1);
}

//enemy has not started on screen
-(BOOL)	hasNotStarted
{
	return (status == 0);
}

//if enemy is not dead
-(BOOL) isAlive
{
	return (status != 3);
}

//is started, bet has not been destroyed yet
-(BOOL) isInGame
{
	return (status == 1 || status == 2);
}

//if is enemy stopped
-(BOOL) isStopped
{
	return (status == 2);
}

//is walking withou obstacles
-(BOOL) isFreeWalk
{
	return (walkStatus == 0);
}

//walking in wind obstacle
-(BOOL) isWindCrawl
{
	return (walkStatus == 1);	
}

//set wind for blowing, decrease movement speed by given decreaser - decreaser * speed
-(void) recieveWind: (float) decreaser
{
	walkStatus = 1; //set for wind obstacle
	speed = startSpeed * decreaser;
}

//set start speed and freedom to walk (wind related)
-(void) freeMovement
{
	walkStatus = 0;
	speed = startSpeed;
}

//enemy is set destroyed
//destructionType - animation with: 1 - drowning, 2 - lightning
-(void) setDestroyed: (int) destructionType
{
	id actionSequence;
	
	status = 3;
	
	//all actions stopped and enemy is hidden
	if([self isFreeWalk])
	{	
		[walkInitSprite stopAllActions];
	}
	else if([self isWindCrawl])
	{
		[crawlInitSprite stopAllActions];
	}
	[self stopAllActions];
	
	//play sound
	if(destructionType == 2) //when drowning not sound
	switch (enemyType)
	{
		case INFANTRY:
			[[SoundCl sharedSingleton] playSound: SCREAM_EFF loop:NO];
			break;
		case CAVALRY:
			[[SoundCl sharedSingleton] playSound: SCREAM_HORSE_EFF loop:NO];
			break;
	}else if (destructionType == 3) 
	{
		[[SoundCl sharedSingleton] playSound: BLOW_UP_EFF loop:NO];
	}
	
	id actionCallFunc;
	id resourceFreeFunc = [CCCallFunc actionWithTarget:self selector:@selector(onResourceFree)];
	if(destructionType == 3) //tornado blows up
	{
		actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(onDestroyEnd)];
		//move up
		actionSequence = [CCSequence actions: [CCMoveBy actionWithDuration:0.2 position:ccp(0, 30)], 
						  actionCallFunc,
						  [CCRotateTo actionWithDuration:0.0 angle: 0],
						  resourceFreeFunc, nil];
		[self runAction:actionSequence];
	}
	else //drown and lightning
	{
		walkSpritesheet.visible = NO;	
		crawlSpritesheet.visible = NO;
		actionSequence = [CCSequence actions: 
						 [CCRotateTo actionWithDuration:0.0 angle: 0] , resourceFreeFunc, nil];
		[self runAction: actionSequence];
	}
}

//tornado hide visibility
-(void) onDestroyEnd
{
	walkSpritesheet.visible = NO;	
	crawlSpritesheet.visible = NO;
}

//make available for reuse
-(void) onResourceFree
{
	objectFreeToReuse = YES;
}

//---------------- Animation start / stop



//start sprite animation process for walking
-(void) startAnimWalk
{	
	walkSpritesheet.visible = YES;
	CCAction *walkAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:walkAnimation restoreOriginalFrame:NO] ];
	[walkInitSprite runAction: walkAnimAction];
}

//start sprite animation process for crawling
-(void) startAnimCrawl
{	
	crawlSpritesheet.visible =  YES;
	CCAction *crawlAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:crawlAnimation restoreOriginalFrame:NO] ];
	[crawlInitSprite runAction: crawlAnimAction];
}


//stop animation and hide it
-(void) stopAnimWalk
{
	[walkInitSprite stopAllActions];
	walkSpritesheet.visible = NO; //hide enemy
}

//stop animation and hide it
-(void) stopAnimCrawl
{
	[crawlInitSprite stopAllActions];
	crawlSpritesheet.visible = NO; //hide enemy
}


//trigger enemy start
-(void) startMovement
{
	status = 1;
	
	if([self isFreeWalk])
		[self startAnimWalk];
	else if([self isWindCrawl])
		[self startAnimCrawl];
}


//stop enemy movement
-(void) stopMovement
{
	if([self isMoving])
	{
		status = 2;
		//set to wqlk initial sprite, TODO make a newer version for setDisplayFrame
		//always finish on first frame
		CCSpriteFrame *firstSprite;

		if([self isWindCrawl]) //switch to walk animation, if crawling
		{
			[self stopAnimCrawl];
			[self startAnimWalk];
		}
		
		//stop walk animation and set initial sprite
		[walkInitSprite stopAllActions];
		firstSprite = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_1.png",walkAnimFileName]];
		[walkInitSprite setDisplayFrame: firstSprite];
	}
}
	
-(void) dealloc
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[walkAnimation release];
	[crawlAnimation release];
	[walkAnimFileName release];
	[crawlAnimFileName release];
	
	[super dealloc];
}


@synthesize dimensions;
@synthesize enemyType;
@synthesize drownHeight;
@synthesize hitExtra;
@synthesize objectFreeToReuse;
@synthesize stoppedByTree;


@end

