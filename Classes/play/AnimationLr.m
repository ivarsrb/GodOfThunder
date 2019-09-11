//
//  AnimationLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AnimationLr.h"


@implementation AnimationLr

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		isGameStopped = NO;
		
		//enemy related initializations, will be created and reused in runtime
		enemyCount = [[LevelDataCl sharedSingleton] enemyCount];
		
		enemyStatuses = (int *)malloc(enemyCount * sizeof(int));
		responsibleObject = (int *)malloc(enemyCount * sizeof(int));
		for(int i = 0; i < enemyCount; i++) 
		{
			enemyStatuses[i] = 0;
			responsibleObject[i] = -1; //no index
		}
		enemyCollection = [[NSMutableArray array] retain];

		//make ghosts for every enemy
		ghostCollection = [[NSMutableArray array] retain];
		
		//make bubbles after enemy drowns
		bubblesCollection = [[NSMutableArray array] retain];
		
		//create terrain hollows
		NSArray *hollowIndexes = [[LevelDataCl sharedSingleton] hollowsIndexes];
		hollowCollection = [NSMutableArray array]; //store hollows for drown checks later
		for(NSDictionary * tempDict in hollowIndexes) 
		{
			HollowLr *tempHollows = [[[HollowLr alloc] initWithIndexes:[[tempDict valueForKey:@"index_left"] intValue]:[[tempDict valueForKey:@"index_right"] intValue] ] autorelease];
			[self addChild: tempHollows z:6];
			[hollowCollection addObject: tempHollows]; //add to array
		}
		hollowCollection = [hollowCollection retain]; //make them accesable lower
		
		//create tree objects
		NSArray *treeArray = [[LevelDataCl sharedSingleton] treeCollections];
		treeCollection = [NSMutableArray array]; //store hollows for tree checks later
		for(NSArray * tempTeeArray in treeArray) 
		{
			//array - 0 = coords, 1 = type
			TreeSp *tempTree = [[[TreeSp alloc] initWithType:[[tempTeeArray objectAtIndex:1] intValue]] autorelease]; 
			[tempTree setPositionByX: [[tempTeeArray objectAtIndex:0] intValue]];
			[self addChild: tempTree]; //add to layer
			
			[treeCollection addObject: tempTree]; //add to array
		}
		treeCollection = [treeCollection retain]; //make them accesable lower
		
		//add fortress
		CCSprite *fortressSpr = [CCSprite spriteWithFile:@"fortress.png"]; 
		fortressSpr.anchorPoint = ccp(1.0,0.0);
		//fortressSpr.position = ccp(winSize.width,[[LevelDataCl sharedSingleton] groundBase]);
		//put fortress ta the minimal ground value under fortress
		float fortressWidth = 90;
		float leftRighMin = fminf([[LevelDataCl sharedSingleton] getHeightByX:winSize.width - fortressWidth], [[LevelDataCl sharedSingleton] getHeightByX:winSize.width]);
		fortressSpr.position = ccp(winSize.width,fminf(leftRighMin, [[LevelDataCl sharedSingleton] getHeightByX:winSize.width-fortressWidth/2]));
		[self addChild:fortressSpr z:-2];
		//[self createWavingFlag]; //waving flag
		
		//Create lightning graphics
		lightningEff = [LightningEffect node];
		lightningEff.strikeOrigin = ccp(0,280); //300 - total lightning length //TODO
		[self addChild:lightningEff];
		
		//Create rain particle graphics
		rainEmitter = [CCParticleRain node];
		rainEmitter.life = 2;
		rainEmitter.lifeVar = 0;
		rainEmitter.speed = 500;
		rainEmitter.startSize = 5;
		rainEmitter.startSizeVar = 0;
		rainEmitter.endSize = 5;
		rainEmitter.endSizeVar = 0;
		rainEmitter.emissionRate = 0;
		rainEmitter.angleVar = 0;
		rainEmitter.gravity = ccp(0,0);
		rainEmitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"rain_prt.png"];
		
		//TODO fire.png is used for rain by default, is probebly unset for default particles
		[rainEmitter stopSystem]; //off by default
		[self addChild: rainEmitter];
		
		//create tornado sprite
		tornadoSprite = [TornadoSp node];
		[self addChild: tornadoSprite z:5];
		
		//dark background under buttons
		[self createCloudsLayer];
		
		//add Terrain layer
		TerrainLr *terrainLayer = [TerrainLr node];
		[self addChild:terrainLayer z:10];
		
		//add Control layer
		ControlLr *controlLayer = [ControlLr node];
		[self addChild:controlLayer z:20];
		
		// register to receive targeted touch events
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
														 priority:0
												  swallowsTouches:YES];
		
		//accelerometer shake
		self.isAccelerometerEnabled = YES;
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 40)];
		[[UIAccelerometer sharedAccelerometer] setDelegate:self];

		//set function for updating
		[self schedule:@selector(gameLoop:)];
	}
	return self;
}

