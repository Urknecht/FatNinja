//
//  GameScene.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/12/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "GameScene.h"
#import "GameLayer.h"
#import "PauseLayer.h"
#import "BackgroundLayer.h"

@implementation GameScene

-(id)init {
    self = [super init];
    if (self != nil) {
        // backgorund layer
        background =[BackgroundLayer node];
        [self addChild:background z:0];
            // Gameplay Layer
        gameplayLayer = [GameLayer node];
        [self addChild:gameplayLayer z:3 tag:1];
        //pause layer
        pauseLayer =[PauseLayer node];
        [self addChild: pauseLayer z:5];
    }

    return self;
}

-(void)dealloc{
    [super dealloc];
}


@end
