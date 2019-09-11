//
//  LoosingScreenLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LoosingScreenLr.h"


@implementation LoosingScreenLr
- (id) init
{
	self = [super init];
	if (self != nil)
	{
		glClearColor(255,0,0,255); //background of layer
		
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 

		//set background here
		CCSprite *bgSpr = [CCSprite spriteWithFile:@"loosing_scr_bg.png"]; 
		bgSpr.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:bgSpr];
		
		//Continue item menu
		[CCMenuItemFont setFontName:@"Arial Rounded MT Bold"]; //font for menu
		[CCMenuItemFont setFontSize:50];
		CCMenuItemFont *menuItemContinue = [CCMenuItemFont itemFromString:@"Retry" target:self selector:@selector(onContinueSelected:)];
		[menuItemContinue.label setColor:ccc3(255, 255, 255)];

        CCMenu *menu = [CCMenu menuWithItems:menuItemContinue, nil];
        [menu alignItemsVertically];
		menu.position = ccp(winSize.width/2, 151);
        [self addChild:menu];
		
		[[SoundCl sharedSingleton] playMusic: LOOSE_MUS : NO];
	
		//create fire particles for smoke effect
		smokeEmitter = [CCParticleSmoke node]; 
		smokeEmitter.startSize = 18;
		smokeEmitter.endSize = 2;
		smokeEmitter.startSizeVar = 2;
		smokeEmitter.endSizeVar = 2;
		smokeEmitter.emissionRate = 40;
		ccColor4F startColorVar = {0.0f, 0.0f, 0.0f, 0.5f};
		smokeEmitter.startColor = startColorVar;
		ccColor4F endColorVar = {0.0f, 0.0f, 0.0f, 0.2f};
		smokeEmitter.endColor = endColorVar;
		smokeEmitter.life = 2;
		smokeEmitter.position = ccp(70, 85);
		smokeEmitter.posVar = ccp(10,0); //half width
		smokeEmitter.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire_prt.png"];
		[smokeEmitter stopSystem];
		[self addChild: smokeEmitter];
		
		[[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
	}
		
	return self;
}

//when transition of scene is finished
- (void) onEnterTransitionDidFinish  	 	 	
{
	[smokeEmitter resetSystem];
}


//jump to main menu when we loose
- (void)onContinueSelected:(id)sender
{
	//finish level and game
	[[LevelDataCl sharedSingleton] destroyLevel];
	
	//get current level minus 1, so we can return to level we lost in
	int levelBeforeNeeded = [[GameStateCl sharedSingleton] continuedLevel] - 1;
	[[LevelDataCl sharedSingleton] setCurrentLevel:levelBeforeNeeded];
	
	//go to play scene (nex level will be set there)
	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5 scene:[PlaySc node]]];
}


@end
