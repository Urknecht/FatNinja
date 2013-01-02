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
   //Ninja
    Ninja *ninja;
    //enemy layer
    EnemyLayer *enemyLayer;
    //gibt an ob ninja gerade springt
    bool isJumping;
    
    bool isPaused;
    int distance;
}
@property (readwrite) bool isPaused;
@property (readwrite) int distance;

-(void) pauseGame;

@end
