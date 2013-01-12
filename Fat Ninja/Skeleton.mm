//
//  Skelton.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "Skeleton.h"
#import "cocos2d.h"

@implementation Skeleton

-(id) init{
    if ((self = [super init])) {
        self= [Skeleton spriteWithFile:@"enemy.png"];
        isRollable=true;
        
    }
    return self;
}


@end
