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
        self= [WallOb spriteWithFile:@"brokenwall.png"];
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
            //sterbe animation  am ende muss gegner gelöscht werden
            break;
            
        default:
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

-(void)loadAnim{
    GameLayer *gl = (GameLayer *)[self.parent getChildByTag:gameLayerTag];
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration: geschwindigkeit
                                                position:ccp(self.position.x
                                                             -wiSize.width, wiSize.height/3)];
    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [node removeFromParentAndCleanup:YES];
        [gl.enemyArray removeObject:node];
    }];
    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
    [self runAction:sequence];
    
}
@end
