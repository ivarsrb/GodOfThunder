//
//  MenuLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Layer for menu items

#import "MenuLr.h"

//TODO - move this layer to Scene, there is no need at the moment for it

@implementation MenuLr
- (id) init
{
    self = [super init];
    if (self != nil) 
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		[CCMenuItemFont setFontName:@"Arial Rounded MT Bold"]; //font for menu
		//Play game item
		[CCMenuItemFont setFontSize:60];
		CCMenuItemFont *menuItemPlay = [CCMenuItemFont itemFromString:@"Play" target:self selector:@selector(onPlaySelected:)];
		[menuItemPlay.label setColor:ccc3(255, 255, 255)];
		
		//--
		[CCMenuItemFont setFontSize:40];
		CCMenuItemFont *menuItemContinue = [CCMenuItemFont itemFromString:@"Continue" target:self selector:@selector(onContinueSelected:)];
		[menuItemContinue.label setColor:ccc3(186, 239, 70)];
		if([[GameStateCl sharedSingleton] continuedLevel] <= 1) //if there is nothing to continue (1st level does not count), disable
		{	
			//menuItemContinue.disabledColor = ccc3(255, 255, 255);
			[menuItemContinue setIsEnabled:NO];
		}
		
		//--
		[CCMenuItemFont setFontSize:35];
		CCMenuItemFont *menuItemSettings = [CCMenuItemFont itemFromString:@"Settings" target:self selector:@selector(onSettingsSelected:)];
		[menuItemSettings.label setColor:ccc3(255, 255, 255)];
		
		//--
		
		//[CCMenuItemFont setFontSize:30];
		CCMenuItemFont *menuItemHelp = [CCMenuItemFont itemFromString:@"Info/Help" target:self selector:@selector(onHelpSelected:)];
		[menuItemHelp.label setColor:ccc3(255, 255, 255)];
		
		//--
		/*
		CCMenuItemFont *menuItemCredits = [CCMenuItemFont itemFromString:@"Credits" target:self selector:@selector(onCreditsSelected:)];
		[menuItemCredits.label setColor:ccc3(255, 255, 255)];
		*/
		 
		//menuItemCredits
		CCMenu *menu = [CCMenu menuWithItems:menuItemPlay,menuItemContinue, menuItemSettings,menuItemHelp , nil];
        [menu alignItemsVertically];
		menu.position = ccp(winSize.width/2,140);
		
        [self addChild:menu];
	}
    return self;
}

//when play item is selected
- (void)onPlaySelected:(id)sender
{
	//reset level data to start position (to first levelk)
	[[LevelDataCl sharedSingleton] reset];
	
	//erase all saved levels when starting new game
	[[GameStateCl sharedSingleton] setContinuedLevel:1]; //no more continue button visible in menu 
	[[LevelDataCl sharedSingleton] saveCurrentLevelToDefaults: 0]; //save 0 to defaults as well
	
	//change scene to play scene
	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5 scene:[PlaySc node]]];

}

//when continue item is selected
- (void)onContinueSelected:(id)sender
{
	//get current level minus 1, becouse it will increase level number when initialized
	int levelBeforeNeeded = [[GameStateCl sharedSingleton] continuedLevel] - 1;
	[[LevelDataCl sharedSingleton] setCurrentLevel:levelBeforeNeeded];
	
	//change scene to play scene
	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5 scene:[PlaySc node]]];
}

//when settings item is selected
- (void)onSettingsSelected:(id)sender
{
	//change scene to preferences scene
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[PreferencesSc node]]];
}

//help button pressed
- (void) onHelpSelected:(id)sender;
{
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[HelpSc node]]];
}

//credits button pressed
/*
- (void) onCreditsSelected:(id)sender;
{
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[CreditsSc node]]];
}
*/
@end
