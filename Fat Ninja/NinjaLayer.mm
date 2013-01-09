//
//  NinjaLayer.m
//  Fat Ninja
//
//  Created by Verena Lerch on 1/8/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import "NinjaLayer.h"
#import "GameLayer.h"
#import "Constants.h"


@implementation NinjaLayer

-(id)init {
    self = [super init];
    if (self != nil) {
        self.isJumping= false;
        self.isDying = false;
        self.isRolling = false;
        [self loadAnims];
    }
    return self;
}

-(void) jump{
    if(!self.isJumping&&!self.isDying){
        
        self.isJumping=true;
        
        [_spriteSheetJumping setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaJumping runAction:self.jumpAction];
        [_ninjaRunning stopAction: self.walkSpeedAction];
        
        [_ninjaJumping runAction:
         [CCSequence actions:
          [CCJumpBy actionWithDuration:0.8f
                              position:ccp(0, 0)
                                height:65.0f
                                 jumps:1],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             self.isJumping=false;
             [_spriteSheetJumping setVisible:(false)];
             [_spriteSheetRunning setVisible:(true)];
             [_ninjaJumping stopAction:self.jumpAction];
             [_ninjaRunning runAction: self.walkSpeedAction];
         }],
          nil]];
    }
}

-(void) doubleJump{
    if(!self.isJumping&&!self.isDying){
        
        self.isJumping=true;
        [_spriteSheetJumping setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaJumping runAction:self.jumpAction];
        [_ninjaRunning stopAction: self.walkSpeedAction];
        
        [_ninjaJumping runAction:
         [CCSequence actions:
          [CCJumpBy actionWithDuration:0.5f
                              position:ccp(0, 0)
                                height:40.0f
                                 jumps:1],
          [CCJumpBy actionWithDuration:2.0f
                              position:ccp(0, 0)
                                height:165.0f
                                 jumps:1],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             self.isJumping=false;
             [_spriteSheetJumping setVisible:(false)];
             [_spriteSheetRunning setVisible:(true)];
             [_ninjaJumping stopAction:self.jumpAction];
             [_ninjaRunning runAction: self.walkSpeedAction];
             
         }],
          nil]];
    }
}

-(void) startRoll{
    if(!self.isRolling&&!self.isJumping&&!self.isDying){
        
        self.isRolling=true;
        [_spriteSheetRoll setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaRoll runAction:self.rollAction];
        [_ninjaRunning stopAction: self.walkSpeedAction];
    }
}

-(void) endRoll{
    if(self.isRolling){
    self.isRolling=false;
    [_spriteSheetRoll setVisible:(false)];
    [_spriteSheetRunning setVisible:(true)];
    [_ninjaRoll stopAction:self.rollAction];
    [_ninjaRunning runAction: self.walkSpeedAction];
    }
}

-(void) throwProjectile:(GameLayer *)gameLayer{
    if(!self.isRolling&&!self.isDying&&!self.isThrowing){
        
        self.isThrowing=true;
        
        if(self.isJumping){
            [_spriteSheetJumping setVisible:(false)];
            _ninjaThrow.position = _ninjaJumping.position;
        }
        [_spriteSheetThrow setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaRunning stopAction: self.walkSpeedAction];
        
        [_ninjaThrow runAction:
         [CCSequence actions: [CCAnimate actionWithAnimation:self.throwAnim],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             self.isThrowing=false;
                   [_spriteSheetThrow setVisible:(false)];
             if(self.isJumping){
                 [_spriteSheetJumping setVisible:(true)];
                 _ninjaThrow.position = _ninjaJumping.position;
             }
             else{       
             [_spriteSheetRunning setVisible:(true)];
             [_ninjaRunning runAction: self.walkSpeedAction];
             }
             
         }],
          nil]];
        
        [gameLayer throwProjectile];
    }
}

-(void) die:(GameLayer *)gameLayer{
    
    if(!self.isDying&&!self.isJumping&&!self.isThrowing){
        self.isDying = true;
        
        if(self.isRolling){
            [_ninjaRoll stopAction:self.rollAction];
        }
        else{
        [_ninjaRunning stopAction: self.walkSpeedAction];
        }
        NSLog(@"ninja1");
        
        [self removeChild:(_spriteSheetRoll)];
        [self removeChild:(_spriteSheetRunning)];
        [self removeChild:(_spriteSheetJumping)];
        [self removeChild:(_spriteSheetThrow)];
        NSLog(@"ninja2");
        [_spriteSheetDie setVisible:(true)];
        [_ninjaDie runAction:self.dieAction];        
        
        [_ninjaDie runAction:
         [CCSequence actions:
          [CCFadeTo actionWithDuration:3 opacity:0],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             [gameLayer endGame];
             //self.isDying = false;
         }], nil]];
    }
}




