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
    CCSprite *_ninja;
    CCAction *_walkAction;
}

-(id) initWithGameLayer:(GameLayer*)gl;
@property (nonatomic, retain) CCSprite *ninja;
@property (nonatomic, retain) CCAction *walkAction;


@end
