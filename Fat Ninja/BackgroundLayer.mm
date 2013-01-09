//
//  BackgroundLayer.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer
CCSprite *backgroundImage;
CCSprite *backgroundImage2;

-(id)init {
    self = [super init];
    if (self != nil) {
        
        // load background images
        backgroundImage= [CCSprite spriteWithFile:@"background1.png"];
        backgroundImage2= [CCSprite spriteWithFile:@"background2.png"];

        // set position
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [backgroundImage2 setPosition: CGPointMake(winSize.width+winSize.width/2, winSize.height/2)];

        [self addChild:backgroundImage z:0 tag:0];
        [self addChild:backgroundImage2 z:0 tag:0];

        //move image 1
        CCMoveTo * actionMove = [CCMoveTo actionWithDuration:7.0
                                                    position:ccp(backgroundImage.position.x
                                                                 -backgroundImage.contentSize.width, winSize.height/2)];
        CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
            [backgroundImage setPosition: CGPointMake(winSize.width+winSize.width/2, winSize.height/2)];
            CCMoveTo * actionMove2 = [CCMoveTo actionWithDuration:14.0
                                                         position:ccp(backgroundImage.position.x
                                                                      -backgroundImage.contentSize.width*2, winSize.height/2)];
            CCMoveTo * actionMoveDone2 = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width+0.5*winSize.width, winSize.height/2)];
            CCSequence *sequence2=[CCSequence actionOne:actionMove2 two:actionMoveDone2];
         //   CCRepeatForever *repeat2=[CCRepeatForever actionWithAction:sequence2];            
            id speedAction2 = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:sequence2] speed:1.0f];
            [speedAction2 setTag:'zwei'];
            [backgroundImage runAction:speedAction2];
        }];
        CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
        id speedAction = [CCSpeed actionWithAction: sequence speed:1.0f];
        [speedAction setTag:'eins'];                
        [backgroundImage runAction:speedAction];
        
        
        
        //move image 2
        CCMoveTo * actionMove2 = [CCMoveTo actionWithDuration:14.0
                                                    position:ccp(backgroundImage2.position.x
                                                                 -backgroundImage2.contentSize.width*2, winSize.height/2)];
        CCMoveTo * actionMoveDone2 = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width+0.5*winSize.width, winSize.height/2)];
        CCSequence *sequence2=[CCSequence actionOne:actionMove2 two:actionMoveDone2];
        id speedAction3 = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:sequence2] speed:1.0f];
        [speedAction3 setTag:'drei'];
        [backgroundImage2 runAction:speedAction3];
    
    }
    return self;    
}

-(void) reloadBackgroundWithSpeed:(double)geschwindigkeit{
    NSLog(@"changeSpeed");
    id speedAction = [backgroundImage getActionByTag:'eins'];
    [speedAction setSpeed:(1.0f/geschwindigkeit)];
    
    id speedAction2 = [backgroundImage getActionByTag:'zwei'];
    [speedAction2 setSpeed: (1.0f/geschwindigkeit)];
    
    id speedAction3 = [backgroundImage2 getActionByTag:'drei'];
    [speedAction3 setSpeed: (1.0f/geschwindigkeit)];
    
}

-(void) stopBackgroundAnimation{
    id speedAction = [backgroundImage getActionByTag:'eins'];
    [speedAction setSpeed:0];
    
    id speedAction2 = [backgroundImage getActionByTag:'zwei'];
    [speedAction2 setSpeed: 0];
    
    id speedAction3 = [backgroundImage2 getActionByTag:'drei'];
    [speedAction3 setSpeed: 0];

}

-(void)dealloc{
    [super dealloc];
    
}
@end
