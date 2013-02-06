//
//  MinigameScene.h
//  Fat Ninja
//
//  Created by Florian Weiß on 1/16/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCScene.h"
#import "cocos2d.h"

@interface MinigameScene : CCScene{
    
    NSString *game;
    NSString *description;
    NSInteger*_pointer;
    
}
@property (nonatomic, readwrite)NSInteger* pointer;

-(id)initWith: (int) gametype andPointer: (NSInteger*)pointer;

@end