//device shaking
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration 
{	
	const float violence = 1.5;
	static BOOL beenhere;
	BOOL shake = FALSE;
	
	if (beenhere) 
		return;
	beenhere = TRUE;
	if (acceleration.x > violence * 1.5 || acceleration.x < (-1.5* violence))
		shake = TRUE;
	if (acceleration.y > violence * 2 || acceleration.y < (-2 * violence))
		shake = TRUE;
	if (acceleration.z > violence * 3 || acceleration.z < (-3 * violence))
		shake = TRUE;
	if (shake) 
	{
		//NSLog(@"shake it shake it");
		
		//[self runAction:[CCShaky3D actionWithRange:5 shakeZ:NO grid:ccg(15,10) duration:2]];

		/*
		[self runAction:[CCSequence actions: 
						 [CCMoveBy   actionWithDuration:0.1 position:ccp(0, 7)],
						 [CCMoveBy   actionWithDuration:0.1 position:ccp(0, -7)],
						 [CCMoveBy   actionWithDuration:0.1 position:ccp(0, 7)],
						 [CCMoveBy   actionWithDuration:0.1 position:ccp(0, -7)], 
						 nil]];
		 */
	} 
	beenhere = FALSE;
}
 

//main game loop
- (void) gameLoop:(ccTime)dt
{
	if(![[LevelDataCl sharedSingleton] levelInitialized])
		return;
	
	totalTime += dt;
	
	BOOL isAnybodyAlive = NO; //check weather there is still alive enemies left, for winning condition
	//create/reuse enemy objects
	for (int i = 0; i < enemyCount; i++)
	{
		if(enemyStatuses[i] == 0) //not in game 
		{
			if([[LevelDataCl sharedSingleton] enemyTriggerTime][i] < totalTime) //if there is time for new enemy to appear
			{
				BOOL startingPointJammed = NO; //for chenking if enemy can start, will start only if no obstacle is in way
				//check if there is no other enemy in the starting point, release only if there is free place
				for(EnemySp* tempEnemy in enemyCollection)
				{
					if([tempEnemy isInGame] && [[LevelDataCl sharedSingleton] enemyContents][i] == [tempEnemy enemyType] )
					{
						CGRect enemyRect = CGRectMake(tempEnemy.position.x-tempEnemy.dimensions.width/2, 0, 
													  tempEnemy.dimensions.width,[[CCDirector sharedDirector] winSize].height);
						
						//if there is free place for enemy, check two points closest and the farest of enemy BB (10 is random number)
						if(CGRectContainsPoint(enemyRect, ccp(0, 10)) || CGRectContainsPoint(enemyRect, ccp(tempEnemy.dimensions.width, 10)))
 						{
							startingPointJammed = YES;
						}
					}
				}
				//-----
				if(!startingPointJammed) //starting point is not taken by other enemy
				{
					BOOL spareEnemyExists = NO;
					//if there is no spare enemy, create new enemy
					//search for enemy that is no more in game
					for(EnemySp *tempEnemy in enemyCollection)
					{
						if([tempEnemy enemyType] == [[LevelDataCl sharedSingleton] enemyContents][i]  && //enemy type matches
						   [tempEnemy objectFreeToReuse]) //if resource is free
						{
							[tempEnemy reset]; //this will be used for new enemy, so reset initial values
							[tempEnemy startMovement];
							spareEnemyExists = YES;
							//NSLog(@"Reuse");
							responsibleObject[i] = [enemyCollection indexOfObject:tempEnemy]; //save responsible index
							
							break;
						}
					}
					
					if(!spareEnemyExists) //no spare enemies so create new
					{
						EnemySp *tempEnemy = [[[EnemySp alloc] initWithType:[[LevelDataCl sharedSingleton] enemyContents][i]] autorelease];
						
						[self addChild: tempEnemy]; //add to layer
						[enemyCollection addObject: tempEnemy]; //add to array
						[tempEnemy startMovement];
						//NSLog(@"Create");
						responsibleObject[i] = [enemyCollection indexOfObject:tempEnemy]; //save responsible index
					}
					
					enemyStatuses[i] = 1; 
				}
			}
		}
		if(enemyStatuses[i] != 2) //if atleast one status is not "off"
		{
			isAnybodyAlive = YES; //there is atleast one alive
		}
	}
	
	// Enemy loop ---------------------------------
	for(EnemySp* tempEnemy in enemyCollection)
	{
		if([tempEnemy isAlive]) //if enemy is alive
		{
			//Check LOOSING CONDITION
			if(!isGameStopped && tempEnemy.position.x > [[GameStateCl sharedSingleton] loosePoint])
			{
				[[SoundCl sharedSingleton] stopAllSounds];
				//show loosing window and exit level to menu
				isGameStopped = YES;
				
				[[CCDirector sharedDirector] replaceScene:[CCMoveInTTransition transitionWithDuration:1.5 scene:[LoosingScreenLr node]]];	
				break;
			}
			
			//check against hollow drown
			for(HollowLr *tempHollow in hollowCollection)
			{
				//TODO - rotated horse drown
				if( [tempHollow isDrowning: tempEnemy.position : tempEnemy.drownHeight])
				{
					//mark enemy sprite object as destroyed
					[tempEnemy setDestroyed:1];
					
					[self markEnemyDestruction:tempEnemy];
						
					if(!isGameStopped) //dont play drown sound when loosing screen appears
						[[SoundCl sharedSingleton] playSound: DROWN_EFF loop:NO];
					
					//create ghost or reuse ghost
					//[self releaseGhost:tempEnemy];
					
					//release bubbles
					[self releaseBubbles:tempEnemy];
					
					break;
				}
			}
			
			
			//check agaoinst tornado hits enemy
			if([[TornadoCl sharedSingleton] isMoving] && [tempEnemy isInGame])
			{
			   //check sprite rectangle intersection
				CGRect enemyRect = CGRectMake((tempEnemy.position.x-tempEnemy.dimensions.width/2), tempEnemy.position.y, 
											   tempEnemy.dimensions.width,tempEnemy.dimensions.height);
										   
				CGRect tornadoRect = CGRectMake(tornadoSprite.position.x, tornadoSprite.position.y, 
											    tornadoSprite.spwidth/2,tempEnemy.dimensions.height);						   
				
				if(CGRectIntersectsRect(enemyRect, tornadoRect))
				{
					[tempEnemy setDestroyed:3];
					
					[self markEnemyDestruction:tempEnemy];
				}
			}
			
		}
	}
	
	//burning tree queue
	int leftDisplacement = 8; //size of which tree bounding box will be shortened to left
	int queueGap = 3; //pixels from one enemy to other in queue
	//enemy against tree
	for(TreeSp * tempTree in treeCollection)
	{
		for(EnemySp* tempEnemy in enemyCollection)
		{
			if([tempEnemy isAlive]) //if enemy is alive 
			{
				
				CGRect treeRect = CGRectMake((tempTree.position.x - tempTree.dimensions.width/2 - leftDisplacement), tempTree.position.y, 
											 tempTree.dimensions.width - tempTree.dimensions.width/2, tempTree.dimensions.height);						   
				
				CGRect enemyRect = CGRectMake(tempEnemy.position.x, tempEnemy.position.y, 
											  tempEnemy.dimensions.width/2,tempEnemy.dimensions.height);
				
				if(CGRectIntersectsRect(enemyRect, treeRect))
				{
					if([tempTree isBurning])
					{
						[tempEnemy setStoppedByTree:YES ];
						if([tempEnemy isMoving])
						{
							[tempEnemy stopMovement];
						}
					}
					else 
					{
						[tempEnemy setStoppedByTree:NO];
						if([tempEnemy isStopped])
						{
							[tempEnemy startMovement];
						}
					}
				}
			}
		}
	}
	
	//enemy against enemy check colosions
	BOOL wasIntersectedByEnemy;
	for(EnemySp* tempEnemy in enemyCollection)
	{
		wasIntersectedByEnemy = NO;
		if([tempEnemy isInGame]) 
		{
			for(EnemySp* tempEnemy2 in enemyCollection)
			{
				if([tempEnemy2 isInGame] && [tempEnemy enemyType] == [tempEnemy2 enemyType] &&
				   [enemyCollection indexOfObject:tempEnemy] != [enemyCollection indexOfObject:tempEnemy2]
				   )
				{
					
					CGRect enemyRect = CGRectMake(tempEnemy.position.x , tempEnemy.position.y, 
												  tempEnemy.dimensions.width/2 + queueGap,tempEnemy.dimensions.height);
					
					CGRect enemyRect2 = CGRectMake(tempEnemy2.position.x-tempEnemy.dimensions.width/2, tempEnemy2.position.y, 
												  tempEnemy2.dimensions.width/2,tempEnemy2.dimensions.height);
					
					if(CGRectIntersectsRect(enemyRect, enemyRect2))
					{
						if([tempEnemy isMoving])
						{
							[tempEnemy stopMovement];
						}
						wasIntersectedByEnemy = YES;
					}
				}
			}
			
			if(!wasIntersectedByEnemy)
			{
				if([tempEnemy isStopped] && ![tempEnemy stoppedByTree])
				{
					[tempEnemy startMovement];
				}
			}
		}
	}
	//-------------

	
	
	//Check WINNING CONDITION
	if (!isGameStopped  && !isAnybodyAlive) 
	{
		//show winning window and exit level to menu
		isGameStopped = YES;
		[[CCDirector sharedDirector] replaceScene:[CCMoveInTTransition transitionWithDuration:1.5 scene:[WinningScreenLr node]]];
	}
	
	// Weather ---------------------------------
	//Rain processing
	//if rain was canceled, stop rain animation
	if([rainEmitter active] && [[RainCl sharedSingleton] isRainStopped])
	{
		[rainEmitter stopSystem];
	}
	
	//Tornado
	//if singleton is on, but sprite is off (user presees on button)
	if([[TornadoCl sharedSingleton] isMoving] && [tornadoSprite isSilent])
	{
		[tornadoSprite startAnimTwist];
	}
	//turn off tornado if user pressed off button
	if([[TornadoCl sharedSingleton] isOff] && [tornadoSprite isAnimated])
	{
		[tornadoSprite stopAnimTwist];
	}
	if(tornadoSprite.position.x < 0)
	{
		[[TornadoCl sharedSingleton] setOff];
	}
	//check against tornado hits tree
	for(TreeSp * tempTree in treeCollection)
	{
		if([[TornadoCl sharedSingleton] isMoving] && ![tempTree isDestroyed])
		{
			//check sprite rectangle intersection
			CGRect treeRect = CGRectMake((tempTree.position.x-tempTree.dimensions.width/2), tempTree.position.y, 
										  tempTree.dimensions.width,tempTree.dimensions.height);
			
			CGRect tornadoRect = CGRectMake(tornadoSprite.position.x, tornadoSprite.position.y, 
											tornadoSprite.spwidth/2,tempTree.dimensions.height);						   
			
			if(CGRectIntersectsRect(treeRect, tornadoRect))
			{
				[tempTree setDestroyed:2];	
				break;
			}

		}
	}
	
}

