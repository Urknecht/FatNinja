//
//  Wall.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "ObstacleObject.h"

@interface WallOb : ObstacleObject{
    CCAction *_breakAction;
}
@property (nonatomic, retain)CCAction *breakAction;


@end
