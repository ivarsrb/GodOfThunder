//
//  TreeSp.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TreeSp.h"


@implementation TreeSp
- (id) initWithType: (int) tType
{
	self = [super init];
	if (self != nil) 
	{
		treeType = tType;
		
		//initialize all type dependant variables
		switch (treeType) 
		{
			case TREE_1:
				dimensions.height = 64; 
				dimensions.width = 30;
				//treeFileName = [NSMutableString stringWithString: @"tree_1.png"];
				animFileName = [[NSMutableString stringWithString: @"tree_swing_1"] retain]; //without file extention
				
				break;
			case TREE_2:
				dimensions.height = 64; 
				dimensions.width = 30;
				//treeFileName = [NSMutableString stringWithString: @"tree_2.png"];
				animFileName = [[NSMutableString stringWithString: @"tree_swing_2"] retain]; //without file extention
				break;
		}
		
		swinging = NO;
		
		//treeSprite = [CCSprite spriteWithFile: treeFileName]; 
		//treeSprite.anchorPoint = ccp(0.5,0); //affects touch bounding box and drawing
		
		//[self addChild: treeSprite];
		
		//create spritesheet
		[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",animFileName]];
		tInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
		tInitSprite.anchorPoint = ccp(0.5,0.05); //affects bounding box, 
		tSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",animFileName]];
		//tSpritesheet.visible = NO;
		
		//set up animation
		int frameCount = 4;
		//create frames
		NSMutableArray *animFrames = [NSMutableArray array];
		for(int i = 1; i < frameCount + 1; i++) {
			
			CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",animFileName,i]];
			[animFrames addObject:frame];
		}
		//set animation
		tAnimation = [[CCAnimation animationWithName:@"tree_swing" delay:0.08f frames:animFrames] retain];
		
		[tSpritesheet addChild:tInitSprite];
		[self addChild:tSpritesheet];
		
		
		//set function for updating
		[self schedule:@selector(update:)];
		
		//create fire particles for burning
		fireEmitter = [CCParticleFire node]; 
		fireEmitter.startSize = 8;
		fireEmitter.endSize = 8;
		fireEmitter.startSizeVar = 16;
		fireEmitter.endSizeVar = 16;
		fireEmitter.emissionRate = 60;
		fireEmitter.life = 1;
		//TODO position vertical
		fireEmitter.position = ccp(self.position.x, self.position.y+5);
		fireEmitter.posVar = ccp(self.dimensions.width/4,0); //half width
		fireEmitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.png"];
		[fireEmitter stopSystem]; //off by default
		[self addChild: fireEmitter];
		
		[self setAlive];
		
		burnTime = 6;
		totalTime = 0;
		
		//init fire sound
		fireSS = [[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"fire.wav"] retain];
		[fireSS setLooping:YES];
	}
	return self;
}

//update tree data and states
- (void)update:(ccTime)dt
{
	if(![[LevelDataCl sharedSingleton] levelInitialized])
		return;
	
	totalTime += dt;
	
	//swing in wind tree
	if ([[WindCl sharedSingleton] blowing] == YES) 
	{
		[self startAnimSwing];
		fireEmitter.angle = 110; //make fire shift to left in wind
	}
	if ([[WindCl sharedSingleton] blowing] == NO) 
	{
		[self stopAnimSwing];
		fireEmitter.angle = 90;
	}
	
	// if is burning and rain hits, stop fire
	if([self isBurning] && [[RainCl sharedSingleton] isRaining]) //raining
	{
		float rainX = 0;
		float rainWidth = fabs([[RainCl sharedSingleton] rainPos1].x - [[RainCl sharedSingleton] rainPos2].x);
		
		//find minimum of two rain point
		if([[RainCl sharedSingleton] rainPos1].x > [[RainCl sharedSingleton] rainPos2].x)
		{
			rainX = [[RainCl sharedSingleton] rainPos2].x;
		}else {
			rainX = [[RainCl sharedSingleton] rainPos1].x;
		}
		
		//if tree is under rain
		if( self.position.x > rainX && self.position.x < rainX + rainWidth)
		{
			[self setAlive];
		}
	}
	
	//destray when overburned
	if([self isBurning])
	{
		if(lastTime == 0)
		{
			lastTime = totalTime;  //first time drawing
		}
		
		if(totalTime - lastTime > burnTime) //if burning time is not over
		{
			[self setDestroyed:1];	
		}else 
		{
			//make fire bigger as it grows
			//TODO - particle count increment
			fireEmitter.emissionRate = fireEmitter.emissionRate + (totalTime - lastTime) / burnTime;
			//NSLog(@" - %f ",fireEmitter.emissionRate );
		}

	}
}

//start tree swinging animation
-(void) startAnimSwing
{
	if(!swinging)
	{
		swinging = YES;
		
		CCAction *tAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:tAnimation restoreOriginalFrame:NO] ];
		[tInitSprite runAction: tAnimAction];
	}
}
//stop animation
-(void) stopAnimSwing
{
	if(swinging)
	{ 
		//set to wqlk initial sprite, TODO make a newer version for setDisplayFrame
		//always finish on first frame
		CCSpriteFrame *firstSprite;
		
		swinging = NO;
		
		[tInitSprite stopAllActions];

		//set initial sprite
		[tInitSprite stopAllActions];
		firstSprite = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
		[tInitSprite setDisplayFrame: firstSprite];
	}
}