//everything that is manually drawn put here
-(void) draw
{
	//draw rain selection line
	if ([[RainCl sharedSingleton] isBeingDragged])
	{
		glColor4f(0.74, 0.91, 0.99, 0.3);
		glLineWidth(8.0f);
		ccDrawLine([[RainCl sharedSingleton] rainPos1], [[RainCl sharedSingleton] rainPos2]);
	}
}


//-------------------------------------------------------------------
//events

//start touch
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event 
{
	CGSize winSize = [[CCDirector sharedDirector] winSize];
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
	
	if([[CCDirector sharedDirector] isPaused]) //when game pasued
		return NO;//DONT pass on
	
	if( convertedPoint.y > winSize.height - 80) //clicked above play area (80 = control height)
		return NO;//DONT pass on
	
	//start rain drag process
	if ([[RainCl sharedSingleton] readyForRain]) //first time tapping to select rain position
	{
		//save drag start location
		[[RainCl sharedSingleton] setRainPos1:convertedPoint];
		//TODO now defualt rain width is 5 px
		[[RainCl sharedSingleton] setRainPos2:ccp(convertedPoint.x+5, convertedPoint.y)]; 		
		[[RainCl sharedSingleton] setRainDrag]; //start dragging mode
		return YES;
	}
	
	//if we are in rain dragging process
	if ([[RainCl sharedSingleton] isBeingDragged])
	{
		return NO; //DONT pass on
	}
	
	//normaly pass on
    return YES;
}

