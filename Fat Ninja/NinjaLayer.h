//
//  NinjaLayer.h
//  Fat Ninja
//
//  Created by Verena Lerch on 1/8/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Box2D.h"
@class GameLayer;
@class CCPhysicsSprite;

@interface NinjaLayer : CCLayer {
    
    CCAction *_jumpAction;
    CCAction *_doubleJumpAction;
    CCAction *_rollAction;
    CCAction *_dieAction;
    CCAction *_throwAction;
    CCAction *_walkSpeedAction;
    CCSpriteBatchNode *_spriteSheetRunning;
    CCSpriteBatchNode *_spriteSheetJumping;
    CCSpriteBatchNode *_spriteSheetDoubleJump;
    CCSpriteBatchNode *_spriteSheetRoll;
    CCSpriteBatchNode *_spriteSheetDie;
    CCSpriteBatchNode *_spriteSheetThrow;
    
    //prüft ob der Ninja hüpft während ein Shuricon geworfen wurde
    bool _wasJumpingAndThrowing;
    
    b2World * world;
}


@property (readwrite)bool isJumping;
@property (readwrite)bool isDoubleJumping;
@property (readwrite)bool isRolling;
@property (readwrite)bool isDying;
@property (readwrite)bool isThrowing;

@property (nonatomic, retain)CCPhysicsSprite *ninjaRunning;
@property (nonatomic, retain)CCPhysicsSprite *ninjaJumping;
@property (nonatomic, retain)CCPhysicsSprite *ninjaDoubleJump;
@property (nonatomic, retain)CCPhysicsSprite *ninjaRoll;
@property (nonatomic, retain)CCPhysicsSprite *ninjaDie;
@property (nonatomic, retain)CCPhysicsSprite *ninjaThrow;

//Jump Bewegungsanimation (hoch-runter)
@property (nonatomic, retain)CCJumpBy *ninjaJumpMove;
//DoubleJump Bewegungsanimationen (hoch-runter)
@property (nonatomic, retain)CCJumpBy *ninjaDoubleJumpMove;


@property (nonatomic,retain) id walkSpeedAction;
@property (nonatomic, retain)CCAction *jumpAction;
@property (nonatomic, retain)CCAction *doubleJumpAction;
@property (nonatomic, retain)CCAction *rollAction;
@property (nonatomic, retain)CCAction *dieAction;
@property (nonatomic, retain)CCAnimation *throwAnim;

@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRunning;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetJumping;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetDoubleJump;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRoll;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetDie;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetThrow;

-(id) initWithWorld: (b2World*) world;
-(void) jump;
-(void) doubleJump;
-(void) startRoll;
-(void) endRoll;
-(void) reloadAnimsWithSpeed:(double)geschwindigkeit;
-(void) die:(GameLayer *)gameLayer;
-(void) throwProjectile:(GameLayer *)gameLayer;

-(CCSprite*)getCurrentNinjaSprite;

@end
