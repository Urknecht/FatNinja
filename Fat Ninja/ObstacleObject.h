//
//  Obstacle.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCPhysicsSprite.h"
#import "GameLayer.h"


@interface ObstacleObject : CCPhysicsSprite{
    bool isRollable;
    bool isEatable;
    bool isShootable;
    bool isPowerUp;
    int type;
    CharacterStates enemyState;
    GameObjectType enemyType;
    float geschwindigkeit;
    CGSize wiSize;
    


}
@property(readonly) bool isEatable;
@property(readonly) bool isRollable;
@property(readonly) bool isShootable;
@property(readonly) bool isPowerUp;
@property(readonly) int type;
@property(readonly) float geschiwndigkeit;
@property(readonly) CGSize wiSize;
@property (readwrite) CharacterStates enemyState;
@property(readonly)  GameObjectType enemyType;


-(id) initWith: (float) geschw andWinSize: (CGSize) wSize;

-(void)changeState:(CharacterStates)newState;
-(void) loadAnim;


@end
