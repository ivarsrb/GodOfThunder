//
//  GameStateCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GameStateCl.h"


@implementation GameStateCl

static GameStateCl* _sharedSingleton = nil;

+(GameStateCl*)sharedSingleton
{
	@synchronized([GameStateCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([GameStateCl class])
	{
		NSAssert(_sharedSingleton == nil, @"GameStateCl: Attempted to allocate a second instance of a singleton.");
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
		maxLevel = 10; //TODO: this is final level number
		loosePoint = 475;
		continuedLevel = 0;
		isPaused = NO;
	}
	return self;
}



@synthesize maxLevel;
@synthesize loosePoint;
@synthesize continuedLevel;
@synthesize isPaused;

@end