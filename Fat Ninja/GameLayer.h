//
//  GameScene.h
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright 2012 Florian Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "CCPhysicsSprite.h"


#define PTM_RATIO     32.0 //zum umrechnen von cocos2d pints in box2d meter, vlt muss man das noch anpassen

@class GameObject;
@class BackgroundLayer;

@interface GameLayer : CCLayerColor {
   
    //ninja 
    GameObject *ninja;
    
    BackgroundLayer *backgroundLayer;
    
    bool isPaused;
    int distance;
    
    //box2d
    b2World * world;
    GLESDebugDraw * debugDraw;
    
    NSMutableArray *enemyArray;
    
    bool nextStage;
    double geschwindigkeitEnemy;
    
}
@property(nonatomic, strong) NSMutableArray *enemyArray;
@property(readwrite) bool nextStage;
@property(readonly) double geschwindigkeitEnemy;

@property (readwrite)double geschwindigkeit;
@property (readwrite) bool isPaused;
@property (readwrite) int distance;


-(void)removeObstacle: (CCSprite*) enemy;
-(void) stopAnimation;
-(void) pauseGame;
-(void) endGame;
-(void)throwProjectile;
@end
