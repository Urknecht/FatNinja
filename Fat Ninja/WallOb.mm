//
//  Wall.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "WallOb.h"

@implementation WallOb

-(id) initWith:(float)geschw andWinSize:(CGSize)wSize{
    if ((self = [super init])) {
        //self= [WallOb spriteWithFile:@"brokenwall.png"];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"brokenWall.plist")];
        self = [WallOb spriteWithSpriteFrameName: @"brokenWall1.png"];
        
        isRollable=true;
        isShootable=false;
        geschwindigkeit=geschw;
        wiSize=wSize;
        enemyType=Wall;
    }
    return self;
}

-(void) changeState:(CharacterStates)newState{
    [self stopAllActions];
    id action = nil;
    [self setEnemyState:newState];
    
    switch (newState) {
        case StateDie:
            
            NSLog(@"Break");
            [self runAction: self.breakAction];
            
            [self runAction:
             [CCSequence actions:
              [CCFadeTo actionWithDuration:0.5f opacity:0],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 
                 [(GameLayer *)[[self parent] parent] removeObstacle: self];
                 
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
    NSMutableArray *breakAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 7; ++i) {
        [breakAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"brokenWall%d.png", i]]];
    }
    CCAnimation *breakAnim = [CCAnimation animationWithSpriteFrames:breakAnimFrames delay:0.05f];
    self.breakAction =[CCAnimate actionWithAnimation:breakAnim];
    
    
    
}
@end
