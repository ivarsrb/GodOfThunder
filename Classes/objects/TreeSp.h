//
//  TreeSp.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Tree object class. Rendered as sprite


#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelDataCl.h"
#import "RainCl.h"
#import "WindCl.h"

@interface TreeSp : CCNode {

	float status; //1 - alive, 2 - burning (non-walkable), 3 - gone
	BOOL swinging; //weather tree is swinging in wond, for animation only
	treeTypes treeType;
	//tree type dependant
	CGSize dimensions; //dimensions if tree itself, but not of sprite file
	ccTime burnTime; //time how long tree can be burned until dissapears 
	ccTime lastTime; //time when started burning
	ccTime totalTime; //total time of tree
	
	//CCSprite *treeSprite; //initial sprite used for animation
	//NSMutableString *treeFileName; //file name for tree sprite
	
	CCSprite *tInitSprite; //initial sprite used for animation
	CCSpriteSheet *tSpritesheet; //animation spritesheet 
	NSMutableString *animFileName; //file name for animation
	CCAnimation *tAnimation; //spritesheet animation
	
	
	int enemyQueue[MAX_ENEMY_TYPE_NUMBER]; //enemy queue that represents number of enemies that stand in front of burning tree
	
	CCParticleFire *fireEmitter; //burning particles
	
	//sound effects
	CDSoundSource* fireSS;
}
@property (readonly) CGSize dimensions;

-(void) setPositionByX: (float) x;

-(void) setOnFire;
-(void) setDestroyed: (int) destructionType;
-(void) setAlive;

-(BOOL) isAlive;
-(BOOL) isBurning;
-(BOOL) isDestroyed;

-(void) increaseQueue: (enemyTypes) eType;
-(void) descreaseQueue: (enemyTypes) eType;
-(void) clearQueues;
-(int) enemyQueue: (enemyTypes) eType;
-(void) startAnimSwing;
-(void) stopAnimSwing;

@end
