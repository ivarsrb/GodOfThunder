//
//  LevelDataCl.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "LevelDataCl.h"


@implementation LevelDataCl

static LevelDataCl* _sharedSingleton = nil;

+(LevelDataCl*)sharedSingleton
{
	@synchronized([LevelDataCl class])
	{
		if (!_sharedSingleton)
			[[self alloc] init];
		
		return _sharedSingleton;
	}
	
	return nil;
}

+(id)alloc
{
	@synchronized([LevelDataCl class])
	{
		NSAssert(_sharedSingleton == nil, @"LevelDataCl: Attempted to allocate a second instance of a singleton.");
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
		[self reset];
		levelFileName = [[NSMutableString stringWithString: @"level_%d"] retain];
	}
	return self;
}

//get all levbel data and assign to variables
-(void) createLevel
{
	if(!levelInitialized)
	{
		levelInitialized = YES;
		currentLevelID++;
		if(currentLevelID <= [[GameStateCl sharedSingleton] maxLevel])
		{
			//open current level file
			FileManagementCl *levelFile;
			levelFile = [[[FileManagementCl alloc] init] autorelease];
			NSDictionary *levelDictionary;
			levelDictionary = [levelFile getDictionary: [NSMutableString stringWithFormat:levelFileName,currentLevelID]];
		
			//---------- init main variables
			//terrain
			sectionCount = [[levelDictionary valueForKey: @"terrain_section_count"] intValue];//10
			heightMapWidth = sectionCount + 1;
			heightMap = (float *)malloc(heightMapWidth * sizeof(float));	
			groundBase = 50;
					
			//enemy
			enemyCount = [[levelDictionary valueForKey: @"enemy_count"] intValue]; //6
			enemyTriggerTime = (float *)malloc(enemyCount * sizeof(float));
			enemyContents = (enemyTypes *)malloc(enemyCount * sizeof(enemyTypes));
			
			//---------- get level data
			//terrain height map data
			NSMutableArray *heightMapArray = [levelDictionary objectForKey: @"terrain_height_map"]; 
			for(int i = 0; i < heightMapWidth; i++)
			{
				//covert NSArray to c-style array
				heightMap[i] = [[heightMapArray objectAtIndex:i] intValue] + groundBase; //in plist, all heigths are relative to 0
			}
			
			//set up terrain hollow data, for rain water to collect
			hollowsIndexes = [[levelDictionary objectForKey: @"hollow_indexes"] retain]; 
			
			//get trees information
			treeCollections = [[levelDictionary objectForKey: @"tree_collection"] retain];
			
			//enemies
			//how many what type of enemies there will be
			int infantryCount = [[levelDictionary valueForKey: @"infantry_count"] intValue]; 
			int cavalryCount = [[levelDictionary valueForKey: @"cavalry_count"] intValue]; 
			//first always gona be infantries
			//seconds - cavalry
			for(int i = 0; i < enemyCount; i++)
			{
				if (i < infantryCount) //first of assign infantries
				{
					enemyContents[i] = INFANTRY;
				}else if (i >= infantryCount && i < infantryCount + cavalryCount)  //after that - cavalries
				{
					enemyContents[i] = CAVALRY;
				}
			}
			
			//set up enemy trigger time
			//trigger time params
			/*type: 1: EVEN enemy starts regulary after fixed period
					2: PERIODICAL enemy starts in groups, between groups there are fuxed time
					3: RANDOM enemy starts randomly, but within certain time frame
			 */
			NSDictionary *infantryTimeDict,*cavalryTimeDict;
			
			infantryTimeDict = [levelDictionary objectForKey: @"infantry_trigger"];
			cavalryTimeDict = [levelDictionary objectForKey: @"cavalry_trigger"];
			
			//times when first infantry appears and first cavalry appears
			float infantryFirstTime = [[infantryTimeDict valueForKey:@"first_time"] floatValue];
			float cavalryFirstTime = [[cavalryTimeDict valueForKey:@"first_time"] floatValue];
			
			float infantryInterval = [[infantryTimeDict valueForKey:@"interval"] floatValue]; //interval in which enemy is started after another
			float cavalryInterval = [[cavalryTimeDict valueForKey:@"interval"] floatValue];
			
			BOOL infantryRandNeeded = [[infantryTimeDict valueForKey:@"random"] boolValue];  //if ranodm factor needed
			BOOL cavalryRandNeeded = [[cavalryTimeDict valueForKey:@"random"] boolValue];  
			
			//if there is periodical starting
			//put them to 0 if not needed
			float infantryPeriodSeq = [[infantryTimeDict valueForKey:@"period_sequence"] floatValue]; //after what period pause in triggering starts
			float infantryPeriodLength = [[infantryTimeDict valueForKey:@"period_length"] floatValue]; //how long trigger pause lasts
			
			float cavalryPeriodSeq = [[cavalryTimeDict valueForKey:@"period_sequence"] floatValue]; //after what period pause in triggering starts
			float cavalryPeriodLength = [[cavalryTimeDict valueForKey:@"period_length"] floatValue]; //how long trigger pause lasts
			
			
			float randomFactor; //will add random time if neccesary
			int infantryCurrPeriod = 1; //if there are periods, holds current period number 
			int cavalryCurrPeriod = 1; //if there are periods, holds current period number 
			
			for(int i = 0; i < enemyCount; i++)
			{
				if (i < infantryCount) //start time for infantries, from start of level
				{
					if(infantryRandNeeded){
						randomFactor = (arc4random() % ((int)infantryInterval+1)) / 2.0; //random from 0 - 0,5 (if interval = 1)
					}
					else {
						randomFactor = 0;
					}

					enemyTriggerTime[i] = infantryFirstTime + i * infantryInterval + randomFactor;

					//period set up (will effect nothing if both period values are 0)
					if(enemyTriggerTime[i] >= (infantryPeriodSeq * infantryCurrPeriod) && 
					   enemyTriggerTime[i] < (infantryPeriodSeq * infantryCurrPeriod) + infantryPeriodLength)
					{
						infantryCurrPeriod++;
					}
					
					//add period value 
					enemyTriggerTime[i] += (infantryCurrPeriod - 1) * infantryPeriodLength;

				}else if (i >= infantryCount && i < infantryCount + cavalryCount) //start time for cavalries, from start of level
				{
					if(cavalryRandNeeded){
						randomFactor = (arc4random() % ((int)cavalryInterval+1)) / 2.0; //random from 0 - 0,5 (if interval = 1)
					}
					else {
						randomFactor = 0;
					}
					
					enemyTriggerTime[i] = cavalryFirstTime + (i-infantryCount) * cavalryInterval + randomFactor;
				
					//period set up (will effect nothing if both period values are 0)
					if(enemyTriggerTime[i] >= (cavalryPeriodSeq * cavalryCurrPeriod) && 
					   enemyTriggerTime[i] < (cavalryPeriodSeq * cavalryCurrPeriod) + cavalryPeriodLength)
					{
						cavalryCurrPeriod++;
					}
					
					//add period value 
					enemyTriggerTime[i] += (cavalryCurrPeriod - 1) * cavalryPeriodLength;
					
				}
			}
		}
	}
}

