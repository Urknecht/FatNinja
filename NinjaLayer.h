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
//    CCSprite *_ninja;
        CCSprite *_ninjaRunning;
       CCSprite *_ninjaJumping;
    CCAction *_walkAction;
        CCAction *_jumpAction;
    bool isJumping;
    CCSpriteBatchNode *spriteSheetRunning;
    CCSpriteBatchNode *spriteSheetJumping;
    
    
}
//@property (nonatomic, retain) CCSprite *ninja;
@property (nonatomic, retain) CCAction *walkAction;
@property (nonatomic, retain) CCAction *jumpAction;


@property (readwrite)bool isJumping;

-(void) jump;
-(CCSprite*)getCurrentNinjaSprite;

@end
