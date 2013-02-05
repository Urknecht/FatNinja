//
//  MinigameBreakout.h
//  Fat Ninja
//
//  Created by Florian Weiß on 1/26/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameLayer.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"

@interface MinigameBreakout : MinigameLayer{
    
    //GLESDebugDraw * debugDraw;
    
    b2Fixture *_ballFixture;
    b2Body *_paddleBody;
    b2Fixture *_paddleFixture;
    b2MouseJoint *_mouseJoint;
    MyContactListener *_contactListener;
    
    b2Body *ballBody;
    
}


@end
