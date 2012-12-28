//
//  BackgroundLayer.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer
-(id)init {
    self = [super init];
    if (self != nil) {
        // 3
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"background1.png"];
        CCSprite *backgroundImage2= [CCSprite spriteWithFile:@"background2.png"];

        // 1 // 2
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [backgroundImage2 setPosition: CGPointMake(winSize.width+winSize.width/2, winSize.height/2)];

        [self addChild:backgroundImage z:0 tag:0];
        [self addChild:backgroundImage2 z:0 tag:0];

        
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
            CCRepeatForever *repeat2=[CCRepeatForever actionWithAction:sequence2];
            [backgroundImage runAction:repeat2];
        }];
        CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
        [backgroundImage runAction:sequence];
        
        CCMoveTo * actionMove2 = [CCMoveTo actionWithDuration:14.0
                                                    position:ccp(backgroundImage2.position.x
                                                                 -backgroundImage2.contentSize.width*2, winSize.height/2)];
        CCMoveTo * actionMoveDone2 = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width+0.5*winSize.width, winSize.height/2)];
        CCSequence *sequence2=[CCSequence actionOne:actionMove2 two:actionMoveDone2];
        CCRepeatForever *repeat2=[CCRepeatForever actionWithAction:sequence2];
        [backgroundImage2 runAction:repeat2];
    
    }
    return self;
    
}
@end
