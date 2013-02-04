//
//  PauseLayer.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/2/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "PauseLayer.h"
#import "GameLayer.h"
#import "Constants.h"
#import "HelloWorldLayer.h"

@implementation PauseLayer
CCMenu * menu;
GameLayer * gl;
CCSprite *pauseBackground;

- (id) init{
    if ((self = [super init]))
    {
        
        //Pause Button
        CCSprite *pauseImage= [CCSprite spriteWithFile:@"pauseButton.png"];
        pauseBackground= [CCSprite spriteWithFile:@"paperBg.png"];

        CGSize winSize = [CCDirector sharedDirector].winSize;
        [pauseImage setPosition: CGPointMake(20, winSize.height-20)];
        [pauseBackground setPosition: CGPointMake(winSize.width/2, winSize.height/2)];

        [self setTouchEnabled:YES];
        [self addChild: pauseImage z:0];
        [self addChild: pauseBackground z:1];
        [pauseBackground setVisible:NO];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Pause" fontName:@"Marker Felt" fontSize:30];
        [self addChild:title z:2];
        title.position = ccp( winSize.width/2, winSize.height-70);
        title.color = ccc3(66,53,32);



        
        gl = (GameLayer *)[self.parent getChildByTag:gameLayerTag];

        // Menu und Resume Button
        [CCMenuItemFont setFontSize:30];
        CCMenuItemLabel *resume = [CCMenuItemFont itemWithString:@"Resume" block:^(id sender){
            [[CCDirector sharedDirector] resume];
            [menu setVisible:NO];
            [pauseBackground setVisible:NO];
            [gl setIsPaused:false];
             }];
        CCMenuItemLabel *backToMain = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender){
            [[CCDirector sharedDirector] resume];
            [[CCDirector sharedDirector] replaceScene: [HelloWorldLayer node]];
            [menu setVisible:NO];
            [pauseBackground setVisible:NO];
            [gl setIsPaused:false];
        }];

        menu = [CCMenu menuWithItems:backToMain,resume, nil];
        
        [menu alignItemsHorizontallyWithPadding:20.0];
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        [menu setPosition:ccp( size.width/2, size.height/2)];
        
        [menu setVisible:NO];

        [self addChild: menu z:2];
        
    }
    return self;
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    gl = (GameLayer *)[self.parent getChildByTag:gameLayerTag];

    for( UITouch *touch in touches )
    {
        CGPoint location = [touch locationInView: [touch view]];
        
        location = [[CCDirector sharedDirector] convertToGL: location];
        CGSize winSize = [CCDirector sharedDirector].winSize;

        if(location.y>winSize.height-30 and location.x<30)
        {
            [menu setVisible:YES];
            [pauseBackground setVisible:YES];
            [gl setIsPaused:true];
            [gl pauseGame];
        
        }
    }
}

- (void) dealloc
{
    [super dealloc];
}

@end
