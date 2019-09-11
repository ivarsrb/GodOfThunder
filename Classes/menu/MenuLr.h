//
//  MenuLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "PlaySc.h"
#import "GameStateCl.h"
#import "LevelDataCl.h"
#import "PreferencesSc.h"
#import "HelpSc.h"


@interface MenuLr : CCLayer {

}
- (void)onPlaySelected:(id)sender;
- (void)onContinueSelected:(id)sender;
- (void)onSettingsSelected:(id)sender;
- (void)onHelpSelected:(id)sender;
//- (void)onCreditsSelected:(id)sender;
@end
