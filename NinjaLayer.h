//
//  NinjaLayer.h
//  Fat Ninja
//
//  Created by Verena Lerch on 1/8/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface NinjaLayer : CCLayer {
    CCSprite *_ninja;
    CCAction *_walkAction;
    bool isJumping;
    
}
@property (nonatomic, retain) CCSprite *ninja;
@property (nonatomic, retain) CCAction *walkAction;


@property (readwrite)bool isJumping;

-(void) jump;
-(void) doubleJump;

@end
