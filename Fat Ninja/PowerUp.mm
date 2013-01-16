//
//  PowerUp.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/13/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "PowerUp.h"

@implementation PowerUp

-(id) init{
    if ((self = [super init])) {
        type = arc4random()%3;
        self= [PowerUp spriteWithFile:@"powerup.png"];
        isPowerUp=true;
        isShootable=false;
    }
    return self;
}

@end
