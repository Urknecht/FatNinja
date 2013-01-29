//
//  PowerUp.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/13/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "PowerUp.h"

@implementation PowerUp


-(id) initWith:(float)geschw andWinSize:(CGSize)wSize{
    if ((self = [super init])) {
        type = arc4random()%2;
        self= [PowerUp spriteWithFile:@"powerup.png"];
        isEatable=false;
        isShootable=false;
        isRollable=false;
        isPowerUp=true;
        isShootable=true;
        enemyType=Powerup;
        geschwindigkeit=geschw;
        wiSize=wSize;
        enemyType=Powerup;
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
/*
-(id) init{
    if ((self = [super init])) {
        type = arc4random()%3;
        self= [PowerUp spriteWithFile:@"powerup.png"];
        isPowerUp=true;
        isShootable=true;
        enemyType=Powerup;
    }
    return self;
}
 */

@end
