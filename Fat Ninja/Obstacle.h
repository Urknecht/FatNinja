//
//  Obstacle.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCSprite.h"

@interface Obstacle : CCSprite{
    bool isRollable;
    bool isEatable;
    bool isShootable;

}
@property(readonly) bool isEatable;
@property(readonly) bool isRollable;
@property(readonly) bool isShootable;


@end
