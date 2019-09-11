//
//  PreferencesSc.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PreferencesSc.h"


@implementation PreferencesSc

- (id) init
{
    self = [super init];
    if (self != nil) 
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 
		
		//set background here
		CCSprite *bgSpr = [CCSprite spriteWithFile:@"preferences_bg.png"]; 
        bgSpr.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:bgSpr];
		
		
		//Menu items ------------------------
		//create sound mute label
		CCLabel *soundLabel = [CCLabel labelWithString:@"Sound" fontName:@"Arial" fontSize:24.0];
        soundLabel.position = ccp(190,200);
		[soundLabel setColor:ccc3(255, 255, 255)]; 
		
		//create sound  switch
		// A button that toggles between two states
        sounOnItem = [[CCMenuItemImage itemFromNormalImage:@"butt_soundOn.png" selectedImage:@"butt_soundOn.png" target:nil selector:nil] retain];
        sounOffItem = [[CCMenuItemImage itemFromNormalImage:@"butt_soundOff.png" selectedImage:@"butt_soundOff.png" target:nil selector:nil] retain];
		//toggeler itself
		soundItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onOffSoundPressed:) items:sounOnItem,sounOffItem, nil] retain];
		
		//create prefs menu
		CCMenu *prefMenu = [CCMenu menuWithItems:soundItem, nil];
        prefMenu.position = ccp(280, 200);
		[prefMenu alignItemsVertically];

		
		//Save and exit menu -------
		/*
		CCMenuItemFont *menuItemSave = [CCMenuItemFont itemFromString:@"Save" target:self selector:@selector(onSaveSelected:)];
		[menuItemSave.label setColor:ccc3(50, 200, 50)];
		
		CCMenuItemFont *menuItemCancel = [CCMenuItemFont itemFromString:@"Cancel" target:self selector:@selector(onCancelSelected:)];
		[menuItemCancel.label setColor:ccc3(255, 20, 20)];
		*/
		
		//back button
		[CCMenuItemFont setFontSize:24];
		CCMenuItemFont *menuItemCancel = [CCMenuItemFont itemFromString:@"Back" target:self selector:@selector(onCancelSelected:)];
		[menuItemCancel.label setColor:ccc3(255, 20, 20)];
		
        CCMenu *menu = [CCMenu menuWithItems: menuItemCancel, nil];
        menu.position = ccp(winSize.width - 40, 24);
		[menu alignItemsHorizontallyWithPadding:60];
		
		//adding to scene
		[self addChild: prefMenu];
		[self addChild: soundLabel];
		[self addChild: menu];
		
		//set before-modified variables
		startSoundState = [[SoundCl sharedSingleton] turnedOff];
		//set sound switch to current
		if(startSoundState == NO) //not muted
			[soundItem setSelectedIndex:0]; 
		else 
			[soundItem setSelectedIndex:1]; 
	}
    return self;
}


//sound state button pressed
- (void) onOffSoundPressed:(id)sender 
{
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == sounOnItem) //sound is turned on
	{
		//start playing menu backroud music
		[[SoundCl sharedSingleton] setSoundOff: NO];
		[[SoundCl sharedSingleton] playMusic: MENU_MUS :YES];
		
		//save to user defaults
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setBool:[[SoundCl sharedSingleton] turnedOff] forKey:@"illSoundOff"];
		[prefs synchronize];
    } else if (toggleItem.selectedItem == sounOffItem) //sound is turned off
	{
		//stop music
		//[[SoundCl sharedSingleton] stopAllSounds];
		[[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
		[[SoundCl sharedSingleton] setSoundOff: YES];
		
		//save to user defaults
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setBool:[[SoundCl sharedSingleton] turnedOff] forKey:@"illSoundOff"];
		[prefs synchronize];
    }

}

//save user settings
- (void) onSaveSelected:(id)sender
{
	//save to user defaults
/*
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setBool:[[SoundCl sharedSingleton] turnedOff] forKey:@"illSoundOff"];
	[prefs synchronize];
	
	//back to main menu
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[MenuSc node]]];
*/
}

//cancel settings changes
- (void) onCancelSelected:(id)sender
{
	//set back values to original
	//[[SoundCl sharedSingleton] setSoundOff: startSoundState];
	
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[MenuSc node]]];
}


- (void)dealloc 
{
    [sounOnItem release];
    [sounOffItem release];
	[soundItem release];
	
	
    [super dealloc];
}

@end
