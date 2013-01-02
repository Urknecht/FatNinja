//
//  Ninja.m
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "Ninja.h"
#import "Box2D.h"
#import "GameLayer.h"


#define JUMP_IMPULSE 6.0f
#define WALK_FACTOR 3.0f
#define MAX_WALK_IMPULSE 0.2f
#define ANIM_SPEED 0.3f
#define MAX_VX 2.0f

@implementation Ninja

-(id) initWithGameLayer:(GameLayer*)gl
{
    
    if(self)
    {
        // 4 - Store the game layer
        gameLayer = gl;
        //load player.png
        self=[CCSprite spriteWithFile:@"player.png"];
        
    }
    
    return self;
}


-(void)dealloc{
    [super dealloc];
    
    
}

@end
