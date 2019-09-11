//
//  LoosingScreenLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Layer of screen which shows when game is lost

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameStateCl.h"
#import "LevelDataCl.h"
#import "MenuSc.h"
#import "SoundCl.h"

@interface LoosingScreenLr : CCLayer
{
	CCParticleSmoke *smokeEmitter; //burning particles

}

- (void)onContinueSelected:(id)sender;

@end
