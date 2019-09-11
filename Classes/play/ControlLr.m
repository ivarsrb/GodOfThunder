//
//  ControlLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ControlLr.h"


@implementation ControlLr

- (id) init
{
	self = [super init];
	if (self != nil)
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize];
		
		//game elemnt button configuration
		int menuMargSide = 20; //margin from sides
		int buttWidth = 64;
		int buttBorder = 6;
		int buttPadding = 10; //space between 2 buttons
		
		// Menus
		//Wind
		// A button that toggles between two states
        windActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_windA.png" selectedImage:@"butt_windA.png" target:nil selector:nil] retain];
        windDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_windD.png" selectedImage:@"butt_windD.png" target:nil selector:nil] retain];
		//toggeler itself
		windItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onWindButtPressed:) items:windDisabledItem,windActiveItem, nil] retain];
		
		//Lightning 
		// A button that toggles between two states
        lightActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_lightningA.png" selectedImage:@"butt_lightningA.png" target:nil selector:nil] retain];
        lightDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_lightningD.png" selectedImage:@"butt_lightningD.png" target:nil selector:nil] retain];
		//toggeler itself
		lightItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onLightButtPressed:) items:lightDisabledItem,lightActiveItem, nil] retain];
        
		//Rain 
		// A button that toggles between two states
        rainActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_rainA.png" selectedImage:@"butt_rainA.png" target:nil selector:nil] retain];
        rainDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_rainD.png" selectedImage:@"butt_rainD.png" target:nil selector:nil] retain];
		//toggeler itself
		rainItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onRainButtPressed:) items:rainDisabledItem,rainActiveItem, nil] retain];
		
		//Tornado 
		// A button that toggles between two states
        tornadoActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_tornadoA.png" selectedImage:@"butt_tornadoA.png" target:nil selector:nil] retain];
        tornadoDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_tornadoD.png" selectedImage:@"butt_tornadoD.png" target:nil selector:nil] retain];
		//toggeler itself
		tornadoItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onTornadoButtPressed:) items:tornadoDisabledItem,tornadoActiveItem, nil] retain];
		[tornadoItem setIsEnabled:NO]; //desabled bu default
		
		//--------------------------------------------------------
		
		//Color layers
		//wind
		windLayer = [CCColorLayer layerWithColor:ccc4(80, 80, 80, 200) width: (buttWidth - 2*buttBorder) height: 0];
		windLayer.position = ccp(menuMargSide+buttBorder, 308);
		lightLayer = [CCColorLayer layerWithColor:ccc4(80, 80, 80, 200) width: (buttWidth - 2*buttBorder) height: 0];
		lightLayer.position = ccp(menuMargSide+buttBorder+buttWidth+buttPadding, 308);
		rainLayer = [CCColorLayer layerWithColor:ccc4(80, 80, 80, 200) width: (buttWidth - 2*buttBorder) height: 0];
		rainLayer.position = ccp(winSize.width - menuMargSide - buttPadding - 2*buttWidth + buttBorder, 308);
		tornadoLayer = [CCColorLayer layerWithColor:ccc4(80, 80, 80, 200) width: (buttWidth - 2*buttBorder) height: 0];
		tornadoLayer.position = ccp(winSize.width - menuMargSide - buttWidth + buttBorder, 308);
		//--------------------------------------------------------
		
		//Overlays
		levelLabel = [CCLabel labelWithString:[NSMutableString stringWithFormat:@"City %d",[[LevelDataCl sharedSingleton] currentLevelID]] fontName:@"Marker Felt" fontSize:18.0];
        levelLabel.position = ccp(winSize.width/2,300);
		[levelLabel setColor:ccc3(255, 255, 0)];
		 
		pauseLabel = [CCLabel labelWithString:@"Paused" fontName:@"Arial" fontSize:18.0];
        pauseLabel.position = ccp(winSize.width/2,300);
		[pauseLabel setColor:ccc3(255, 10, 10)];
		[pauseLabel setVisible:NO];
		
		//menu for control buttons, one on the left, one on the right
		int halfMenu = (2*buttWidth+buttPadding)/2; //size of half of one button menu
		CCMenu *controlMenu = [CCMenu menuWithItems:windItem,lightItem, nil];
        controlMenu.position = ccp(halfMenu+menuMargSide, 282);
		
		CCMenu *controlMenu2 = [CCMenu menuWithItems:rainItem,tornadoItem, nil];
        controlMenu2.position = ccp(winSize.width - halfMenu - menuMargSide, 282);
		
		[controlMenu alignItemsHorizontallyWithPadding:buttPadding];
		[controlMenu2 alignItemsHorizontallyWithPadding:buttPadding];
		
		//pause and sound off menu
		//Pause 
		// A button that toggles between two states
        muteOnItem = [[CCMenuItemImage itemFromNormalImage:@"butt_muteOn.png" selectedImage:@"butt_muteOn.png" target:nil selector:nil] retain];
        muteOffItem = [[CCMenuItemImage itemFromNormalImage:@"butt_muteOff.png" selectedImage:@"butt_muteOff.png" target:nil selector:nil] retain];
		//toggeler itself
		muteItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onMuteButtPressed:) items:muteOffItem,muteOnItem, nil] retain];
		if([[SoundCl sharedSingleton] muted]) //if is muted
		{
			[muteItem setSelectedIndex:1];
		}
		
		//A button that toggles between two states
        pauseOnItem = [[CCMenuItemImage itemFromNormalImage:@"butt_pauseOn.png" selectedImage:@"butt_pauseOn.png" target:nil selector:nil] retain];
        pauseOffItem = [[CCMenuItemImage itemFromNormalImage:@"butt_pauseOff.png" selectedImage:@"butt_pauseOff.png" target:nil selector:nil] retain];
		//toggeler itself
		pauseItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onPauseButtPressed:) items:pauseOffItem,pauseOnItem, nil] retain];

		//return to menu button
		homeItem = [CCMenuItemImage itemFromNormalImage:@"butt_home.png" selectedImage:@"butt_homeA.png" target:self selector:@selector(onHomeButtPressed:)];
		
		
		//menu for sound and pause buttons
		CCMenu *settingsMenu;
		if([[SoundCl sharedSingleton] turnedOff]) //if sound is turned off in setting, only pause
			settingsMenu = [CCMenu menuWithItems:pauseItem,homeItem,nil];	
		else
			settingsMenu = [CCMenu menuWithItems:muteItem,pauseItem,homeItem,nil];
        //settingsMenu.position = ccp(410, 22);
		settingsMenu.position = ccp(winSize.width/2,270);
		[settingsMenu alignItemsHorizontallyWithPadding:14];
		
		//marker that will show that tornado is activated (ready for use)
		tornadoMarkerSpr = [CCSprite spriteWithFile:@"butt_tornadoM.png"]; 
		tornadoMarkerSpr.anchorPoint = ccp(0.25,0.0);
		tornadoMarkerSpr.position = ccp(winSize.width - halfMenu, 250); //TODO when changing button height, dont forget to change this
		tornadoMarkerSpr.visible = NO;
		
		//marker for user to know when only one strike is left
		lightningMarkerSpr = [CCSprite spriteWithFile:@"butt_lightningD.png"]; ;
		lightningMarkerSpr.anchorPoint = ccp(0.0,0.0);
		lightningMarkerSpr.position = ccp(buttWidth+buttPadding+menuMargSide, 250); //TODO when changing button height, dont forget to change this
		lightningMarkerSpr.visible = NO;
		lightMarkerAct = [[CCRepeatForever actionWithAction: [CCBlink actionWithDuration:0.2 blinks:1]] retain];
		
		//adding to layer
		[self addChild: controlMenu];
		[self addChild: controlMenu2];
		
		[self addChild: settingsMenu];
		
		[self addChild: windLayer z:2];
		[self addChild: rainLayer z:2];
		[self addChild: lightLayer z:2];
		[self addChild: tornadoLayer z:2];
		
		[self addChild: levelLabel];
		[self addChild: pauseLabel];
		
		[self addChild: tornadoMarkerSpr]; 
		[self addChild: lightningMarkerSpr]; 
		
		//set function for updating
		[self schedule:@selector(update:)];
	}
	return self;
}