//in process of mooving touch
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
    
	//set rain width and locations value (first one is set at the touch start)
	if ([[RainCl sharedSingleton] isBeingDragged])
	{
		//second y is always as first pints y
		[[RainCl sharedSingleton] setRainPos2:ccp(convertedPoint.x,[[RainCl sharedSingleton] rainPos2].y)];
	}
	
	
}

//end screen touch
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedPoint = [[CCDirector sharedDirector] convertToGL:location];
	BOOL objectHit = NO; //some object was hit (allow only one object to be hit)  
	BOOL saveLightningEnergy = NO; //saves energy when ghost is struck
	//if lightning is about to strike
	if([[LightningCl sharedSingleton] readyToStrike] && ![[RainCl sharedSingleton] isBeingDragged]) //dont strike when rain is set
	{
		//check if hits enemy
		for(EnemySp* tempEnemy in enemyCollection)
		{
			if([tempEnemy isAlive]) //if enemy is alive
			{
				//make enemy bounding box
				CGRect myRect = CGRectMake((tempEnemy.position.x-tempEnemy.dimensions.width/2)-[tempEnemy hitExtra], tempEnemy.position.y-[tempEnemy hitExtra], 
										   tempEnemy.dimensions.width+[tempEnemy hitExtra],tempEnemy.dimensions.height+[tempEnemy hitExtra]);
				
				if(CGRectContainsPoint(myRect, convertedPoint)) //if particular Sprite touched
				{						
					//hide (remove) enemy sprite object
					[tempEnemy setDestroyed:2];
					
					[self markEnemyDestruction:tempEnemy];
					
					[self releaseGhost:tempEnemy];
					
					objectHit = YES;
					break;
				}
			}
		}
		
		//check if hits ghost
		if(!objectHit)
		for(GhostSp* tempGhost in ghostCollection)
		{
			if([tempGhost isGhostFlying]) //if ghost is active
			{
				//make ghost bounding box
				//TODO - make apropriate coordinates
				CGRect myRect = CGRectMake((tempGhost.position.x - tempGhost.dimensions.width/2)-[tempGhost hitExtra], tempGhost.position.y-[tempGhost hitExtra], 
										   tempGhost.dimensions.width+[tempGhost hitExtra],tempGhost.dimensions.height+[tempGhost hitExtra]);
				
				if(CGRectContainsPoint(myRect, convertedPoint)) //if particular Sprite touched
				{						
					
					
					//hide sprite
					[tempGhost stopAnimFly];
					
					//add to all element energy
					[[WindCl sharedSingleton] increaseEnergyFromGhost];
					[[RainCl sharedSingleton] increaseEnergyFromGhost];
					//[[LightningCl sharedSingleton] increaseEnergyFromGhost];
					[[TornadoCl sharedSingleton] increaseEnergyFromGhost];
					
					[[SoundCl sharedSingleton] playSound: GHOST_PICK_EFF loop:NO];
					
					objectHit = YES;
					saveLightningEnergy = YES;
					break;
				}
			}
		}
		
		//check if hits tree
		if(!objectHit)
		for(TreeSp * tempTree in treeCollection) 
		{
			if([tempTree isAlive]) //if tree is alive
			{
				//make tree bounding box
				//TODO - make apropriate coordinates
				CGRect myRect = CGRectMake(tempTree.position.x-tempTree.dimensions.width/2, tempTree.position.y, tempTree.dimensions.width,tempTree.dimensions.height);
				
				if(CGRectContainsPoint(myRect, convertedPoint)) //if particular Sprite touched
				{						
					//burn tree
					[tempTree setOnFire];
					objectHit = YES;
					break;
				}
			}
			//[tempTree clearQueues];
		}
		
		[[LightningCl sharedSingleton] strike:saveLightningEnergy]; //lightning energy modification
		//draw lightning
		lightningEff.position = convertedPoint;
		[lightningEff strike];
	}
	
	
	//if rain is finished dragging (finished selecting position)
	//set rain start
	if ([[RainCl sharedSingleton] isBeingDragged])
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize]; //parameters of Opengl window
		float rainWidth; //width of rain line
		float rainMiddle; //middle point of rain line
		
		[[RainCl sharedSingleton] setRain];
		
		//start rain animation process
		rainWidth = fabs([[RainCl sharedSingleton] rainPos1].x - [[RainCl sharedSingleton] rainPos2].x);
		rainMiddle = ([[RainCl sharedSingleton] rainPos1].x + [[RainCl sharedSingleton] rainPos2].x) / 2;
		
		//set rain particle system position and width
		rainEmitter.position = ccp(rainMiddle,  winSize.height); //center position of rain
		rainEmitter.posVar = ccp(rainWidth/2,0); //half width
		rainEmitter.emissionRate = rainWidth; //rain intensity TODO, think about intencity
		
		[rainEmitter resetSystem]; //start system
	}
	
}

