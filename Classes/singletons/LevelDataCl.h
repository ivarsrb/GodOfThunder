//
//  LevelDataCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Singleton
// All the data that is relevant for particular game level
// Data must be reloaded before every level

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "FileManagementCl.h"
#import "GameStateCl.h"

//types of enemies in game
typedef enum {
	INFANTRY = 1,
	CAVALRY = 2,
	MAX_ENEMY_TYPE_NUMBER = 2 //this holds count of enemy types
} enemyTypes;

typedef enum {
	TREE_1 = 1,
	TREE_2 = 2
} treeTypes;

/*
//type that holds left and right index of something (used in hollow definition)
typedef struct {
	int indexRight;
	int indexLeft;
} indexType;
*/

@interface LevelDataCl : NSObject 
{
	//general
	bool levelInitialized; //shows when level is set, for checking purposes
	int currentLevelID; //id of current level
	NSMutableString *levelFileName; //file name for current level (.plist not needed)
	
	//terrain relevant
	int sectionCount;   //sections in terrain
	int heightMapWidth; //number of heightpoints in map (section count + 1)
	float *heightMap;   //terrain representation array  with heights in each point
	float groundBase;   //pixels for the ground base to be (lower possible part of terrain)
	
	int enemyCount; //total enemy count in given level
	float *enemyTriggerTime; //start times for enemies (seconds from totoal time, when enemy ahs to start)
	enemyTypes *enemyContents; //how many and what type of enemies there will be
	
	NSMutableArray *hollowsIndexes; //pairs of hollows ids from heightmap array
	NSMutableArray *treeCollections; //array - position of tree and type of tree
}

@property (readonly) int sectionCount;
@property (readonly) int heightMapWidth;
@property (readonly) float * heightMap;
@property (readonly) int enemyCount;
@property (readonly) float * enemyTriggerTime;
@property (readonly) enemyTypes * enemyContents;
@property (readonly) NSMutableArray *hollowsIndexes;
@property (readonly) NSMutableArray *treeCollections;
@property (readonly) bool levelInitialized;
@property (readonly) int currentLevelID;
@property (readonly) float groundBase;

+(LevelDataCl*)sharedSingleton;

-(void) createLevel;
-(void) destroyLevel;
-(void) reset;
-(BOOL) isLevelFinal;
-(void) getHollowsIds;
-(void) setCurrentLevel: (int) curLevId;
-(void) saveCurrentLevelToDefaults: (int) curLevId;
//terrain helper functions
-(float) getHeightByX: (float) x;
-(float) getTerrAngleByX: (float) x;



@end
