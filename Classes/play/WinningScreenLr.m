//
//  WinningScreenLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "WinningScreenLr.h"


@implementation WinningScreenLr
- (id) init
{
	self = [super init];
	if (self != nil)
	//if( (self=[super initWithColor:ccc4(255,255,255,210)] )) 
	{
		glClearColor(255,255,255,255); //background of layer
		
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 
		
		CCSprite *bgSpr;  
		if([[LevelDataCl sharedSingleton] isLevelFinal])
			bgSpr = [CCSprite spriteWithFile:@"winning_scr_final_bg.png"];
        else 
			bgSpr = [CCSprite spriteWithFile:@"winning_scr_bg.png"];
		bgSpr.position = ccp(winSize.width/2, winSize.height/2);
		[self addChild:bgSpr];
		
		
		//Continue item menu
		[CCMenuItemFont setFontName:@"Arial Rounded MT Bold"]; //font for menu
		[CCMenuItemFont setFontSize:50];
		CCMenuItemFont *menuItemContinue;
		if([[LevelDataCl sharedSingleton] isLevelFinal])
			menuItemContinue = [CCMenuItemFont itemFromString:@"The End" target:self selector:@selector(onContinueSelected:)];
		else 
			menuItemContinue = [CCMenuItemFont itemFromString:@"Continue" target:self selector:@selector(onContinueSelected:)];

		[menuItemContinue.label setColor:ccc3(255, 255, 255)];
		
        CCMenu *menu = [CCMenu menuWithItems:menuItemContinue, nil];
        [menu alignItemsVertically];
		menu.position = ccp(winSize.width/2, 103);
        [self addChild:menu];
		
		[[SoundCl sharedSingleton] playMusic: WINNING_MUS : NO];
		
		//save completed level data to defaults
		if([[LevelDataCl sharedSingleton] isLevelFinal])  //iof this was last level, save nothing
		{
			[[GameStateCl sharedSingleton] setContinuedLevel:1]; //no more continue button visible in menu 
			[[LevelDataCl sharedSingleton] saveCurrentLevelToDefaults: 0]; //save 0 to defaults as well
		}else //take next level number and save it, becouse we deserve to be able to continue from next level
		{
			[[GameStateCl sharedSingleton] setContinuedLevel: [[LevelDataCl sharedSingleton] currentLevelID]+1];
			[[LevelDataCl sharedSingleton] saveCurrentLevelToDefaults: [[LevelDataCl sharedSingleton] currentLevelID]+1];
		}
		
		[[CCTouchDispatcher sharedDispatcher] removeAllDelegates];
	}
	
	return self;
}

//when transition of scene is finished
- (void) onEnterTransitionDidFinish  	 	 	
{
	[[SoundCl sharedSingleton] stopAllSounds];
}



//select next level
- (void)onContinueSelected:(id)sender
{
	[[LevelDataCl sharedSingleton] destroyLevel];
	
	//if is final level
	if([[LevelDataCl sharedSingleton] isLevelFinal])  //go back to menu
	{
		//change scene to menu scene
		[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5 scene:[MenuSc node]]];
	}else  //switch to next level
	{
		//go to play scene (next level will be set there)
		[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5 scene:[PlaySc node]]];
	}

}


- (void)dealloc 
{
	
    [super dealloc];
}
@end