//mute button pressed
- (void)onMuteButtPressed:(id)sender
{
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == muteOnItem) //turn  on
	{
		[[SoundCl sharedSingleton] setSoundMutedState:YES];
    } else if (toggleItem.selectedItem == muteOffItem) //turn  off
	{
		[[SoundCl sharedSingleton] setSoundMutedState:NO];
    }
}

//home button pressed
- (void) onHomeButtPressed:(id)sender
{
	[[SoundCl sharedSingleton] stopAllSounds];
	[[LevelDataCl sharedSingleton] destroyLevel];
	
	//change scene to menu scene
	[[CCDirector sharedDirector] replaceScene:[CCFadeTransition transitionWithDuration:0.5 scene:[MenuSc node]]];
}


//pause button pressed
//When paused Disable touch event and disable game buttons
- (void)onPauseButtPressed:(id)sender
{
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == pauseOnItem) //turn  on
	{
		[[CCDirector sharedDirector] pause]; //pause game
        [windItem setIsEnabled:NO];
		[lightItem setIsEnabled:NO];
		[rainItem setIsEnabled:NO];
		[tornadoItem setIsEnabled:NO];
		[muteItem setIsEnabled:NO];
		[homeItem setIsEnabled:NO];
		
		//stop sounds when paused
		if(![[SoundCl sharedSingleton] muted] && ![[SoundCl sharedSingleton] turnedOff]) //if not off already
			[[SoundCl sharedSingleton] simpleMute:YES];
		
		//change labels
		[levelLabel setVisible:NO];
		[pauseLabel setVisible:YES];
		
		[[GameStateCl sharedSingleton] setIsPaused:YES]; //mark as paused (used when app loses focus and the resumes active, not to resume game if was paused)
		
    } else if (toggleItem.selectedItem == pauseOffItem) //turn  off
	{
		[[CCDirector sharedDirector] resume]; //resume game
		[windItem setIsEnabled:YES];
		[lightItem setIsEnabled:YES];
		[rainItem setIsEnabled:YES];
		[tornadoItem setIsEnabled:YES];
		[muteItem setIsEnabled:YES];
		[homeItem setIsEnabled:YES];
		
		//turnd sound back on
		if(![[SoundCl sharedSingleton] muted] && ![[SoundCl sharedSingleton] turnedOff]) //if not off already
			[[SoundCl sharedSingleton] simpleMute:NO];
		
		//change labels
		[pauseLabel setVisible:NO];
		[levelLabel setVisible:YES];
		
		[[GameStateCl sharedSingleton] setIsPaused:NO];
    }
}



