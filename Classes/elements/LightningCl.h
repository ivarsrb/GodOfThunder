//
//  LightningCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Singleton
//  Lightning management class

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SoundCl.h"

@interface LightningCl : NSObject 
{
	bool readyToStrike; //in striking mode if YES
	float energy;       //energy available for strikes
	float topEnergy;    //maximum energy for strikes
	float strikePower;  //how mutch energy one strike takes
	float increaser;    //renewal
	
}
@property bool readyToStrike;
@property (readonly) float energy;

+(LightningCl*)sharedSingleton;

-(int) updateEnergy:(ccTime) dt;
-(void) strike: (BOOL) saveEnergy;
-(void) reset;

-(void) increaseEnergy: (float) energyStep;
-(int) energyForStrikes;
//-(void) increaseEnergyFromGhost;

@end
