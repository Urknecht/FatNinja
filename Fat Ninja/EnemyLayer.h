//
//  EnemyLayer.h
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "cocos2d.h"
#import "Obstacle.h"

@interface EnemyLayer : CCLayer
{
    NSMutableArray *enemyArray;
   // NSMutableArray *_sushiArray;

    bool nextStage;
    double geschwindigkeitEnemy;
}
//@property(nonatomic, strong) NSMutableArray *_sushiArray;
@property(nonatomic, strong) NSMutableArray *enemyArray;
@property(readwrite) bool nextStage;
@property(readonly) double geschwindigkeitEnemy;



//-(void) addEnemy;
//-(void) removeEnemy: (CCSprite*) enemy;
//-(void) removeSushi: (CCSprite*) sushi;
//-(void) addSushi;
-(void)removeObstacle: (CCSprite*) enemy;
-(void) stopAnimation;

@end