//after level is complete, clear data
-(void) destroyLevel
{
	if(levelInitialized)
	{
		levelInitialized = NO;
		free(heightMap);
		free(enemyTriggerTime);
		free(enemyContents);
		[hollowsIndexes release];
		[treeCollections release];
	}
}

//reset level counter, as if first time started
-(void) reset
{
	currentLevelID = 0;
	levelInitialized = NO;
}

//check weather current level is final
-(BOOL) isLevelFinal
{
	return (currentLevelID == [[GameStateCl sharedSingleton] maxLevel]);
}

//manually set current level to given number
-(void) setCurrentLevel: (int) curLevId
{
	currentLevelID = curLevId;
}

//save current played level to defaults
-(void) saveCurrentLevelToDefaults: (int) curLevId
{
	//save to user defaults
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	[prefs setInteger:curLevId forKey:@"illLvlCont"];
	[prefs synchronize];
}

//TODO, if hollows will be defined in runtime, use this function
//get ids from heightmap that defines hollows in it
-(void) getHollowsIds
{
	/*
	hollowsIds = [NSMutableArray array];
	NSMutableDictionary *idsDict = [[NSMutableDictionary alloc] init]; //to store in objective c array
	while (YES) 
	{
		indexType hollow;
		hollow.indexRight = 0;
		hollow.indexLeft = 0;
		
		int highestPoint = groundBase;
		//find first highest point (when point+1 is lower than point)
		for(int i = 0; i < heightMapWidth; i++)
		{
			if (highestPoint <= heightMap[i]) 
			{
				highestPoint = heightMap[i];
			}else 
			{
				hollow.indexLeft = i - 1; //first highest index found
				highestPoint = heightMap[i]; //next lowest value after first highest point, used later
				break; 
			}
		}
		
		//now find right index of hollow, it will be the next highest point after leftIndex
		for(int i = hollow.indexLeft+1; i < heightMapWidth; i++)
		{
			if (highestPoint <= heightMap[i]) 
			{
				highestPoint = heightMap[i];
			}else 
			{
				hollow.indexRight = i - 1; //first highest index found
				break; 
			}
		}
		
		//if values are found, save them to hollow array
		if(hollow.indexRight > 0)
		{
			//add to objective c dictionarry and array
			[idsDict setObject:[NSNumber numberWithInt: hollow.indexRight] forKey:@"indexRight"];
			[idsDict setObject:[NSNumber numberWithInt: hollow.indexLeft] forKey:@"indexLeft"];

			[hollowsIds addObject: idsDict];
			
			NSLog(@"%d - %d",hollow.indexLeft,hollow.indexRight);
		}
		
		
		break;
	}
	 */
}


