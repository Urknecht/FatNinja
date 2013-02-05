//
//  Skelton.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "ObstacleObject.h"

@interface Skeleton : ObstacleObject{
        CCAction *_dieAction;    
}
@property (nonatomic, retain)CCAction *dieAction;


@end
