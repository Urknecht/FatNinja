//
//  Skelton.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "Skeleton.h"
#import "cocos2d.h"
#import "GameLayer.h"

@implementation Skeleton


-(id) initWith: (float) geschw andWinSize: (CGSize) wSize{
    if ((self = [super init])) {
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"skeletonDying.plist")];
        self = [Skeleton spriteWithSpriteFrameName: @"skeletonDying01.png"];
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
           
             [self runAction: self.dieAction];
            
            [self runAction:
             [CCSequence actions:
              [CCFadeTo actionWithDuration:0.8f opacity:0],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 
                 [(GameLayer *)[[self parent] parent] removeEnemy: self];
             
             }], nil]];                       
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

         
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *dieAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [dieAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"skeletonDying0%d.png", i]]];
    }
  
    
    CCAnimation *dieAnim = [CCAnimation animationWithSpriteFrames:dieAnimFrames delay:0.1f];
    self.dieAction =    [CCAnimate actionWithAnimation:dieAnim];


}

@end
