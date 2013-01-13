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
        self= [PowerUp spriteWithFile:@"shuriken.png"];
        isEatable=true;
        isShootable=false;
    }
    return self;
}

@end
