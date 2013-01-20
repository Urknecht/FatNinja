//
//  MinigameLayer.h
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"

@interface MinigameLayer : CCLayer{
    
    NSString *game;
    NSString *description;
    
}

@property(nonatomic, strong) NSString *game;
@property(nonatomic, strong) NSString *description;



@end

