//
//  GameStateCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Singleton
// Put here anything else global

#import <Foundation/Foundation.h>

@interface GameStateCl : NSObject 
{
	int maxLevel; //number of final game level 
	int loosePoint; //point (px) to which loosing condition is considered (enemy reaches it)
	int continuedLevel; //number of level that user last time played, used to restore game
	BOOL isPaused; //weather game is paused, used when returning from som other app or phone call, not to resume
}

@property (readonly) int maxLevel;
@property (readonly) int loosePoint;
@property int continuedLevel;
@property BOOL isPaused;

+(GameStateCl*)sharedSingleton;


@end
