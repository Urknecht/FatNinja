//
//  GameObject.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/19/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "GameObject.h"

@implementation GameObject
@synthesize reactsToScreenBoundaries;
@synthesize screenSize;
@synthesize isActive;
@synthesize gameObjectType;

-(id) init {
    if((self=[super init])){
        CCLOG(@"GameObject init");
        screenSize = [CCDirector sharedDirector].winSize;
        isActive = TRUE;
        gameObjectType = None;
    }
    return self;
}
-(void)changeState:(CharacterStates)newState {
    CCLOG(@"GameObject->changeState method should be overridden");
}
-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects {
    CCLOG(@"updateStateWithDeltaTime method should be overridden");
}
-(CGRect)adjustedBoundingBox {
    CCLOG(@"GameObect adjustedBoundingBox should be overridden");
    return [self boundingBox];
}
@end
