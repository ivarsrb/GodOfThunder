//
//  WinningScreenLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Layer of screen which shows when game level/game is won

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameStateCl.h"
#import "LevelDataCl.h"
#import "PlaySc.h"
#import "SoundCl.h"

@interface WinningScreenLr : CCLayer
{

}
- (void)onContinueSelected:(id)sender;
@end
