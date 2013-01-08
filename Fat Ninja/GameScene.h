//
//  GameScene.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/12/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"

@class PauseLayer, GameLayer, BackgroundLayer;



@interface GameScene : CCScene
{


    // Gameplay Layer
    GameLayer *gameplayLayer;
    PauseLayer *pauseLayer;
}


@end
