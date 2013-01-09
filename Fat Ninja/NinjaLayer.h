//
//  NinjaLayer.h
//  Fat Ninja
//
//  Created by Verena Lerch on 1/8/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
@class GameLayer;

@interface NinjaLayer : CCLayer {
    
    CCAction *_jumpAction;
    CCAction *_rollAction;
    CCAction *_dieAction;
    CCAction *_walkSpeedAction;
    CCSpriteBatchNode *_spriteSheetRunning;
    CCSpriteBatchNode *_spriteSheetJumping;
    CCSpriteBatchNode *_spriteSheetRoll;
    CCSpriteBatchNode *_spriteSheetDie;
}


@property (readwrite)bool isJumping;
@property (readwrite)bool isRolling;

@property (readwrite)bool isDying;
@property (nonatomic, retain)CCSprite *ninjaRunning;
@property (nonatomic, retain)CCSprite *ninjaJumping;
@property (nonatomic, retain)CCSprite *ninjaRoll;
@property (nonatomic, retain)CCSprite *ninjaDie;

@property (nonatomic,retain) id walkSpeedAction;
@property (nonatomic, retain)CCAction *jumpAction;
@property (nonatomic, retain)CCAction *rollAction;
@property (nonatomic, retain)CCAction *dieAction;

@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRunning;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetJumping;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetRoll;
@property (nonatomic, retain)CCSpriteBatchNode *spriteSheetDie;

-(void) jump;
-(void) doubleJump;
-(void) startRoll;
-(void) endRoll;
-(void) reloadAnimsWithSpeed:(double)geschwindigkeit;
-(void) die:(GameLayer *)gameLayer;

-(void) throwProjectile:(GameLayer *)gameLayer;

-(CCSprite*)getCurrentNinjaSprite;

@end
