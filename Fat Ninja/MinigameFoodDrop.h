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

#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == \
UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

@interface MinigameFoodDrop : MinigameLayer{
    b2World * world;
    GLESDebugDraw * debugDraw;
}

@end
