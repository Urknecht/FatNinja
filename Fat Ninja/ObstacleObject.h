//
//  Obstacle.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCPhysicsSprite.h"


@interface ObstacleObject : CCPhysicsSprite{
    bool isRollable;
    bool isEatable;
    bool isShootable;
    bool isPowerUp;
    int type;
    CharacterStates enemyState;
    GameObjectType enemyType;



}
@property(readonly) bool isEatable;
@property(readonly) bool isRollable;
@property(readonly) bool isShootable;
@property(readonly) bool isPowerUp;
@property(readonly) int type;
@property (readwrite) CharacterStates enemyState;
@property(readonly)  GameObjectType enemyType;


-(void)changeState:(CharacterStates)newState;


@end