//wind button pressed
- (void)onWindButtPressed:(id)sender 
{
	
	[self playPressSound];
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;	
    if (toggleItem.selectedItem == windActiveItem) //turn wind on
	{
		[[WindCl sharedSingleton] startBlowing];
    } else if (toggleItem.selectedItem == windDisabledItem) //turn wind off
	{
		[[WindCl sharedSingleton] stopBlowing];
    }
}

//light button pressed
- (void)onLightButtPressed:(id)sender 
{
	[self playPressSound];
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == lightActiveItem) //turn lightning mode on
	{
		[[LightningCl sharedSingleton] setReadyToStrike:YES];
    } else if (toggleItem.selectedItem == lightDisabledItem) //turn wind off
	{
		[[LightningCl sharedSingleton] setReadyToStrike:NO];
    }
}


//rain button pressed
- (void)onRainButtPressed:(id)sender 
{
	[self playPressSound];
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == rainActiveItem) //turn rain mode on
	{
		[[RainCl sharedSingleton] setReadyForRain];
    } else if (toggleItem.selectedItem == rainDisabledItem) //turn wind off
	{
		[[RainCl sharedSingleton] cancelRain];
    }
}

//rain button pressed
- (void)onTornadoButtPressed:(id)sender 
{
	[self playPressSound];
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;
    if (toggleItem.selectedItem == tornadoActiveItem) 
	{
		[[TornadoCl sharedSingleton] setMoving];
    } else if (toggleItem.selectedItem == tornadoDisabledItem) //turn tornado off
	{
		[[TornadoCl sharedSingleton] setOff];
		[tornadoItem setIsEnabled:NO];
    }
	/*
	else
	{
		[tornadoItem setSelectedIndex:0]; //set back to disabled
	}
    */
}

//for element button sound only
- (void) playPressSound
{
	[[SoundCl sharedSingleton] playSound: BUTTON_PRESS_EFF loop:NO];
}


