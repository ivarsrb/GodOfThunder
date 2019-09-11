//
//  WindCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WindCl.h"


@implementation WindCl

static WindCl* _sharedSingleton = nil;

+(WindCl*)sharedSingleton
{
	@synchronized([WindCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([WindCl class])
	{
		NSAssert(_sharedSingleton == nil, @"WindCl: Attempted to allocate a second instance of a singleton.");
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
	blowing = NO; //wind is off by default
	windSpeed = 0.5;
	topEnergy = energy = 100;
	decreaser = 12;
	increaser = 6;
}


//return 1 if ran out of energy
-(int) updateEnergy:(ccTime) dt
{
	
	if(blowing) //decrease when blowing
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

//manage wind states
-(void) startBlowing
{
	blowing = YES;
	//play sound
	[[SoundCl sharedSingleton] playSound: WIND_EFF loop:YES];
}

-(void) stopBlowing
{
	blowing = NO;
	//stop sound
	[[SoundCl sharedSingleton] stopSound: WIND_EFF];
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
@synthesize windSpeed;
@synthesize blowing; //make getter and setter for them

@end





