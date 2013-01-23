//
//  Sushi.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "SushiOb.h"

@implementation SushiOb


-(id) initWith:(float)geschw andWinSize:(CGSize)wSize{
    if ((self = [super init])) {
        self= [SushiOb spriteWithFile:@"icon-sushi.png"];
        isEatable=true;
        isShootable=true;
        geschwindigkeit=geschw;
        wiSize=wSize;
        enemyType=Sushi;
        //lol
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