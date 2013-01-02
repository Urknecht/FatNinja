//
//  GameScene.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/12/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"
#import "GameLayer.h"
#import "BackgroundLayer.h"
#import "EnemyLayer.h"


@interface GameScene : CCScene
{
    BackgroundLayer *background;
    // Gameplay Layer
    GameLayer *gameplayLayer;
}


@end
