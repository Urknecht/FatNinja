//
//  BackgroundLayer.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface BackgroundLayer : CCLayer{
    CCSprite *_backgroundImage1;
    CCSprite *_backgroundImage2;
    
}
-(void) reloadBackgroundWithSpeed:(double)geschwindigkeit;
-(void) stopBackgroundAnimation;
@end