//get y and set it by x
-(void) setPositionByX: (float) x
{
	self.position = ccp(x, [[LevelDataCl sharedSingleton] getHeightByX:x]);
}

//set alive
-(void) setAlive
{
	status = 1;
	
	[self clearQueues];
	
	[fireEmitter stopSystem];
	
	//stop sound with id
	[[SoundCl sharedSingleton] stopGivenSound: fireSS];
}

//start tree burning
-(void) setOnFire
{
	status = 2;
	lastTime = 0;
	fireEmitter.angle = 90;
	[fireEmitter resetSystem];
	
	
	//play fire, store the sound id
	//[[SimpleAudioEngine sharedEngine] setEffectsVolume:  1.5f]; 
	[[SoundCl sharedSingleton] playGivenSound: fireSS];
}

//remove tree
//destructionType : 1 - burn, 2 - tornado
-(void) setDestroyed: (int) destructionType
{
	id actionSequence;
	
	status = 3;
	[fireEmitter stopSystem];
	//OPTI - maybe remove sprite and emmiter from memory?
	
	id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(onDestroyEnd)];
	if(destructionType == 2) //tornado blows up
	{
		//move up
		actionSequence = [CCSequence actions: [CCMoveBy actionWithDuration:0.2 position:ccp(0, 30)], actionCallFunc, nil];
		[self runAction:actionSequence];
	}
	else
	{
		//treeSprite.visible = NO; //hide tree 
		[self stopAnimSwing];
		tSpritesheet.visible = NO; //hide tornado
		//stop sound with id
		[[SoundCl sharedSingleton] stopGivenSound: fireSS];
	}
}
//callback

-(void) onDestroyEnd
{
	//treeSprite.visible = NO; //hide tree
	[self stopAnimSwing];
	tSpritesheet.visible = NO; //hide tornado
	//stop sound with id
	[[SoundCl sharedSingleton] stopGivenSound: fireSS];
}

//if is alive
-(BOOL) isAlive
{
	return (status == 1);
}

//if is burning
-(BOOL) isBurning
{
	return (status == 2);
}
//if is destroyed
-(BOOL) isDestroyed
{
	return (status == 3);
}

// TODO tree queue functions not used
//enemy queues
//increase queue for given enemy type
-(void) increaseQueue: (enemyTypes) eType
{
	//-1 index becouse types start from 1
	enemyQueue[eType-1]++;
}

//descrease queue for given enemy type
//NOT IN USE
-(void) descreaseQueue: (enemyTypes) eType
{
	//-1 index becouse types start from 1
	enemyQueue[eType-1]--;
}

-(void) clearQueues
{
	for(int i = 0; i < MAX_ENEMY_TYPE_NUMBER; i++) 
	{
		enemyQueue[i] = 0; 
	}
}


-(int) enemyQueue: (enemyTypes) eType
{
	return enemyQueue[eType-1];
}

-(void)dealloc 
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[animFileName release];
	[tAnimation release];
	
	[fireSS release];
	
    [super dealloc];
}


@synthesize dimensions;


@end