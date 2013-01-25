//
//  Stone.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/25/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "Stone.h"

@implementation Stone
-(id) initWith:(float)geschw andWinSize:(CGSize)wSize{
    if ((self = [super init])) {
        self= [Stone spriteWithFile:@"stone.png"];
        isEatable=false;
        isShootable=false;
        isRollable=false;
        geschwindigkeit=geschw;
        wiSize=wSize;
        enemyType=StoneType;
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
    
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration: geschwindigkeit
                                                position:ccp(self.position.x
                                                             -(wiSize.width+self.contentSize.width), wiSize.height/3)];
    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
    }];
    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
    [self runAction:sequence];
    
}

@end
