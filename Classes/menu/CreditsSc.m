//
//  CreditsSc.m
//  illapa
//
//  Created by Ivars Rusbergs on 6/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CreditsSc.h"


@implementation CreditsSc

- (id) init
{
    self = [super init];
    if (self != nil) 
	{
		CGSize winSize = [[CCDirector sharedDirector] winSize]; 
		
		//Back -------
		CCMenuItemFont *menuItemCancel = [CCMenuItemFont itemFromString:@"Back" target:self selector:@selector(onCancelSelected:)];
		[menuItemCancel.label setColor:ccc3(255, 20, 20)];
		
        CCMenu *menu = [CCMenu menuWithItems:menuItemCancel, nil];
        menu.position = ccp(winSize.width / 2, 80);
		
		//adding to scene
		[self addChild: menu];
	}
    return self;
}


//go back
- (void) onCancelSelected:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCFlipXTransition transitionWithDuration:1.0 scene:[MenuSc node]]];
}

@end
