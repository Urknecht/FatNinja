 //
//  Obstacle.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "ObstacleObject.h"


@implementation ObstacleObject

@synthesize isRollable;
@synthesize isEatable;
@synthesize isShootable;
@synthesize isPowerUp;
@synthesize type,enemyState,enemyType,wiSize,geschiwndigkeit;



-(id) initWith:(float)geschw andWinSize:(CGSize)wSize{
    if ((self = [super init])) {
        isEatable =false;
        isRollable=false;
        isShootable=false;
        isPowerUp=false;
        type = -1;
        enemyState=StateStart;
    }
    return self;
}

-(void)changeState:(CharacterStates)newState{
    
}


-(void)loadAnim{
    
}

-(void)dealloc{
    [super dealloc];
 }

@end
