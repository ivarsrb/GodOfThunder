//
//  HelpSc.h
//  illapa
//
//  Created by Ivars Rusbergs on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  info and credits scene

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MenuSc.h"
#import "SoundCl.h"

@interface HelpSc : CCScene {

	CCSprite *bgSprH;
	CCSprite *bgSprS;
	CCSprite *bgSprC;
	
	//buttons
	CCMenuItem *howtoActiveItem; //item which is activated
    CCMenuItem *howtoDisabledItem; //disabled item
	CCMenuItemToggle *howtoItem; //toggle item includes both previous
	
	CCMenuItem *storyActiveItem; //item which is activated
    CCMenuItem *storyDisabledItem; //disabled item
	CCMenuItemToggle *storyItem; //toggle item includes both previous
	
	CCMenuItem *creditsActiveItem; //item which is activated
    CCMenuItem *creditsDisabledItem; //disabled item
	CCMenuItemToggle *creditsItem; //toggle item includes both previous
}

- (void) onCancelSelected:(id)sender;

- (void) onHowtoButtPressed:(id)sender;
- (void) onStoryButtPressed:(id)sender;
- (void) onCreditsButtPressed:(id)sender;

- (void) playPressSound;

@end
