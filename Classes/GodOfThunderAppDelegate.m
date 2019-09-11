//
//  GodOfThunderAppDelegate.m
//  GodOfThunder
//
//  Created by Ivars Rusbergs on 6/29/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "GodOfThunderAppDelegate.h"

@implementation GodOfThunderAppDelegate

@synthesize window;

- (void) applicationDidFinishLaunching:(UIApplication*)application
{
	// CC_DIRECTOR_INIT()
	//
	// 1. Initializes an EAGLView with 0-bit depth format, and RGB565 render buffer
	// 2. EAGLView multiple touches: disabled
	// 3. creates a UIWindow, and assign it to the "window" var (it must already be declared)
	// 4. Parents EAGLView to the newly created window
	// 5. Creates Display Link Director
	// 5a. If it fails, it will use an NSTimer director
	// 6. It will try to run at 60 FPS
	// 7. Display FPS: NO
	// 8. Device orientation: Portrait
	// 9. Connects the director to the EAGLView
	//
	//CC_DIRECTOR_INIT();
	//-----------------------------
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];					
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )								
		[CCDirector setDirectorType:kCCDirectorTypeNSTimer];									
	CCDirector *director = [CCDirector sharedDirector];										
	//[director setDeviceOrientation:kCCDeviceOrientationPortrait];								
	//[director setDisplayFPS:YES];																
	[director setAnimationInterval:1.0/60];													
	EAGLView *__glView = [EAGLView viewWithFrame:[window bounds]								
									 pixelFormat:kEAGLColorFormatRGBA8	//RGBA8	RGB565					
									 depthFormat:0 /* GL_DEPTH_COMPONENT24_OES */				
							  preserveBackbuffer:NO];											
	[director setOpenGLView:__glView];														
	[window addSubview:__glView];																
	[window makeKeyAndVisible];			
	//------------------------------
	
	
	// Sets landscape mode
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
	
	
	//set scale for larger screens
	//[director setContentScaleFactor:2];
	/*
	 if([[UIScreen mainScreen] respondsToSelector:NSSelectorFromString(@"scale")])
	 {
	 if ([[UIScreen mainScreen] scale] == 1.0)
	 NSLog(@"Standard Resolution Device");
	 
	 if ([[UIScreen mainScreen] scale] == 2.0)
	 NSLog(@"High Resolution Device");
	 }
	 */
	
	// Turn on multiple touches
	EAGLView *view = [director openGLView];
	[view setMultipleTouchEnabled:YES];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kTexture2DPixelFormat_RGBA8888];	
	
	
	//retrieve user defaults
	[self retrieveUserSettings];
	
	//glClearColor(0,255,0,255); //TODO REMOVE THIS HERE test
	
	// start with menu scene
	MenuSc *menuScene = [MenuSc node];
    [[CCDirector sharedDirector] runWithScene:menuScene];
	
}
//TODO background suspending forum topic 7326
- (void)applicationWillResignActive:(UIApplication *)application {
	if(![[GameStateCl sharedSingleton] isPaused]) //if game was not paused for user before
		[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if(![[GameStateCl sharedSingleton] isPaused]) //if game was not paused for user before
		[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	[[CCDirector sharedDirector] purgeCachedData];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[CCDirector sharedDirector] end];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
	[window release];
	[super dealloc];
}


//user preferences management
- (void) retrieveUserSettings
{
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	/*
	 // getting an NSString
	 NSString *myString = [prefs stringForKey:@"keyToLookupString"];
	 
	 // getting an NSInteger
	 NSInteger myInt = [prefs integerForKey:@"integerKey"];
	 
	 // getting an Float
	 float myFloat = [prefs floatForKey:@"floatKey"];
	 */
	
	//NO - is returned if user settings is not set
	BOOL soundState = [prefs boolForKey:@"illSoundOff"];
	[[SoundCl sharedSingleton] setSoundOff:soundState];
	
	//number of level that user quit game last time in
	int levelToContinue = 4;//[prefs integerForKey:@"illLvlCont"];
	[[GameStateCl sharedSingleton] setContinuedLevel:levelToContinue];
}

@end
