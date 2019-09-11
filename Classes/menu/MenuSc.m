//
//  MenuSc.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//	Main menu scene


#import "MenuSc.h"

@implementation MenuSc
- (id) init
{
    self = [super init];
    if (self != nil) {
		
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 
		
		glClearColor(0,0,0,255); //background color
		
		//set background here
		CCSprite *bgSpr = [CCSprite spriteWithFile:@"menu_bg.png"]; 
        bgSpr.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:bgSpr];
		
		//add menu list layer to menu scene
		MenuLr *menuLayer = [MenuLr node];  //TODO: no need for this variable
        [self addChild:menuLayer];
		
		//load sound on menu
		//[[SoundCl sharedSingleton] loadSounds];
		//if sound is muted, unmute it
		if([[SoundCl sharedSingleton] muted])
			[[SoundCl sharedSingleton] setSoundMutedState:NO];
		//start playing menu backroud music
		[[SoundCl sharedSingleton] playMusic: MENU_MUS :YES];
		
	}
    return self;
}



@end
