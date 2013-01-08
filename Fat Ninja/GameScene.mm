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

#import "Constants.h"

@implementation GameScene

-(id)init {
    self = [super init];
    if (self != nil) {

            // Gameplay Layer
        gameplayLayer = [GameLayer node];
        [self addChild:gameplayLayer z:3 tag:gameLayerTag];
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
