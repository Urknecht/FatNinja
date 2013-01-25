//
//  TutorialScene.h
//  Fat Ninja
//
//  Created by Manuel Graf on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"


@interface TutorialScene : CCScene{
    CCMenuItem *next;
    CCSprite *cursor;

}
@property(nonatomic,retain) CCSprite *cursor;
@property(nonatomic,retain) CCMenuItem *next;



-(id)init;

@end
