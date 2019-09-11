//
//  TerrainLr.h
//  illapa
//
//  Created by Ivars Rusbergs on 4/15/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//
//  Draws terrain 

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LevelDataCl.h"
#import "GraphicsCl.h"

@interface TerrainLr : CCNode
{
	int vertArraySize; //size of array for vertices
	CGPoint *terrainVerts; // array for polygons 
	texCoordStuct *texCoord; //array for terrain texture coordinates
	CGPoint *grassVerts; // array for grass polygons 
	
	CCTexture2D	*terrainTex;	
	CCTexture2D	*grassBladesTex;	
}

- (void) setupPlygons;
- (void) drawFilledPolygon: (CGPoint *)poli: (texCoordStuct *)texCoords: (int) first: (int) points;
@end
