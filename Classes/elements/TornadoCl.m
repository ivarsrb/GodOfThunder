//
//  TornadoCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TornadoCl.h"


@implementation TornadoCl

static TornadoCl* _sharedSingleton = nil;

+(TornadoCl*)sharedSingleton
{
	@synchronized([TornadoCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([TornadoCl class])
	{
		NSAssert(_sharedSingleton == nil, @"TornadoCl: Attempted to allocate a second instance of a singleton.");
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
	//TODO - think about these factors
	energy = 0;
	topEnergy = 100;
	runPower = 100;
	speed = 70;
	[self setOff];
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



//status changes and checks and actions
-(void) setMoving
{
	energy -= runPower;
	status = 1;
	//play sound
	[[SoundCl sharedSingleton] playSound: TORNADO_EFF loop:YES];
}

-(void) setOff
{
	status = 0;
	//stop sound
	[[SoundCl sharedSingleton] stopSound: TORNADO_EFF];
}

-(BOOL) isMoving
{
	return (status == 1);
}

-(BOOL) isOff
{
	return (status == 0);
}

//weather there is neaugh energy for tonrado
-(BOOL) hasEnoughEnergy
{
	return (energy >= runPower);
}

@synthesize energy;
@synthesize speed;

@end

