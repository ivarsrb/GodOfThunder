//
//  RainCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/6/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Singleton
//  Rain management class

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoundCl.h"

@interface RainCl : NSObject 
{
	float energy; //energy available at the moment for rain
	float topEnergy; //maximum energy for rain
	int status; //0 - still, 1 - ready to rain, 2 - rain being dragged, 3 - raining
	float decreaser; //loss of energy
	float increaser; //renewal
	
	CGPoint rainPos1; //one side of rain width (can be left or right !!!!!)
	CGPoint rainPos2; //some other sode of rain
}

@property (readonly) float energy;
@property CGPoint rainPos1;
@property CGPoint rainPos2;

+(RainCl*)sharedSingleton;

-(int) updateEnergy:(ccTime) dt;
-(void) reset;
-(BOOL) canRain;
-(BOOL) isRainStopped;
-(BOOL) readyForRain;
-(BOOL) isRaining;
-(BOOL) isBeingDragged;

-(void) setReadyForRain;
-(void) setRain;
-(void) cancelRain;
-(void) setRainDrag;

-(void) increaseEnergy: (float) energyStep;
-(void) increaseEnergyFromGhost;

@end
