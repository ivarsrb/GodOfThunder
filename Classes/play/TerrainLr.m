//
//  TerrainLr.m
//  illapa
//
//  Created by Ivars Rusbergs on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TerrainLr.h"


@implementation TerrainLr

- (id) init
{
	self = [super init];
	if (self != nil) {
		//array size for ground polygon
		//terrain is divided in covex polys, each poly has 4 vertices
		vertArraySize = [[LevelDataCl sharedSingleton] sectionCount] * 4;
		terrainVerts = (CGPoint *)malloc(vertArraySize * sizeof(CGPoint));
		grassVerts = (CGPoint *)malloc(vertArraySize * sizeof(CGPoint));
		texCoord = (texCoordStuct *)malloc(vertArraySize * sizeof(texCoordStuct));

		terrainTex = [[CCTextureCache sharedTextureCache] addImage: @"grass.png"];
		grassBladesTex = [[CCTextureCache sharedTextureCache] addImage: @"grass_blades.png"];
		
		[self setupPlygons];
	}
	return self;
}

-(void) draw
{
	//terrain draw
	glColor4ub(255, 255, 255, 255);
	
	//draw terrain
	glBindTexture(GL_TEXTURE_2D, [terrainTex name]);
	[self drawFilledPolygon: terrainVerts: texCoord: 0: 2*[[LevelDataCl sharedSingleton] sectionCount] + 2];
	
	//draw grass
	glBindTexture(GL_TEXTURE_2D, [grassBladesTex name]);
	[self drawFilledPolygon: grassVerts: texCoord: 0: 2*[[LevelDataCl sharedSingleton] sectionCount] + 2];
}

//set up polygon data and array before rendering
-(void) setupPlygons
{
    float sectionWidth; //pixels form one height map point to other
	CGSize winSize = [[CCDirector sharedDirector] winSize]; //parameters of Opengl window
   
	sectionWidth = winSize.width / [[LevelDataCl sharedSingleton] sectionCount];
	
	//IMPORTANT, texture cooords are upside down, becouse cocos uses reversed coordinat system
	//  0,0 ------ 1,0
	//   |          |
	//   |          |
	//  0,1 ------ 1,1

	//init terrain vertices
	//make it in one triangle strip
	//first 2 vertices ( [0] - top left, [1] - bottom left)
	terrainVerts[0] = ccp(0, [[LevelDataCl sharedSingleton] heightMap][0]); 
	texCoord[0].u = 0;
	texCoord[0].v = 0;
	terrainVerts[1] = ccp(0, 0); 
	texCoord[1].u = 0;
	texCoord[1].v = 1;
	
	//add other vertices by section
	int ptInd = 2; //start from third vertice
	for(int i = 0; i < [[LevelDataCl sharedSingleton] sectionCount]; i++)
    {
		terrainVerts[ptInd] = ccp((i+1) * sectionWidth, [[LevelDataCl sharedSingleton] heightMap][i+1]); 
		texCoord[ptInd].u = (i+1) % 2; //need 1 or 0
		texCoord[ptInd].v = 0;
		ptInd++;
		terrainVerts[ptInd] = ccp((i+1) * sectionWidth, 0); 
		texCoord[ptInd].u = (i+1) % 2; //need 1 or 0
		texCoord[ptInd].v = 1;
		ptInd++;
	}
	
	
	//init grass vertices
	int grassHeight = 4;
	grassVerts[0] = ccp(0, [[LevelDataCl sharedSingleton] heightMap][0]+grassHeight); 
	grassVerts[1] = ccp(0, [[LevelDataCl sharedSingleton] heightMap][0]); 
	ptInd = 2; //start from third vertice
	for(int i = 0; i < [[LevelDataCl sharedSingleton] sectionCount]; i++)
    {
		grassVerts[ptInd] = ccp((i+1) * sectionWidth, [[LevelDataCl sharedSingleton] heightMap][i+1]+grassHeight); 
		ptInd++;
		grassVerts[ptInd] = ccp((i+1) * sectionWidth, [[LevelDataCl sharedSingleton] heightMap][i+1]); 
		ptInd++;
	}
	
}

//draw polygon
- (void) drawFilledPolygon: (CGPoint *)poli: (texCoordStuct *)texCoords: (int) first: (int) points
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	
	//glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
    //glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT );
	
	glDisableClientState(GL_COLOR_ARRAY);
	
	glVertexPointer(2, GL_FLOAT, 0, poli);
	glTexCoordPointer(2, GL_FLOAT, 0, texCoords);
	
	glDrawArrays(GL_TRIANGLE_STRIP, first, points);
	
	// restore default state
	glEnableClientState(GL_COLOR_ARRAY);
}


- (void)dealloc {
	free(terrainVerts);
	free(grassVerts);
	free(texCoord);
    [super dealloc];
}


@end


