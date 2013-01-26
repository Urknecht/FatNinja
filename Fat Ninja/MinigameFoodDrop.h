//
//  MinigameFoodDrop.h
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameLayer.h"
#import "GLES-Render.h"
#import "Constants.h"
#import "GameObject.h"
#import "MyContactListener.h"




@class GameObject;

@interface MinigameFoodDrop : MinigameLayer{
    
    GLESDebugDraw * debugDraw;
    
    
    b2MouseJoint *_mouseJoint;
    MyContactListener *_contactListener;
    b2Body *_ninjaBody;
    b2Fixture *_ninjaFixture;
}

@end
