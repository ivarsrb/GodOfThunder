//
//  ControlLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/25/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Will hold buttons for weather and game control stuff

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "WindCl.h"
#import "LightningCl.h"
#import "RainCl.h"
#import "TornadoCl.h"
#import "LevelDataCl.h"
#import "PlaySc.h"
#import "SoundCl.h"
#import "GameStateCl.h"
#import "MenuSc.h"

@interface ControlLr : CCLayer {
    //wind button
	CCMenuItem *windActiveItem; //item which is activated
    CCMenuItem *windDisabledItem; //disabled item
	CCMenuItemToggle *windItem; //toggle item includes both previous
	CCColorLayer *windLayer; //color layer for button
	
	//lightning button
	CCMenuItem *lightActiveItem; //item which is activated
    CCMenuItem *lightDisabledItem; //disabled item
	CCMenuItemToggle *lightItem; //toggle item includes both previous
	CCColorLayer *lightLayer; //color layer for button
	
	//rain button
	CCMenuItem *rainActiveItem; //item which is activated
    CCMenuItem *rainDisabledItem; //disabled item
	CCMenuItemToggle *rainItem; //toggle item includes both previous
	CCColorLayer *rainLayer; //color layer for button
	
	//tornado button
	CCMenuItem *tornadoActiveItem; //item which is activated
    CCMenuItem *tornadoDisabledItem; //disabled item
	CCMenuItemToggle *tornadoItem; //toggle item includes both previous
	CCColorLayer *tornadoLayer; //color layer for button
	
	//pause and sound off
	CCMenuItem *muteOnItem; //item which is on
    CCMenuItem *muteOffItem; //item off
	CCMenuItemToggle *muteItem; //toggle item includes both previous
	
	CCMenuItem *pauseOnItem; //item which is on
    CCMenuItem *pauseOffItem; //item off
	CCMenuItemToggle *pauseItem; //toggle item includes both previous
	
	CCMenuItem *homeItem;
	
	//labels
	CCLabel *levelLabel;
	CCLabel *pauseLabel;
	
	CCSprite *tornadoMarkerSpr;
	CCSprite *lightningMarkerSpr;
	CCAction *lightMarkerAct;
}

- (void)onWindButtPressed:(id)sender;
- (void)onLightButtPressed:(id)sender;
- (void)onRainButtPressed:(id)sender;
- (void)onTornadoButtPressed:(id)sender;

- (void)onMuteButtPressed:(id)sender;
- (void)onPauseButtPressed:(id)sender;
- (void)onHomeButtPressed:(id)sender;
- (void) onTornadoMarkerEnd;

- (void) playPressSound;

//- (void) turnOffButtons: (int) excButtonType;

@end
