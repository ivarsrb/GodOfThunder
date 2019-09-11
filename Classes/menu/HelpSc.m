//
//  HelpSc.m
//  illapa
//
//  Created by Ivars Rusbergs on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HelpSc.h"


@implementation HelpSc
- (id) init
{
    self = [super init];
    if (self != nil) 
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 
		
		//add all backgrounds
		bgSprH = [CCSprite spriteWithFile:@"howto_bg.png"]; 
        bgSprH.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSprH];
		
		bgSprS = [CCSprite spriteWithFile:@"story_bg.png"]; 
        bgSprS.position = ccp(winSize.width/2, winSize.height/2);
        bgSprS.visible = NO; //hide uneeded by default
		[self addChild:bgSprS];
		
		bgSprC = [CCSprite spriteWithFile:@"credits_bg.png"]; 
        bgSprC.position = ccp(winSize.width/2, winSize.height/2);
		bgSprC.visible = NO;
        [self addChild:bgSprC];
		
		
		//add toggle buttons
		//Wind
		// A button that toggles between two states
        howtoActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_howtoA.png" selectedImage:@"butt_howtoA.png" target:nil selector:nil] retain];
        howtoDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_howtoD.png" selectedImage:@"butt_howtoD.png" target:nil selector:nil] retain];
		//toggeler itself
		howtoItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onHowtoButtPressed:) items:howtoActiveItem,howtoDisabledItem, nil] retain];
		[howtoItem setIsEnabled:NO]; //by default
		
		storyActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_storyA.png" selectedImage:@"butt_storyA.png" target:nil selector:nil] retain];
        storyDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_storyD.png" selectedImage:@"butt_storyD.png" target:nil selector:nil] retain];
		//toggeler itself
		storyItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onStoryButtPressed:) items:storyActiveItem,storyDisabledItem, nil] retain];
		[storyItem setSelectedIndex:1]; 
		
		creditsActiveItem = [[CCMenuItemImage itemFromNormalImage:@"butt_creditsA.png" selectedImage:@"butt_creditsA.png" target:nil selector:nil] retain];
        creditsDisabledItem = [[CCMenuItemImage itemFromNormalImage:@"butt_creditsD.png" selectedImage:@"butt_creditsD.png" target:nil selector:nil] retain];
		//toggeler itself
		creditsItem = [[CCMenuItemToggle itemWithTarget:self selector:@selector(onCreditsButtPressed:) items:creditsActiveItem,creditsDisabledItem, nil] retain];
		[creditsItem setSelectedIndex:1];
		
		//menu for items
		CCMenu *controlMenu = [CCMenu menuWithItems:howtoItem,storyItem,creditsItem, nil];
        //controlMenu.anchorPoint = ccp(0,0);
		controlMenu.position = ccp(winSize.width / 2, 297);
		[controlMenu alignItemsHorizontallyWithPadding:7];
		[self addChild: controlMenu];
		
		
		//Back -------
		[CCMenuItemFont setFontSize:24];
		CCMenuItemFont *menuItemCancel = [CCMenuItemFont itemFromString:@"Back" target:self selector:@selector(onCancelSelected:)];
		[menuItemCancel.label setColor:ccc3(255, 20, 20)];
		
        CCMenu *menu = [CCMenu menuWithItems:menuItemCancel, nil];
        menu.position = ccp(winSize.width - 40, 20);
		
		//adding to scene
		[self addChild: menu];
	}
    return self;
}


//go back
- (void) onCancelSelected:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[MenuSc node]]];
}

//howto pressed
- (void) onHowtoButtPressed:(id)sender
{
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;	
    if (toggleItem.selectedItem == howtoActiveItem) //turn wind on
	{
		[self playPressSound];
		
		//change text background
		bgSprH.visible = YES;
		bgSprS.visible = NO;
		bgSprC.visible = NO;
		
		//dont allow to press twice
		[howtoItem setIsEnabled:NO];
		[storyItem setIsEnabled:YES];
		[creditsItem setIsEnabled:YES];
		
		//clear other selcted item
		[storyItem setSelectedIndex:1]; 
		[creditsItem setSelectedIndex:1]; 
    } else if (toggleItem.selectedItem == howtoDisabledItem) //turn wind off
	{
		
    }
}

//story pressed
- (void) onStoryButtPressed:(id)sender
{
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;	
    if (toggleItem.selectedItem == storyActiveItem) //turn wind on
	{
		[self playPressSound];
		bgSprH.visible = NO;
		bgSprS.visible = YES;
		bgSprC.visible = NO;
		
		[howtoItem setIsEnabled:YES];
		[storyItem setIsEnabled:NO];
		[creditsItem setIsEnabled:YES];
		
		[howtoItem setSelectedIndex:1]; 
		[creditsItem setSelectedIndex:1];
    } else if (toggleItem.selectedItem == storyDisabledItem) //turn wind off
	{
		
    }
	
}

//credits pressed
- (void) onCreditsButtPressed:(id)sender
{
	CCMenuItemToggle *toggleItem = (CCMenuItemToggle *)sender;	
    if (toggleItem.selectedItem == creditsActiveItem) //turn wind on
	{
		[self playPressSound];
		bgSprH.visible = NO;
		bgSprS.visible = NO;
		bgSprC.visible = YES;
		
		[howtoItem setIsEnabled:YES];
		[storyItem setIsEnabled:YES];
		[creditsItem setIsEnabled:NO];
		
		[howtoItem setSelectedIndex:1]; 
		[storyItem setSelectedIndex:1];
		
    } else if (toggleItem.selectedItem == creditsDisabledItem) //turn wind off
	{
		
    }
}

//for element button sound only
- (void) playPressSound
{
	[[SoundCl sharedSingleton] playSound: BUTTON_PRESS_EFF loop:NO];
}


- (void)dealloc 
{
    [howtoActiveItem release];
    [howtoDisabledItem release];
	[howtoItem release];

    [storyActiveItem release];
    [storyDisabledItem release];
	[storyItem release];
	
	[creditsActiveItem release];
    [creditsDisabledItem release];
	[creditsItem release];

    [super dealloc];
}

@end
