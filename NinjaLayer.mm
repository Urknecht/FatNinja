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
        spriteSheetRunning = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRunning.png"];
 
        //add the CCSpriteBatchNode to your scene
        [self addChild: spriteSheetRunning];
        
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
        _ninjaRunning = [CCSprite spriteWithSpriteFrameName:@"NinjaRunning1.png"];

        
        //create a looping action using the animation created above. This just continuosly
        //loops through each frame in the CCAnimation object
        
        self.walkAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:walkAnim]];
        
        //start the action
        [_ninjaRunning runAction:_walkAction];
        
        //JUMPING
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaJumping.plist")];
        
        spriteSheetJumping = [CCSpriteBatchNode batchNodeWithFile:@"NinjaJumping.png"];
        
        [self addChild:spriteSheetJumping];
        
        //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
        NSMutableArray *jumpAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 8; ++i) {
            [jumpAnimFrames addObject:
             [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
              [NSString stringWithFormat:@"NinjaJumping%d.png", i]]];
        }
        
        CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpAnimFrames delay:0.05f];
        _ninjaJumping = [CCSprite spriteWithSpriteFrameName:@"NinjaJumping1.png"];
        
        self.jumpAction = [CCRepeatForever actionWithAction:
                           [CCAnimate actionWithAnimation:jumpAnim]];
        
             
        //set its position to be dead center, i.e. screen width and height divided by 2
        CGSize winSize = [CCDirector sharedDirector].winSize;
        _ninjaJumping.scale = (winSize.height / 400) ;
        _ninjaRunning.scale = (winSize.height / 400) ;
        _ninjaJumping.position = ccp(_ninjaJumping.contentSize.width / 2, winSize.height / 3);
        _ninjaRunning.position = ccp(_ninjaRunning.contentSize.width / 2, winSize.height / 3);

        
        [spriteSheetJumping setVisible:(false)];
        
        //add the sprite to the CCSpriteBatchNode object
        [spriteSheetRunning addChild:_ninjaRunning];
        [spriteSheetJumping addChild:_ninjaJumping];
              
        
    }
    return self;
}

-(void) jump{
    if(!isJumping){
   
    isJumping=true;
        
        [spriteSheetJumping setVisible:(true)];
              [spriteSheetRunning setVisible:(false)];
                [_ninjaJumping runAction:_jumpAction];
                [_ninjaRunning stopAction: _walkAction];
  
        
        
    [_ninjaJumping runAction:
     [CCSequence actions:
      [CCJumpBy actionWithDuration:1.0f
                          position:ccp(0, 0)
                            height:65.0f
                             jumps:1],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         isJumping=false;
         [spriteSheetJumping setVisible:(false)];
         [spriteSheetRunning setVisible:(true)];
         [_ninjaJumping stopAction:_jumpAction];
         [_ninjaRunning runAction: _walkAction];
     }],
      nil]];
    }
}

-(void)loadAnims{
    
    
}

-(CCSprite*)getCurrentNinjaSprite{
    return _ninjaRunning;
}


-(void)dealloc{
    [super dealloc];
   //TODO!
    self.walkAction = nil;
}


@end
