//
//  Skelton.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "Skeleton.h"
#import "cocos2d.h"

@implementation Skeleton


-(id) initWith: (float) geschw andWinSize: (CGSize) wSize{
    if ((self = [super init])) {
        self= [Skeleton spriteWithFile:@"enemy.png"];
        isRollable=true;
        isShootable=true;
        geschwindigkeit=geschw;
        wiSize=wSize;
        enemyType=Enemy;
    }
    return self;
}

-(void) changeState:(CharacterStates)newState{
    [self stopAllActions];
    id action = nil;
    [self setEnemyState:newState];
    
    switch (newState) {
        case StateDie:
            self = [Skeleton spriteWithSpriteFrameName: @"skeletonDying01.png"];
            [_spriteSheetDying addChild:self];
             [[self parent]  addChild:_spriteSheetDying];
            
             [self runAction: self.dieAction];
            
           
            NSLog(@"ENEMYDie");
            break;
            
        default:
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)loadAnim{
    
        CCMoveTo * actionMove = [CCMoveTo actionWithDuration: geschwindigkeit
                                                    position:ccp(self.position.x
                                                                 -(wiSize.width+self.contentSize.width), wiSize.height/3)];
        CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
                    }];
        CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
        [self runAction:sequence];
    
    
    
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"skeletonDying.plist")];
    _spriteSheetDying = [CCSpriteBatchNode batchNodeWithFile:@"skeletonDying.png"];
    //[[self parent]  addChild:_spriteSheetDying];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *dieAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [dieAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"skeletonDying0%d.png", i]]];
    }
    
    CCAnimation *dieAnim = [CCAnimation animationWithSpriteFrames:dieAnimFrames delay:0.05f];
    //_skeletonDie = [CCPhysicsSprite spriteWithSpriteFrameName:@"skeletonDying01.png"];
    
    self.dieAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:dieAnim]];
    _skeletonDie.scale = (wiSize.height / 400) ;
    
    //[_skeletonDie setPTMRatio:PTM_RATIO];
	//[_skeletonDie setBody:bodyNinja];
	//[_skeletonDie setPosition: location];
    
    //add the sprite to the CCSpriteBatchNode object
    //[_spriteSheetDying addChild:_skeletonDie];
    [_spriteSheetDying setVisible:(true)];
    

}

@end
