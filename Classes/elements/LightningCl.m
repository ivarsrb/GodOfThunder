//
//  LightningCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LightningCl.h"


@implementation LightningCl

static LightningCl* _sharedSingleton = nil;

+(LightningCl*)sharedSingleton
{
	@synchronized([LightningCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([LightningCl class])
	{
		NSAssert(_sharedSingleton == nil, @"LightningCl: Attempted to allocate a second instance of a singleton.");
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
	readyToStrike = NO;
	topEnergy = energy = 100;
	strikePower = 15; //15 
	increaser = 4;	
}


//renew lightning energy
//return 1 if renergy is not enough
-(int) updateEnergy:(ccTime) dt
{
	if(topEnergy > energy) //renewal of energy
	{
		energy = energy + increaser * dt;
		if(energy < strikePower) //if there is not enaugh in strike power
			return 1;
	}
	return 0;
}

//performe strike and reduce energy
-(void) strike: (BOOL) saveEnergy
{
	if(!saveEnergy)
		energy = energy - strikePower;
	
	//play random sound
	if(arc4random() % 2 == 0)
	{
		[[SoundCl sharedSingleton] playSound: LIGHTNING_EFF loop:NO];
	}else
		[[SoundCl sharedSingleton] playSound: LIGHTNING_1_EFF loop:NO];
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

//return strike count taht is possible with current energy
-(int) energyForStrikes
{
	return floor(energy / strikePower);
}

//is used when ghost is hit by lightning
/*
-(void) increaseEnergyFromGhost
{
	[self increaseEnergy:10]; //TODO, decide on energy power
}
*/

@synthesize readyToStrike;
@synthesize energy;
@end


