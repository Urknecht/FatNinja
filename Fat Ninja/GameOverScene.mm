//
//  GameOverScene.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/2/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "GameOverScene.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "GameScene.h"

@implementation GameOverScene
-(id)init {
    self = [super init];
    if (self != nil) {
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"gameOverBackground.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];

        
	// Default font size will be 30 points.
	[CCMenuItemFont setFontSize:30];
	
	// Replay Button
        CCMenuItemLabel *replay = [CCMenuItemFont itemWithString:@"Replay" block:^(id sender){

            [[CCDirector sharedDirector] replaceScene:[GameScene node]];

        }];
	
	
	// Main Menu Item
	CCMenuItem *backToMainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {

        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];

	}];
	
	// Shop Menu Item
//	CCMenuItem *shop = [CCMenuItemFont itemWithString:@"Shop" block:^(id sender) {
//		
//	}];
	
	CCMenu *menu = [CCMenu menuWithItems:backToMainMenu, replay, nil];
	
	[menu alignItemsHorizontally];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/3)];
	
	
	[self addChild: menu z:1];
        
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Highscore" fontName:@"Marker Felt" fontSize:30];
        [self addChild:label z:2];
        //[label setColor:ccc3(0,0,255)];
        label.position = ccp( size.width/2, size.height-50);
        
    }
    return self;
}

-(void)dealloc{
    [super dealloc];

}
@end
