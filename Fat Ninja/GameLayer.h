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
#import "ObstacleObject.h"
#import "Ninja.h"


#define PTM_RATIO     32.0 //zum umrechnen von cocos2d pints in box2d meter, vlt muss man das noch anpassen

@class GameObject;
@class BackgroundLayer;
@class ObstacleObject;
@class Ninja;

@interface GameLayer : CCLayerColor {
   
    //ninja 
    Ninja *ninja;
        
    bool isPaused;
    bool isRolling;
    
    int distance;
    
    //box2d
    b2World * world;
    //GLESDebugDraw * debugDraw;
    
    NSMutableArray *enemyArray;
    
    bool nextStage;
    double geschwindigkeitEnemy;
    
    CCSpriteBatchNode *_enemyBatchNode;
    CCSpriteBatchNode *_sushiBatchNode;
    CCSpriteBatchNode *_wallBatchNode;
    CCSpriteBatchNode *_stoneBatchNode;
    CCSpriteBatchNode *_powerUpBatchNode;
    
    //Die Zeit, die rausgekommen ist beim Powerup
    float powerupDuration;
    
     NSInteger*pointer;

    
}
@property(nonatomic, readwrite)  NSInteger*pointer;
@property(nonatomic, strong) NSMutableArray *enemyArray;
@property(nonatomic,strong)  CCSpriteBatchNode *_enemyBatchNode;
@property(nonatomic,strong)  CCSpriteBatchNode *_sushiBatchNode;
@property(nonatomic,strong)  CCSpriteBatchNode *_wallBatchNode;
@property(nonatomic,strong)  CCSpriteBatchNode *_stoneBatchNode;
@property(nonatomic,strong)  CCSpriteBatchNode *_powerUpBatchNode;


//Die Zeit, die rausgekommen ist beim Powerup
@property(readwrite) NSInteger powerupDuration;

@property(readwrite) bool nextStage;
@property(readonly) double geschwindigkeitEnemy;

@property (readwrite)double geschwindigkeit;
@property (readwrite) bool isPaused;
@property (readwrite) int distance;

-(void)removeEnemy: (ObstacleObject*) enemy;
-(void)removeObstacle: (CCPhysicsSprite*) enemy;
-(void) stopAnimation;
-(void) stopGame;
-(void) pauseGame;
-(void) endGame;
-(void)throwProjectile;
@end
