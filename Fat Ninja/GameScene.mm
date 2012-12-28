//
//  GameScene.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/12/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(id)init {
    self = [super init];
    if (self != nil) {
        // backgorund layer
        background =[BackgroundLayer node];
        [self addChild:background z:0];
            // Gameplay Layer
        gameplayLayer = [GameLayer node];
        [self addChild:gameplayLayer z:5];
        
    }

    return self;
}



@end
