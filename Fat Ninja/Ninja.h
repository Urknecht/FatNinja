//
//  Ninja.h
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "Cocos2d.h"
@class GameLayer;

@interface Ninja : CCSprite
{
    GameLayer *gameLayer;
}

-(id) initWithGameLayer:(GameLayer*)gl;
-(void) jump;


@end
