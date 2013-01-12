 //
//  Obstacle.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "Obstacle.h"


@implementation Obstacle

@synthesize isRollable;
@synthesize isEatable;

-(id) init{
    if ((self = [super init])) {
        isEatable =false;
        isRollable=false;
        
    }
    return self;
}


-(void)dealloc{
    [super dealloc];
 }

@end
