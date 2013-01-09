//
//  EnemyLayer.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"

@interface EnemyLayer : CCLayer
{
    NSMutableArray *_enemyArray;
    NSMutableArray *_sushiArray;

    CCSprite *boxImage;
    bool nextStage;
}
@property(nonatomic, strong) NSMutableArray *_sushiArray;
@property(nonatomic, strong) NSMutableArray *_enemyArray;
@property(nonatomic, strong) CCSprite *boxImage;
@property(readwrite) bool nextStage;


-(void) addEnemy;
-(void) removeEnemy: (CCSprite*) enemy;
-(void) removeSushi: (CCSprite*) sushi;
-(void) addSushi;
-(void) stopAnimation;

@end
