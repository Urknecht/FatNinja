//
//  Ninja.h
//  Fat Ninja
//
//  Created by Manuel Graf on 1/19/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"
#import "Box2D.h"

@class GameLayer;
@class CCPhysicsSprite;



@interface Ninja : GameObject {
    CCAction *_jumpAction;
    CCAction *_doubleJumpAction;
    CCAction *_rollAction;
    CCAction *_dieAction;
    CCAction *_throwAction;
    CCAction *_BIGAction;
    CCAction *_walkSpeedAction;
    CCAction *_walkSpeedActionFast;
    CCSpriteBatchNode *_spriteSheetRunning;
    CCSpriteBatchNode *_spriteSheetRunningFast;
    CCSpriteBatchNode *_spriteSheetJumping;
    CCSpriteBatchNode *_spriteSheetDoubleJump;
    CCSpriteBatchNode *_spriteSheetRoll;
    CCSpriteBatchNode *_spriteSheetDie;
    CCSpriteBatchNode *_spriteSheetBIG;
    CCSpriteBatchNode *_spriteSheetThrow;
    
    //prüft ob der Ninja hüpft während ein Shuricon geworfen wurde
    bool _wasJumpingAndThrowing;
    
    //gibt an welche Art von hüpfen gerade durchgeführt wurde
    bool _jumpWasDouble;
    
    //gibt an ob der Ninja nach der animation sterben soll
    bool _shouldDie;
    
    //gibt an ob bereits die FastRunAnimation verwendet wird
    bool _runningFast;
    
    //gibt an die Geschwindigkeit der Animation angepasst werden muss
    bool _geschToChange;
    
    //gibt an die Geschwindigkeit der Animation angepasst werden muss
    bool _isInvincibru;
    
    //Die zu setzende Geschwindigkeit
    int _geschwindigkeit;
    
    //Der Gamelayer an den nach Die zurückgegeben wird
    GameLayer *_gameLayer;
    
    b2World * world;
}


@property (nonatomic, retain)CCPhysicsSprite *ninjaRunning;
@property (nonatomic, retain)CCPhysicsSprite *ninjaRunningFast;
@property (nonatomic, retain)CCPhysicsSprite *ninjaJumping;
@property (nonatomic, retain)CCPhysicsSprite *ninjaDoubleJump;
@property (nonatomic, retain)CCPhysicsSprite *ninjaRoll;
@property (nonatomic, retain)CCPhysicsSprite *ninjaDie;
@property (nonatomic, retain)CCPhysicsSprite *ninjaBIG;
@property (nonatomic, retain)CCPhysicsSprite *ninjaThrow;

//Jump Bewegungsanimation (hoch-runter)
@property (nonatomic, retain)CCJumpBy *ninjaJumpMove;
//DoubleJump Bewegungsanimationen (hoch-runter)
@property (nonatomic, retain)CCJumpBy *ninjaDoubleJumpMove;


@property (nonatomic,retain) id walkSpeedAction;
@property (nonatomic,retain) id walkSpeedActionFast;
@property (nonatomic, retain)CCAction *jumpAction;
@property (nonatomic, retain)CCAction *doubleJumpAction;
@property (nonatomic, retain)CCAction *rollAction;
@property (nonatomic, retain)CCAction *dieAction;
@property (nonatomic, retain)CCAction *BIGAction;
@property (nonatomic, retain)CCAnimation *throwAnim;

@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRunning;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRunningFast;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetJumping;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetDoubleJump;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRoll;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetDie;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetBIG;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetThrow;

-(id) initWithWorld: (b2World*) world;
-(void) jump;
-(void) doubleJump;
-(void) startRoll;
-(void) endRoll;
-(void) reloadAnimsWithSpeed:(double)geschwindigkeit;
-(void) die:(GameLayer *)gameLayer;
-(void) throwProjectile:(GameLayer *)gameLayer;

-(b2Body*) getCurrentBody;
-(CCPhysicsSprite*)getCurrentNinjaSprite;


-(void)checkAndClampSpritePosition;
-(int)getWeaponDamage;

@end