//update regeneration logic here
- (void) update:(ccTime)dt
{
	if(![[LevelDataCl sharedSingleton] levelInitialized])
		return;
	
	//update wind energy
	if([[WindCl sharedSingleton] updateEnergy : dt])
	{
		//ran out of energy
		[[WindCl sharedSingleton] stopBlowing];
		[windItem setSelectedIndex:0]; //set back to disabled
	}
	//[windLabel setString:[NSMutableString stringWithFormat:@"%.0f",[[WindCl sharedSingleton] energy]]]; 
	[windLayer changeHeight:(100 - [[WindCl sharedSingleton] energy]) * -0.52];
	
	
	//update lightning energy
	if([[LightningCl sharedSingleton] updateEnergy : dt])
	{
		[[LightningCl sharedSingleton] setReadyToStrike:NO];
		[lightItem setSelectedIndex:0]; //set back to disabled
		[lightItem setIsEnabled:NO]; //when out of energy disable item
	}else {
		if(![lightItem isEnabled]) //if there is enaugh power to do atleast one strike
			[lightItem setIsEnabled:YES]; //enable button
	}
	//strike energy warning
	if([[LightningCl sharedSingleton] energyForStrikes] == 1 &&
	   [[LightningCl sharedSingleton] readyToStrike]) //only one stirke possible now
	{
		if(![lightningMarkerSpr numberOfRunningActions])
		{
			lightningMarkerSpr.visible = YES;
			[lightningMarkerSpr runAction:lightMarkerAct]; //run blinking action
		}
	}else
	{
		if([lightningMarkerSpr numberOfRunningActions]) //put back
		{
			lightningMarkerSpr.visible = NO;
			[lightningMarkerSpr stopAllActions];
		}	
	}
	

	//[lightLabel setString:[NSMutableString stringWithFormat:@"%.0f",[[LightningCl sharedSingleton] energy]]]; 
	[lightLayer changeHeight:(100 - [[LightningCl sharedSingleton] energy]) * -0.52];
	
	//update rain energy
	if([[RainCl sharedSingleton] updateEnergy : dt])
	{
		[[RainCl sharedSingleton] cancelRain];
		[rainItem setSelectedIndex:0]; //set back to disabled
	}
	//[rainLabel setString:[NSMutableString stringWithFormat:@"%.0f",[[RainCl sharedSingleton] energy]]]; 
	[rainLayer changeHeight:(100 - [[RainCl sharedSingleton] energy]) * -0.52];
	
	//update tornado energy statsš
	//when tornado is off, set it disabled
	if([[TornadoCl sharedSingleton] isOff] && tornadoItem.selectedItem == tornadoActiveItem)
	{
		[tornadoItem setSelectedIndex:0]; //set back to disabled
		[tornadoItem setIsEnabled:NO]; //desabled bu default
	}
	if([[TornadoCl sharedSingleton] hasEnoughEnergy] && ![tornadoItem isEnabled]) //enaight to start off
	{
		[tornadoItem setIsEnabled:YES]; //set so we an use it
		
		//blink, so user can see that tonrado is ready
		[tornadoMarkerSpr runAction:[CCSequence actions: 
						 [CCShow action],
						 [CCBlink actionWithDuration:1.2 blinks:3],
						 //[CCFadeOut actionWithDuration:0.5], 
						 [CCCallFunc actionWithTarget:self selector:@selector(onTornadoMarkerEnd)],
						 nil]
		 ];
	}
		
	//[tornadoLabel setString:[NSMutableString stringWithFormat:@"%.0f",[[TornadoCl sharedSingleton] energy]]]; 
	[tornadoLayer changeHeight:(100 - [[TornadoCl sharedSingleton] energy]) * -0.52];
}
-(void) onTornadoMarkerEnd
{
	tornadoMarkerSpr.visible = NO;
}


//turn off buttons that are on, withou given button
//only tonado button is not affected by others
//0 - turn all off, keep 1 - wind, 2 - lightning, 3 - rain
/*
- (void) turnOffButtons: (int) excButtonType
{
	//wind
	if(excButtonType != 1 && windItem.selectedItem == windActiveItem)
	{
		[[WindCl sharedSingleton] stopBlowing];
		[windItem setSelectedIndex:0]; //set back to disabled
	}
	//lightning
	if(excButtonType != 2 && lightItem.selectedItem == lightActiveItem)
	{
		[[LightningCl sharedSingleton] setReadyToStrike:NO];
		[lightItem setSelectedIndex:0]; //set back to disabled
	}
	//rain
	if(excButtonType != 3 && rainItem.selectedItem == rainActiveItem)
	{
		[[RainCl sharedSingleton] cancelRain];
		[rainItem setSelectedIndex:0]; //set back to disabled
	}
}
*/

- (void)dealloc 
{
    [windActiveItem release];
    [windDisabledItem release];
	[windItem release];

	[lightActiveItem release];
    [lightDisabledItem release];
	[lightItem release];
	
	[rainActiveItem release];
    [rainDisabledItem release];
	[rainItem release];

	[tornadoActiveItem release];
    [tornadoDisabledItem release];
	[tornadoItem release];
	
	[muteOnItem release];
    [muteOffItem release];
	[muteItem release];
	
	[pauseOnItem release];
    [pauseOffItem release];
	[pauseItem release];
	
	[lightMarkerAct release];
	
    [super dealloc];
}


@end
