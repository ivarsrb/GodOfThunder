//
//  GodOfThunderAppDelegate.h
//  GodOfThunder
//
//  Created by Ivars Rusbergs on 6/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "cocos2d.h"
#import "MenuSc.h"
#import "SoundCl.h"
#import "GameStateCl.h"

@interface GodOfThunderAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
}

@property (nonatomic, retain) UIWindow *window;

- (void) retrieveUserSettings;

@end
