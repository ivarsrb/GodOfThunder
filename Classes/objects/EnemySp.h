//
//  EnemySp.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Enemy class that is rendered as sprites
//  All enemy actions graphics and properties here

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TerrainLr.h"
#import "LevelDataCl.h"
#import "WindCl.h"
#import "SoundCl.h"

@interface EnemySp : CCNode { //CCSprite was before
	enemyTypes enemyType; //type of enemy
	int status; // 0 - alive has not started, 1 - alive moving, 
				// 2 - alive, has stopped, 3 - festroyed
	int walkStatus; //0 - free walk, 1 - wind crawl
	//enemy type dependant
	CGSize dimensions; //dimensions if enemy itself, but not of sprite file
	float speed; //relative movement speed (can change over time)
    float startSpeed; // will hold the start speed of enemy, to recover it later
	float oreintationAngle; //angle in which some enemies ar oriented against terrain
	float drownHeight; //point where enemy drowns
	float hitExtra; //stores extra pixels to all 4 sides, that user can hit enemy
	
	//walking
	CCSprite *walkInitSprite; //initial sprite used for animation
	CCSpriteSheet *walkSpritesheet; //animation spritesheet 
	NSMutableString *walkAnimFileName; //file name for animation
	CCAnimation *walkAnimation; //spritesheet animation
	
	//crawling in wind force
	NSMutableString *crawlAnimFileName; //file name for animation
	CCSprite *crawlInitSprite; //initial sprite used for animation
	CCSpriteSheet *crawlSpritesheet; //animation spritesheet 
	CCAnimation *crawlAnimation; //spritesheet animation
	
	BOOL objectFreeToReuse; //weather object is free to reuse, means all actions are off, invisible, uneeded
	
	BOOL stoppedByTree; //hold index of tree to which enemy is stopped right now, if no tree: '-1'
}

@property (readonly) CGSize dimensions;
@property (readonly) enemyTypes enemyType;
@property (readonly) float drownHeight;
@property (readonly) float hitExtra;
@property (readonly) BOOL objectFreeToReuse;
@property BOOL stoppedByTree;

- (id) initWithType: (int) eType;

-(void) setPositionByX: (float) x;
-(void) startAnimWalk;
-(void) startAnimCrawl;
-(void) stopAnimWalk;
-(void) stopAnimCrawl;

-(void) startMovement;
-(void) stopMovement;

-(void) recieveWind: (float) decreaser; 
-(void) freeMovement;
-(void) setDestroyed: (int) destructionType;
-(void) reset; 


-(BOOL)	hasNotStarted;
-(BOOL) isMoving;
-(BOOL) isAlive;
-(BOOL) isInGame;
-(BOOL) isStopped;

-(BOOL) isFreeWalk;
-(BOOL) isWindCrawl;

-(void) setSpriteAnimWalk: (NSMutableString*) fileName;
-(void) setSpriteAnimCrawl: (NSMutableString*) fileName;


@end
