//
//  TornadoCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Singleton
// Tornado management class

#import <Foundation/Foundation.h>
#import "SoundCl.h"


@interface TornadoCl : NSObject 
{
	float energy; //energy available at the moment for tornado
	float topEnergy; //maximum energy for rain
	float runPower; //how much energy is used at one tornado run
	
	int status; //0 - not started, 1 - moving
	
	float speed; //relative movement speed of tornado
}

@property (readonly) float energy;
@property (readonly) float speed;

+(TornadoCl*)sharedSingleton;

-(void) increaseEnergy: (float) energyStep;
-(void) increaseEnergyFromGhost;

-(void) reset;
-(void) setMoving;
-(void) setOff;
-(BOOL) isMoving;
-(BOOL) isOff;
-(BOOL) hasEnoughEnergy;

@end
