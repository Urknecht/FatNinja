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
            //sterbe animation, am ende muss gegner gelöscht werden
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

}

@end
