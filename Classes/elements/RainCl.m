//
//  RainCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "RainCl.h"


@implementation RainCl

static RainCl* _sharedSingleton = nil;

+(RainCl*)sharedSingleton
{
	@synchronized([RainCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([RainCl class])
	{
		NSAssert(_sharedSingleton == nil, @"RainCl: Attempted to allocate a second instance of a singleton.");
		_sharedSingleton = [super alloc];
		return _sharedSingleton;
	}
	
	return nil;
}


- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		[self reset];
	}
	return self;
}

//set inital values for element
-(void) reset
{
	energy = topEnergy = 100;
	status = 0;
	decreaser = 0; //calculated later
	increaser = 6;
	
	rainPos1 = ccp(0,0);
	rainPos2 = ccp(0,0);
}


//return - 1 if ran out of energy
-(int) updateEnergy:(ccTime) dt
{
	if([self isRaining]) //decrease when raining
	{
		energy = energy - decreaser * dt;
		if (energy <= 0) //stop wind
		{
			return 1;
		}else
			return 0;
		
	}else if(topEnergy > energy) //renewal of energy
	{
		energy = energy + increaser * dt;
	}
	
	return 0;
}

//check weather energy is enaugh to rain
-(BOOL) canRain;
{
	return (energy > 0);
}

//if rain is in starting mode (no rain, no rain pos selection)
-(BOOL) isRainStopped
{
	return (status == 0);
}


//if in process of rain place selection
-(BOOL) readyForRain
{
	return (status == 1);
}

//rain position and width is beiing selected (dragged across the screen)
-(BOOL) isBeingDragged
{
	return (status == 2);
}

//is raining at the moment
-(BOOL) isRaining
{
	return (status == 3);
}


//set in mode where user select rain place
-(void) setReadyForRain
{
	status = 1;
}

//set in mode where user select rain place
-(void) setRainDrag
{
	status = 2;
}


//start raining process
-(void) setRain
{
	status = 3;
	
	//takes two rain width points, calculates width and calculates relative energy decreaser
	//TODO make normal relative decreaser
	decreaser = fabs(rainPos1.x - rainPos2.x) / 8;
	
	//play sound
	[[SoundCl sharedSingleton] playSound: RAIN_EFF loop:YES];
}

//raining is canceled
-(void) cancelRain
{
	status = 0;
	
	//stop sound
	[[SoundCl sharedSingleton] stopSound: RAIN_EFF];
}

//increase energy by given number
-(void) increaseEnergy: (float) energyStep
{
	if(energy + energyStep > topEnergy) //dont let energy run over
	{
		energy = topEnergy;
	}
	else
	{
		energy += energyStep;
	}
}

//is used when ghost is hit by lightning
-(void) increaseEnergyFromGhost
{
	[self increaseEnergy:10]; //TODO, decide on energy power
}

@synthesize energy;

@synthesize rainPos1;
@synthesize rainPos2;

@end

