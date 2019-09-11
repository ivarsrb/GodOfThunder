//
//  WindCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Singleton
// Wind management class

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoundCl.h"

@interface WindCl : NSObject 
{
	//wind params
	float windSpeed; //relative number to decrease speed
    float energy;    //counter whichc determines how long wind can blow
    float topEnergy; //maximum possible energy
    float decreaser; //loss of energy
    float increaser; //renewal
	bool  blowing;   //Yes - wind on, No - wind off
}

@property (readonly) float energy;
@property (readonly) float windSpeed;
@property (readonly) bool blowing;

+(WindCl*)sharedSingleton;
-(int) updateEnergy:(ccTime) dt;
-(void) reset;

-(void) startBlowing;
-(void) stopBlowing;

-(void) increaseEnergy: (float) energyStep;
-(void) increaseEnergyFromGhost;

@end
