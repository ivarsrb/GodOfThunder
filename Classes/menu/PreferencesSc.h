//
//  PreferencesSc.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/22/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// User preferences scene

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoundCl.h"
#import "MenuSc.h"

@interface PreferencesSc : CCScene 
{
    //sound mute item
	CCMenuItem *sounOnItem;
    CCMenuItem *sounOffItem;
	CCMenuItemToggle *soundItem;
	BOOL startSoundState; //sound  state in what it was when entering Settings screen
}

- (void) onOffSoundPressed:(id)sender;
- (void) onSaveSelected:(id)sender;
- (void) onCancelSelected:(id)sender;

@end
