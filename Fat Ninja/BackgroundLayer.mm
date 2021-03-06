//
//  BackgroundLayer.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "BackgroundLayer.h"

@implementation BackgroundLayer
CGSize winSize;

-(id)init {
    self = [super initWithColor:ccc4(94,7,25,255)];
    if (self != nil) {
        
        // load background images
               _backgroundImage1= [CCSprite spriteWithFile:@"backgroundEmpty.png"];
                _backgroundImage2= [CCSprite spriteWithFile:@"backgroundEmpty.png"];

        _backgroundElements= [CCSprite spriteWithFile:@"backgroundElements1.png"];

        
               // set position
               CGSize winSize = [CCDirector sharedDirector].winSize;
               [_backgroundImage1 setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
                [_backgroundImage2 setPosition: CGPointMake(winSize.width+winSize.width/2, winSize.height/2)];
        [_backgroundElements setPosition: CGPointMake(winSize.width+winSize.width/2, winSize.height/2)];

                [self addChild:_backgroundImage1 z:0 tag:0];
                [self addChild:_backgroundImage2 z:0 tag:0];
        [self addChild:_backgroundElements z:0 tag:0];

        
                //move image 1
                CCMoveTo * actionMove = [CCMoveTo actionWithDuration:7.0
                                                            position:ccp(_backgroundImage1.position.x
                                                                         -winSize.width, winSize.height/2)];
                CCCallBlockN *actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
                    [_backgroundImage1 setPosition: CGPointMake(winSize.width+winSize.width/2, winSize.height/2)];
                    CCMoveTo * actionMove2 = [CCMoveTo actionWithDuration:14.0
                                                                 position:ccp(_backgroundImage1.position.x
                                                                              -winSize.width*2, winSize.height/2)];
                    CCMoveTo * actionMoveDone2 = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width+0.5*winSize.width, winSize.height/2)];
                    CCSequence *sequence2=[CCSequence actionOne:actionMove2 two:actionMoveDone2];
                 //   CCRepeatForever *repeat2=[CCRepeatForever actionWithAction:sequence2];
                    id speedAction2 = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:sequence2] speed:1.0f];
                    [speedAction2 setTag:'zwei'];
                    [_backgroundImage1 runAction:speedAction2];
                }];
                CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
                id speedAction = [CCSpeed actionWithAction: sequence speed:1.0f];
                [speedAction setTag:'eins'];
                [_backgroundImage1 runAction:speedAction];
        
        
        
                //move image 2
                CCMoveTo * actionMove2 = [CCMoveTo actionWithDuration:14.0
                                                            position:ccp(_backgroundImage2.position.x
                                                                         -winSize.width*2, winSize.height/2)];
                CCMoveTo * actionMoveDone2 = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width+0.5*winSize.width, winSize.height/2)];
                CCSequence *sequence2=[CCSequence actionOne:actionMove2 two:actionMoveDone2];
                id speedAction3 = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:sequence2] speed:1.0f];
                [speedAction3 setTag:'drei'];
                [_backgroundImage2 runAction:speedAction3];
        
        //move elements
        CCMoveTo * actionElement = [CCMoveTo actionWithDuration:10.0
                                                     position:ccp(_backgroundElements.position.x
                                                                  -winSize.width*2, winSize.height/2)];
        CCMoveTo * actionElementDone = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width+0.5*winSize.width, winSize.height/2)];
        CCSequence *sequenceElements=[CCSequence actionOne:actionElement two:actionElementDone];
        id speedElements = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:sequenceElements] speed:1.0f];
        [speedElements setTag:'vier'];
        [_backgroundElements runAction:speedElements];
        
    }
    return self;
}



-(void) reloadBackgroundWithSpeed:(double)geschwindigkeit{

    double speedChange=1.0f/geschwindigkeit;
    id speedAction2 = [_backgroundImage1 getActionByTag:'zwei'];
    [speedAction2 setSpeed: (speedChange)];
    
    id speedAction3 = [_backgroundImage2 getActionByTag:'drei'];
    [speedAction3 setSpeed: (speedChange)];
   
    id speedAction4 = [_backgroundElements getActionByTag:'vier'];
    [speedAction4 setSpeed: (speedChange)];

}

-(void) stopBackgroundAnimation{
    id speedAction = [_backgroundImage1 getActionByTag:'eins'];
    [speedAction setSpeed:0];
    
    id speedAction2 = [_backgroundImage1 getActionByTag:'zwei'];
    [speedAction2 setSpeed: 0];
    
    id speedAction3 = [_backgroundImage2 getActionByTag:'drei'];
    [speedAction3 setSpeed: 0];
    id speedAction4 = [_backgroundElements getActionByTag:'vier'];
    [speedAction4 setSpeed: 0];

    
}

-(void)dealloc{
    [super dealloc];
    
}
@end
