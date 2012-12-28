//
//  GameScene.h
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright 2012 Florian Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class EnemyLayer;
@class Ninja;

@interface GameLayer : CCLayerColor {
    Ninja *ninja;
    //enemy layer
    EnemyLayer *enemyLayer;
    bool isJumping;
}
@property(readonly) Ninja *ninja;

//+(id) scene;

@end
