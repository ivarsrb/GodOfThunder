//
//  SoundCl.h
//  illapa
//
//  Created by Ivars Rusbergs on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
// Singleton
// Is used to manage sound and music in game 

//------------  MODIFIED ----------------

//
// "SimpleAudioEngine.h" 
// Added function
// -(void) stopAllSounds{
//  	[soundEngine stopAllSounds];
// }	
//
//----------------------------------------

#import <Foundation/Foundation.h>
#import "CocosDenshion.h"
#import "SimpleAudioEngine.h"


//types of sound effects and music in game
//Dont forget to integrate sounds into sound class
typedef enum {
	LIGHTNING_EFF = 1,
	RAIN_EFF = 2,
	WIND_EFF = 3,
	TORNADO_EFF = 4,
	FIRE_EFF = 5,
	SCREAM_EFF = 6,
	GHOST_PICK_EFF = 7,
	BUTTON_PRESS_EFF = 8,
	DROWN_EFF = 9,
	SCREAM_HORSE_EFF = 10,
	LIGHTNING_1_EFF = 11,
	BLOW_UP_EFF = 12
	
} soundTypes;

typedef enum {
	MENU_MUS = 1,
	PLAY_MUS = 2,
	LOOSE_MUS = 3,
	WINNING_MUS = 4
} musicTypes;

@interface SoundCl : NSObject 
{
	//looping sound effects
	CDSoundSource* rainSS;
	CDSoundSource* windSS;
	CDSoundSource* tornadoSS;
	
	//mute - cam be set only runtime, and does not save
	BOOL muted; //weather all sounds and music are muted (but not turned off, music still plays but can not be heard)
	BOOL turnedOff;//weather sounds playing methods ar called 
	
}

@property (readonly) BOOL muted;
@property (readonly) BOOL turnedOff;

+(SoundCl*)sharedSingleton;

- (void) loadSounds;
- (void) playSound: (soundTypes) sType loop:(BOOL) loop;
- (void) stopSound: (soundTypes) sType;
- (void) playMusic: (musicTypes) mType :(BOOL) looping;
- (void) stopAllSounds;
- (void) setSoundMutedState: (BOOL) mValue;
- (void) setSoundOff: (BOOL) mValue;
- (void) playGivenSound: (CDSoundSource*) ss;
- (void) stopGivenSound: (CDSoundSource*) ss;
- (void) simpleMute: (BOOL)mValue;
@end
