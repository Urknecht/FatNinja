//
//  MinigameScene.h
//  Fat Ninja
//
//  Created by Florian Weiß on 1/16/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCScene.h"

@interface MinigameScene : CCScene{
    
    NSString *game;
    NSString *description;
    
}

-(id)initWith: (int) gametype;

@end
