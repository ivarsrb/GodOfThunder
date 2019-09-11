//
//  GraphicsCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "GraphicsCl.h"


@implementation GraphicsCl

static GraphicsCl* _sharedSingleton = nil;

+(GraphicsCl*)sharedSingleton
{
	@synchronized([GraphicsCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([GraphicsCl class])
	{
		NSAssert(_sharedSingleton == nil, @"GraphicsCl: Attempted to allocate a second instance of a singleton.");
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
		
	}
	return self;
}

//load graphic resources such as textures here, will be preloaded
- (void) loadGraphics
{
	//[[CCTextureCache sharedTextureCache] addImageAsync:@"background1.jpg" target:self selector:@selector(imageLoaded:)];
	//[[CCTextureCache sharedTextureCache] addImage: @"rain_prt.png"];
}




@end