-(void)loadAnims{
    
    //RUNNING###########################################################
    //add the frames and coordinates to the cach
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaRunning.plist")];
    
    //load the sprite sheet into a CCSpriteBatchNode object. If you’re adding a new sprite
    //to your scene, and the image exists in this sprite sheet you should add the sprite
    //as a child of the same CCSpriteBatchNode object otherwise you could get an error.
    _spriteSheetRunning = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRunning.png"];
    //add the CCSpriteBatchNode to your scene
    [self addChild: _spriteSheetRunning];
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaRunning%d.png", i]]];
    }
    //Create the animation from the frame flyAnimFrames array
    CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
    //create a sprite and set it to be the first image in the sprite sheet
    _ninjaRunning = [CCSprite spriteWithSpriteFrameName:@"NinjaRunning1.png"];
    
    //create a looping action using the animation created above. This just continuosly
    //loops through each frame in the CCAnimation object
    
    
    self.walkSpeedAction = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:
                                                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]] speed:1.0f];
    [self.walkSpeedAction setTag:'walk'];
    
    //start the action
    [_ninjaRunning runAction: self.walkSpeedAction];
    
    //set its position to be dead center, i.e. screen width and height divided by 2
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _ninjaRunning.scale = (winSize.height / 400) ;
    _ninjaRunning.position = ccp(_ninjaRunning.contentSize.width / 2, winSize.height / 3);
    [_spriteSheetRunning addChild:_ninjaRunning];
    
    //JUMPING###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaJumping.plist")];
    _spriteSheetJumping = [CCSpriteBatchNode batchNodeWithFile:@"NinjaJumping.png"];
    [self addChild:_spriteSheetJumping];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *jumpAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [jumpAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaJumping%d.png", i]]];
    }
    
    CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpAnimFrames delay:0.05f];
    _ninjaJumping = [CCSprite spriteWithSpriteFrameName:@"NinjaJumping1.png"];
    
    self.jumpAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:jumpAnim]];
    _ninjaJumping.scale = (winSize.height / 400) ;
    _ninjaJumping.position = ccp(_ninjaJumping.contentSize.width / 2, winSize.height / 3);
    
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetJumping addChild:_ninjaJumping];
    [_spriteSheetJumping setVisible:(false)];
    
    
    
    //ROLLEN###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaRoll.plist")];
    _spriteSheetRoll = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRoll.png"];
    [self addChild:_spriteSheetRoll];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *rollAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [rollAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaRoll%d.png", i]]];
    }
    
    CCAnimation *rollAnim = [CCAnimation animationWithSpriteFrames:rollAnimFrames delay:0.02f];
    _ninjaRoll = [CCSprite spriteWithSpriteFrameName:@"NinjaRoll1.png"];
    
    self.rollAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:rollAnim]];
    _ninjaRoll.scale = (winSize.height / 350) ;
    _ninjaRoll.position = ccp(_ninjaRoll.contentSize.width / 2, winSize.height / 3);
    
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetRoll addChild:_ninjaRoll];
    [_spriteSheetRoll setVisible:(false)];
    
    //DIE##########################################################
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaDie.plist")];
    self.spriteSheetDie = [CCSpriteBatchNode batchNodeWithFile:@"NinjaDie.png"];
    [self addChild:_spriteSheetDie];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *dieAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [dieAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaDie%d.png", i]]];
    }
    
    CCAnimation *dieAnim = [CCAnimation animationWithSpriteFrames:dieAnimFrames delay:0.08f];
    _ninjaDie = [CCSprite spriteWithSpriteFrameName:@"NinjaDie1.png"];
    
    self.dieAction =  [CCAnimate actionWithAnimation:dieAnim];
    _ninjaDie.scale = (winSize.height / 400) ;
    _ninjaDie.position = ccp(_ninjaDie.contentSize.width / 2, winSize.height / 3);
    
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetDie addChild:_ninjaDie];
    [_spriteSheetDie setVisible:(false)];
    
    //THROW##########################################################    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaThrowShuricen.plist")];
    self.spriteSheetThrow = [CCSpriteBatchNode batchNodeWithFile:@"NinjaThrowShuricen.png"];
    [self addChild:_spriteSheetThrow];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *throwAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [throwAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaThrowShuricen%d.png", i]]];
    }
    
    self.throwAnim = [CCAnimation animationWithSpriteFrames:throwAnimFrames delay:0.08f];
    _ninjaThrow = [CCSprite spriteWithSpriteFrameName:@"NinjaThrowShuricen1.png"];
    
    //self.throwAction =  [CCAnimate actionWithAnimation:throwAnim];
    
    _ninjaThrow.scale = (winSize.height / 400) ;
    _ninjaThrow.position = ccp(_ninjaThrow.contentSize.width / 2, winSize.height / 3);
    
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetThrow addChild:_ninjaThrow];
    [_spriteSheetThrow setVisible:(false)];
    
}


-(void) reloadAnimsWithSpeed:(double)geschwindigkeit{
    id speedAction = [_ninjaRunning getActionByTag:'walk'];
    [speedAction setSpeed: (1.0f/geschwindigkeit)];
}

-(CCSprite*)getCurrentNinjaSprite{
    if(self.isJumping){
        return _ninjaJumping;
    }
    else if(self.isRolling){
        return _ninjaRoll;
    }
    else if(self.isDying){
        return _ninjaDie;
    }
    else if(self.isThrowing){
        return _ninjaThrow;
    }
    else{
        return _ninjaRunning;
    }
}


-(void)dealloc{
    [super dealloc];
    //TODO!
    
}


@end