//create ghost, if no spare objects left to reuse, create new one
- (void) releaseGhost: (EnemySp*) tempEnemy 
{
	BOOL spareGhostExists = NO;
	//check if there is some unused left
	for(GhostSp* tempGhost in ghostCollection)
	{
		if(![tempGhost isGhostFlying]) //ghost is usable
		{
			[tempGhost reset];
			[tempGhost startAnimFly:tempEnemy.position];
			spareGhostExists = YES;
			break;
			//NSLog(@"reuse");
		}
	}
	//if there is no spare ghost available, create new
	if(!spareGhostExists)
	{
		GhostSp *tempGhost = [GhostSp node];
		[self addChild: tempGhost]; //add to layer
		[ghostCollection addObject: tempGhost]; //add to array
		[tempGhost startAnimFly:tempEnemy.position];
		//NSLog(@"new");
	}
}


//create bubbles, if no spare objects left to reuse, create new one
- (void) releaseBubbles: (EnemySp*) tempEnemy 
{
	BOOL spareObjectExists = NO;
	//check if there is some unused left
	for(BubblesSp* tempBubble in bubblesCollection)
	{
		if(![tempBubble isBubblesFlowing]) //ghost is usable
		{
			[tempBubble reset];
			[tempBubble startAnimFlow:tempEnemy.position];
			spareObjectExists = YES;
			//NSLog(@"reuse");
			break;
			
		}
	}
	//if there is no spare ghost available, create new
	if(!spareObjectExists)
	{
		BubblesSp *tempBubble = [BubblesSp node];
		[self addChild: tempBubble]; //add to layer
		[bubblesCollection addObject: tempBubble]; //add to array
		[tempBubble startAnimFlow:tempEnemy.position];
		//NSLog(@"new");
	}
}



