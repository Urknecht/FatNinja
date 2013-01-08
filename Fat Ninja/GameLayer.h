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
@class NinjaLayer;
@class Ninja;
@class BackgroundLayer;

@interface GameLayer : CCLayerColor {
   
    //ninja layer
    NinjaLayer *ninjaLayer;
    //enemy layer
    EnemyLayer *enemyLayer;
    
    BackgroundLayer *backgroundLayer;
    
    
    bool isPaused;
    int distance;
}
@property (readwrite)double geschwindigkeit;
@property (readwrite) bool isPaused;
@property (readwrite) int distance;

-(void) pauseGame;

@end
