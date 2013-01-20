//
//  Obstacle.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCSprite.h"

@interface ObstacleObject : CCSprite{
    bool isRollable;
    bool isEatable;
    bool isShootable;
    bool isPowerUp;
    int type;

}
@property(readonly) bool isEatable;
@property(readonly) bool isRollable;
@property(readonly) bool isShootable;
@property(readonly) bool isPowerUp;
@property(readonly) int type;


@end
