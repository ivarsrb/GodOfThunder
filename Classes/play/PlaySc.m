//
//  PlaySc.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Main gameplay scene

#import "PlaySc.h"


@implementation PlaySc

- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 
		
		//reset elements at every level
		[[LightningCl sharedSingleton] reset];
		[[WindCl sharedSingleton] reset];
		[[RainCl sharedSingleton] reset];
		[[TornadoCl sharedSingleton] reset];
		
		//take next level, which is forst in this case
		[[LevelDataCl sharedSingleton] createLevel];
		
		
		//set background here
		CCSprite *bgSpr = [CCSprite spriteWithFile:@"play_bg_1.png"]; 
		bgSpr.position = ccp(winSize.width/2, winSize.height/2);
		//bgSpr.color = ccc3(180, 180, 180);
		bgSpr.color = ccc3((arc4random() % 75) + 180, 
						   (arc4random() % 75) + 180, 
						   (arc4random() % 75) + 180);
		
		[self addChild:bgSpr];
		
		
		//NSLog(@"-------------------- %d ----------------------",(arc4random() % 55) + 200);
		
		//add Animation/Game Logic layer
		AnimationLr *animLayer = [AnimationLr node];
		[self addChild:animLayer];
		
		//strat playing background msuic
		[[SoundCl sharedSingleton] playMusic: PLAY_MUS : YES];
	}
	return self;
}
@end
