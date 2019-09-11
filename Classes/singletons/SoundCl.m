//
//  SoundCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SoundCl.h"


@implementation SoundCl

static SoundCl* _sharedSingleton = nil;

+(SoundCl*)sharedSingleton
{
	@synchronized([SoundCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([SoundCl class])
	{
		NSAssert(_sharedSingleton == nil, @"SoundCl: Attempted to allocate a second instance of a singleton.");
		_sharedSingleton = [super alloc];
		return _sharedSingleton;
	}
	
	return nil;
}


- (id) init
{
	self = [super init];
	if (self != nil) 
	{
		muted = NO;
		
		[self loadSounds];
		

	}
	return self;
}

// prelounds sound effects and music to use later
- (void) loadSounds
{
	//load sounds
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"lightning.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"lightning_1.wav"];
	///[[SimpleAudioEngine sharedEngine] preloadEffect:@"rain.wav"];
	//[[SimpleAudioEngine sharedEngine] preloadEffect:@"wind.wav"];
	//[[SimpleAudioEngine sharedEngine] preloadEffect:@"tornado.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"fire.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"screame.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"ghost_pick.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"button_press.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"bubbles.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"scream_horse.wav"];
	[[SimpleAudioEngine sharedEngine] preloadEffect:@"blow_up.wav"];
	
	//load music
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"play_music.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"menu_music.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"loose_music.mp3"];
	[[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"winning_music.mp3"];
	
	//init for looping sounds
	//fire sound is set for every tree in tree class
	rainSS = [[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"rain.wav"] retain];
	windSS = [[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"wind.wav"] retain];
	tornadoSS = [[[SimpleAudioEngine sharedEngine] soundSourceForFile:@"tornado.wav"] retain];
	
	[rainSS setLooping: YES];
	[windSS setLooping: YES];
	[tornadoSS setLooping: YES];
}

//plays given sound effect, return sound id
- (void) playSound: (soundTypes) sType loop:(BOOL) loop
{
	NSString *soundFileName;
	
	//sound is turned off
	if(turnedOff)
		return ;

	if(loop) //for looping sounds
	{
		switch (sType) 
		{
			case RAIN_EFF:
				[rainSS play];
				break;
			case WIND_EFF:
				[windSS play];
				break;
			case TORNADO_EFF:
				[tornadoSS play];
				break;
			default: break;
		}
	}else //one-time sounds
	{
		switch (sType) 
		{
			case LIGHTNING_EFF:
				soundFileName = [NSMutableString stringWithString: @"lightning.wav"];
				break;
			case LIGHTNING_1_EFF:
				soundFileName = [NSMutableString stringWithString: @"lightning_1.wav"];
				break;	
			case SCREAM_EFF:
				soundFileName = [NSMutableString stringWithString: @"screame.wav"];
				break;
			case GHOST_PICK_EFF:
				soundFileName = [NSMutableString stringWithString: @"ghost_pick.wav"];
				break;
			case BUTTON_PRESS_EFF:
				soundFileName = [NSMutableString stringWithString: @"button_press.wav"];
				break;
			case DROWN_EFF:
				soundFileName = [NSMutableString stringWithString: @"bubbles.wav"];
				break;
			case SCREAM_HORSE_EFF:
				soundFileName = [NSMutableString stringWithString: @"scream_horse.wav"];
				break;
			case BLOW_UP_EFF:
				soundFileName = [NSMutableString stringWithString: @"blow_up.wav"];
				break;
				
			default:
				soundFileName = [NSMutableString stringWithString: @""];
				break;
				
		}
	
		[[SimpleAudioEngine sharedEngine] playEffect:soundFileName];	
	}

}

//stop given sound
- (void) stopSound: (soundTypes) sType
{
	switch (sType) 
	{
		case RAIN_EFF:
			[rainSS stop];
			break;
		case WIND_EFF:
			[windSS stop];
			break;
		case TORNADO_EFF:
			[tornadoSS stop];
			break;
		default: break;
	}
}

//play given sound source (used in tree fire)
- (void) playGivenSound: (CDSoundSource*) ss
{
	//sound is turned off
	if(turnedOff)
		return ;
	[ss play];
}

//stop given sound source
- (void) stopGivenSound: (CDSoundSource*) ss
{
	[ss stop];
}

//stop all looping sounds at once (only with intrenal ids)
- (void) stopAllSounds
{
	if(turnedOff)
		return;
	
	[[SimpleAudioEngine sharedEngine] stopAllSounds];
}


//play given background music
- (void) playMusic: (musicTypes) mType :(BOOL) looping
{
	NSString *soundFileName;
	
	//sound turned off
	if(turnedOff)
		return;
	
	switch (mType) 
	{
		case MENU_MUS:
			soundFileName = [NSMutableString stringWithString: @"menu_music.mp3"];
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:  2.0f];
			break;
		case PLAY_MUS:
			soundFileName = [NSMutableString stringWithString: @"play_music.mp3"];
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:  1.3f];
			break;
		case LOOSE_MUS:
			soundFileName = [NSMutableString stringWithString: @"loose_music.mp3"];
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:  2.0f];
			break;
		case WINNING_MUS:
			soundFileName = [NSMutableString stringWithString: @"winning_music.mp3"];
			[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:  2.0f];
			break;
		default:
			soundFileName = [NSMutableString stringWithString: @""];
			break;
	}
	
	[[SimpleAudioEngine sharedEngine] playBackgroundMusic: soundFileName loop:looping];
	
}

//mute sound
- (void) setSoundMutedState: (BOOL) mValue
{
	muted = mValue;
	
	//mute does not work properly otherwise
	/*
	if(mValue)
		[[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	else
		[[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
	*/
	//mute engine
	[[SimpleAudioEngine sharedEngine] setMute: muted];	
} 

//mute, without changing overall engine state (used in pause game)
-(void) simpleMute: (BOOL)mValue
{
	[[SimpleAudioEngine sharedEngine] setMute: mValue];
}


//weather sounds and music are turned off
- (void) setSoundOff: (BOOL) mValue
{
	turnedOff = mValue;
}


- (void)dealloc 
{	
	[rainSS release]; 
	[windSS release]; 
	[tornadoSS release];
	
    [super dealloc];
}


@synthesize muted;
@synthesize turnedOff;

@end