//mark in global array when enemy is destroyed
- (void) markEnemyDestruction: (EnemySp*) tempEnemy 
{
	//find which element in main array is tied to given sprite object to destroy
	int currIndex = [enemyCollection indexOfObject:tempEnemy];
	for(int i = 0; i < enemyCount; i++)
	{
		if(responsibleObject[i] == currIndex) //responsible found
		{
			responsibleObject[i] = -1; //null this
			enemyStatuses[i] = 2; //mark enemy as destroyed
			break;
		}
	}
}

//decorative cloud layer create and animate
- (void) createCloudsLayer
{
	//CGSize winSize = [[CCDirector sharedDirector] winSize];
	
	/*
	CCColorLayer *backgroundLayer = [CCColorLayer layerWithColor:ccc4(0, 0, 0, 255) width:winSize.width  height: 80];
	backgroundLayer.position = ccp(0, 240);
	[self addChild: backgroundLayer];
	*/
	//control background 
	CCSprite *bgSpr = [CCSprite spriteWithFile:@"butt_bg.png"]; 
	bgSpr.anchorPoint = ccp(0,0);
	bgSpr.position = ccp(0, 240);
	[self addChild: bgSpr z:18];
	
	//animated background
	/*
	NSMutableString *animFileName; 
	animFileName = [NSMutableString stringWithString: @"clouds_flow"]; //without file extention
	
	[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",animFileName]];
	CCSprite *tInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
	tInitSprite.anchorPoint = ccp(0,0); 
	tInitSprite.position = ccp(0,180);
	CCSpriteSheet *tSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",animFileName]];
	
	int frameCount = 7;
	//create frames
	NSMutableArray *animFrames = [NSMutableArray array];
	for(int i = 1; i < frameCount + 1; i++) {
		
		CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",animFileName,i]];
		[animFrames addObject:frame];
	}
	//set animation
	CCAnimation *tAnimation = [CCAnimation animationWithName:@"clouds_flowing" delay:0.07f frames:animFrames];
	
	[tSpritesheet addChild:tInitSprite];
	[self addChild:tSpritesheet];
	
	CCAction *tAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:tAnimation restoreOriginalFrame:NO] ];
	[tInitSprite runAction: tAnimAction];
	*/
}


