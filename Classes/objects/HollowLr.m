//
//  HollowLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 5/9/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "HollowLr.h"


@implementation HollowLr


//initialization with enemy type
- (id) initWithIndexes: (int) indexL :(int) indexR
{
	
	if( (self = [super initWithColor: ccc4(98, 165, 255, 150) width:0 height:0] )) //water transparent color
	{
		int sectionWidth; //pixels form one height map point to other
		
		CGSize winSize = [[CCDirector sharedDirector] winSize]; //parameters of Opengl window
		sectionWidth = winSize.width / [[LevelDataCl sharedSingleton] sectionCount];
		
		indexLeft = indexL;
        indexRight = indexR;
		
		//find out left and right border coords for hollow
		positionLeft = ccp(sectionWidth * indexLeft, [[LevelDataCl sharedSingleton] heightMap][indexLeft]);
		positionRight = ccp(sectionWidth * indexRight, [[LevelDataCl sharedSingleton] heightMap][indexRight]);
		
		status = 0;
        fillFactor = 0; 
		//TODO think about these factors
        relFillFactor = 5 / (positionRight.x - positionLeft.x); //bigger the hollow, slower the filling
        decreaseFactor = 4.0;
		fillLevel = 0;
		
		//get lowest point
        baseY = winSize.height;
        for(int i = indexLeft; i <= indexRight; i++)
        {
            if(baseY > [[LevelDataCl sharedSingleton] heightMap][i])
				baseY = [[LevelDataCl sharedSingleton] heightMap][i];
        }
		
		//setup visible water parameters
		self.position = ccp(0,0);
		
		[self schedule:@selector(update:)];
		//OPTI - if something slow, try hiding (visible  = NO) when water not seen
		
		//[self runAction:[CCShaky3D actionWithRange:3 shakeZ:NO grid:ccg(10,10) duration:40]];
	}
	return self;
}


//determine weather current rain hits hollow and amount the rain intersects hollow
-(float) getFillFactor
{
	float fillF = 0;
	float rainX = 0;
	float rainWidth = fabs([[RainCl sharedSingleton] rainPos1].x - [[RainCl sharedSingleton] rainPos2].x);
	
	//find minimum of two rain point
	if([[RainCl sharedSingleton] rainPos1].x > [[RainCl sharedSingleton] rainPos2].x)
	{
		rainX = [[RainCl sharedSingleton] rainPos2].x;
	}else {
		rainX = [[RainCl sharedSingleton] rainPos1].x;
	}

	
	//rain fully enclosed by hollow
	if(positionLeft.x < rainX && positionRight.x > rainX + rainWidth)
	{
		fillF = rainWidth;
	}
	
	//hollow fully enclosed by rain
	if(positionLeft.x >= rainX && positionRight.x <= rainX + rainWidth)
	{
		fillF = positionRight.x - positionLeft.x;
	}
	
	//rain on left side of hollow
	if(positionLeft.x >= rainX && positionRight.x > rainX + rainWidth && positionLeft.x < rainX + rainWidth)
	{
		fillF = (rainX + rainWidth) - positionLeft.x;
	}
	
	//rain on right side of hollow
	if(positionLeft.x < rainX && positionRight.x <= rainX + rainWidth && positionRight.x > rainX)
	{
		fillF = positionRight.x - rainX;
	}
	
	return fillF;
}



//update water states and fill level
-(void) update  :(ccTime) dt
{
	if(![[LevelDataCl sharedSingleton] levelInitialized])
		return;
	
	float expFactor; 
	
	fillFactor = [self getFillFactor];
	
	if(fillFactor) //if rain hits hollow
	{
		if(![self isFilling] && [[RainCl sharedSingleton] isRaining]) //raining
		{	
			[self setFilling]; //hollow is filling
		}
		
		if(![[RainCl sharedSingleton] isRaining] && [self isFilling]) //was filling before
		{
			[self setDrying];  //in drying process
		}
		
		if([self isFilling])//fill water
		{
			//if(fillLevel < positionLeft.y - baseY && fillLevel < positionRight.y - baseY) //while water is not filled till the end
			if(fillLevel < fminf((positionLeft.y - baseY),(positionRight.y - baseY))) //while water is not filled till the end
			{
				expFactor = [self exponentialFactor: fillLevel : fminf((positionLeft.y - baseY),(positionRight.y - baseY))];
				fillLevel += expFactor * relFillFactor * fillFactor * dt; //exponential factor * relative speed * rain amount * time
			}
		}
	}
	
	if([self isDrying]) //dry water
	{
		expFactor = [self exponentialFactor: fillLevel : fminf((positionLeft.y - baseY),(positionRight.y - baseY))];
		fillLevel -= expFactor * decreaseFactor * dt; //exponential factor * relative speed  * time
		if(fillLevel <= 0) //if is dryed
		{
			[self setEmpty];
		}
	}
	
	//draw if water is present in hollow
	if(![self isEmpty])
	{
		self.position = ccp(positionLeft.x,  baseY);
		[self changeWidth: (positionRight.x - positionLeft.x)];
		[self changeHeight: fillLevel];
	}
}

//check weather object with coordinates and height is drowning in hollow
//position is coords of the point that is checked against drowning (like horse head)
-(BOOL) isDrowning: (CGPoint) objectPosition: (float) objectHeight
{
	if(![self isEmpty])
	{
		//enemy is under water
		if((objectPosition.x > positionLeft.x && objectPosition.x < positionRight.x) && (baseY + fillLevel) > (objectPosition.y + objectHeight )) 
		{
			return YES;
		}
	}
	return NO;
}


-(BOOL) isEmpty
{
	return (status == 0);
}
-(BOOL) isFilling;
{
	return (status == 1);
}
-(BOOL) isDrying
{
	return (status == 2);
}

-(void) setEmpty
{
	status = 0;
}
-(void) setFilling
{
	status = 1;
}
-(void) setDrying
{
	status = 2;
}

//exponential koef fill hall faster at buttom from 1,5(buttom) to 0,5(top) of total fill speed
-(float) exponentialFactor: (float) fill :(float) hollowDepth
{
	return 1.5 - fill / hollowDepth;
}

@end

