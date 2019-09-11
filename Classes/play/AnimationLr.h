//
//  AnimationLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  All animation collected here
//  enemy organization and game logic here

#import <Foundation/Foundation.h>
#import "cocos2d.h" 
#import "CCTouchDispatcher.h"
#import "SimpleAudioEngine.h"
#import "EnemySp.h"
#import "LightningCl.h" 
#import "RainCl.h"
#import "LightningEffect.h"
#import "LevelDataCl.h"
#import "GameStateCl.h"
#import "ControlLr.h"
#import "LoosingScreenLr.h"
#import "WinningScreenLr.h"
#import "HollowLr.h"
#import "TreeSp.h"
#import "TornadoSp.h"
#import "SoundCl.h"
#import "GhostSp.h"
#import "TerrainLr.h"
#import "BubblesSp.h"

@interface AnimationLr : CCLayer 
{	
	int enemyCount; //current number of enemies
	NSMutableArray *enemyCollection; //current enemies array
	NSMutableArray *ghostCollection; //ghost array
	NSMutableArray *hollowCollection; //hollow array
	NSMutableArray *treeCollection; //tree array
	NSMutableArray *bubblesCollection; //ghost array
	
	ccTime totalTime; //layer/level total running time
	bool isGameStopped; //weather game is halted (stops animations controls etc (pause, loose, win))
	
	//effects
	LightningEffect	*lightningEff; //Draws lightning 
	CCParticleRain	*rainEmitter; //rain particle system
	TornadoSp *tornadoSprite; //tornado animation
	
	//enemy statuses to know who is not strated, who is in game and who out (there ar also similar statuses in sprite class)
	//wee need this becouse of start times that every enemy has different, and to know when all are destroyed
	int *enemyStatuses; //0 - not in game yet,1 - in game currently, 2 - off (reusable)
	int *responsibleObject; //will hold indexes in enemyCollection array that is responsible for appropriet enemy object
}

- (void) releaseGhost: (EnemySp*) tempEnemy;
- (void) releaseBubbles: (EnemySp*) tempEnemy;
- (void) markEnemyDestruction: (EnemySp*) tempEnemy;
- (void) createCloudsLayer;
//- (void) createWavingFlag;
@end