//Helper functions---------------------------------------------------

//return height of terrain at given X coordinate
-(float) getHeightByX: (float) x
{
    float leftHeight, leftX, rightHeight, rightX;
    int sectionWidth; //pixels form one height map point to other
    int sectionNumber; //in which section the point  is in
    float relativeX; // x relative to current section start
    float y; //hieght to be found
	
    CGSize winSize = [[CCDirector sharedDirector] winSize]; //parameters of Opengl window
	sectionWidth = winSize.width / sectionCount;
	
    sectionNumber = ceil(x / sectionWidth);
	
	if(sectionNumber > sectionCount) //make sure it does not go out of bounds
		sectionNumber = sectionCount;
	
	if(sectionNumber == 0)
		leftHeight = heightMap[0]; //height to the left of player
	else
		leftHeight = heightMap[sectionNumber - 1]; //height to the left of player
    
	leftX = 0;
    rightHeight = heightMap[sectionNumber];   //height to the right
    rightX = sectionWidth;
	
	//calculate it
    relativeX = x - (sectionNumber - 1) * sectionWidth;
    y = (relativeX - leftX) * (rightHeight - leftHeight) / (rightX - leftX) + leftHeight;
	
    return y;
}

//retrun angle of current terrain line in given coordinate. Flat means - 0, tilted CW means +, ACW -
-(float) getTerrAngleByX: (float) x
{
	float leftHeight, rightHeight;
	int sectionWidth; //pixels form one height map point to other
    int sectionNumber; //in which section the point is in
	float pieKatete;
	float pretKatete;
	
	CGSize winSize = [[CCDirector sharedDirector] winSize]; //parameters of Opengl window
	sectionWidth = winSize.width / sectionCount;
	
    sectionNumber = ceil(x / sectionWidth);
	
	if(sectionNumber > sectionCount) //make sure it does not go out of bounds
		sectionNumber = sectionCount;
	
	
	if(sectionNumber == 0)
		leftHeight = heightMap[0]; //height to the left of player
	else
		leftHeight = heightMap[sectionNumber - 1]; //height to the left of player
	
	rightHeight = heightMap[sectionNumber];   //height to the right

	//calculate angle
	pieKatete = sectionWidth;
	pretKatete = leftHeight - rightHeight;
	
	return atan(pretKatete / pieKatete) * (180 / M_PI);
}


- (void)dealloc 
{	
	[self destroyLevel];
	[levelFileName release];
    [super dealloc];
}


@synthesize sectionCount;
@synthesize heightMapWidth;
@synthesize heightMap;
@synthesize enemyCount;
@synthesize enemyTriggerTime;
@synthesize enemyContents;
@synthesize hollowsIndexes;
@synthesize treeCollections;
@synthesize levelInitialized;
@synthesize currentLevelID;
@synthesize groundBase;

@end
