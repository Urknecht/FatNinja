//
//  GameObject.h
//  Fat Ninja
//
//  Created by Manuel Graf on 1/19/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCSprite.h"
#import "cocos2d.h"


@interface GameObject : CCSprite {
    BOOL isActive;
    BOOL reactsToScreenBoundaries;
    CGSize screenSize;
    GameObjectType gameObjectType;
}
@property (readwrite) BOOL isActive;
@property (readwrite) BOOL reactsToScreenBoundaries;
@property (readwrite) CGSize screenSize;
@property (readwrite) GameObjectType gameObjectType;
-(void)changeState:(CharacterStates)newState;
-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects;
-(CGRect)adjustedBoundingBox;
-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                andClassName:(NSString*)className;
@end
