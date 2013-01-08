//
//  NinjaLayer.m
//  Fat Ninja
//
//  Created by Verena Lerch on 1/8/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import "NinjaLayer.h"


@implementation NinjaLayer

-(id)init {
    self = [super init];
    if (self != nil) {
        
        self.isJumping= false;
                
        //add the frames and coordinates to the cach
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaRunning.plist")];
        
        //load the sprite sheet into a CCSpriteBatchNode object. If you’re adding a new sprite
        //to your scene, and the image exists in this sprite sheet you should add the sprite
        //as a child of the same CCSpriteBatchNode object otherwise you could get an error.
        
        CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRunning.png"];
        //add the CCSpriteBatchNode to your scene
        [self addChild:spriteSheet];
        
        //load each frame included in the sprite sheet into an array for use with the CCAnimation object below        
        NSMutableArray *walkAnimFrames = [NSMutableArray array];
        
        for(int i = 1; i <= 8; ++i) {            
            [walkAnimFrames addObject:             
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:              
              [NSString stringWithFormat:@"NinjaRunning%d.png", i]]];            
        }
        
        //Create the animation from the frame flyAnimFrames array
        CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
        
        
        //create a sprite and set it to be the first image in the sprite sheet
        self.ninja = [CCSprite spriteWithSpriteFrameName:@"NinjaRunning1.png"];
        
        //set its position to be dead center, i.e. screen width and height divided by 2
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _ninja.scale = (winSize.height / 400) ;
        _ninja.position = ccp(_ninja.contentSize.width / 2, winSize.height / 3);
      
        
        //create a looping action using the animation created above. This just continuosly
        //loops through each frame in the CCAnimation object
        
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim]];
        
        //start the action        
        [_ninja runAction:_walkAction];
        
        //add the sprite to the CCSpriteBatchNode object
        
        [spriteSheet addChild:_ninja];
    }
    return self;
}

-(void) jump{
    if(!isJumping){
    
    isJumping=true;
    [_ninja runAction:
     [CCSequence actions:
      [CCJumpBy actionWithDuration:1.0f
                          position:ccp(0, 0)
                            height:65.0f
                             jumps:1],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         isJumping=false;             }],
      nil]];
    }
}

-(void) doubleJump{
    if(!isJumping){
        
        isJumping=true;
        [_ninja runAction:
         [CCSequence actions:
          [CCJumpBy actionWithDuration:1.0f
                              position:ccp(0, 0)
                                height:65.0f
                                 jumps:1],        
          [CCJumpBy actionWithDuration:2.0f
                              position:ccp(0, 0)
                                height:165.0f
                                 jumps:1],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             isJumping=false;             }],
          nil]];
    }
}



-(void)dealloc{
    [super dealloc];
    self.ninja = nil;
    self.walkAction = nil;
}


@end