//waving flag create and animate
/*
- (void) createWavingFlag
{
	//animated flag
	 NSMutableString *animFileName; 
	 animFileName = [NSMutableString stringWithString: @"flag"]; //without file extention
	 
	 [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: [NSMutableString stringWithFormat:@"%@.plist",animFileName]];
	 CCSprite *tInitSprite = [CCSprite spriteWithSpriteFrameName:[NSMutableString stringWithFormat:@"%@_1.png",animFileName]];
	 tInitSprite.anchorPoint = ccp(1,0); 
	 tInitSprite.position = ccp(460,180);
	 CCSpriteSheet *tSpritesheet = [CCSpriteSheet spriteSheetWithFile:[NSMutableString stringWithFormat:@"%@.png",animFileName]];
	 
	 int frameCount = 5;
	 //create frames
	 NSMutableArray *animFrames = [NSMutableArray array];
	 for(int i = 1; i < frameCount + 1; i++) 
	 {
		 CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSMutableString stringWithFormat:@"%@_%d.png",animFileName,i]];
		 [animFrames addObject:frame];
	 }
	 //set animation
	 CCAnimation *tAnimation = [CCAnimation animationWithName:@"flag_waving" delay:0.07f frames:animFrames];
	 
	 [tSpritesheet addChild:tInitSprite];
	 [self addChild:tSpritesheet];
	 
	 CCAction *tAnimAction = [CCRepeatForever actionWithAction: [CCAnimate actionWithAnimation:tAnimation restoreOriginalFrame:NO] ];
	 [tInitSprite runAction: tAnimAction];
}
*/
//-------------------------------------------------------------------


- (void)dealloc 
{
	[[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
	[enemyCollection release];
	[ghostCollection release];
	[hollowCollection release];
	[treeCollection release];
	[bubblesCollection release];
	
	free(enemyStatuses);
	free(responsibleObject);
	
    [super dealloc];
}


@end


