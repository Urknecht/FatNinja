//
//  EnemyLayer.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "EnemyLayer.h"

@implementation EnemyLayer
@synthesize _enemyArray;
@synthesize boxImage;


-(id)init {
    self = [super init];
    if (self != nil) {
        // position,animation enemy
        
        
        // position,animation box
//        boxImage= [CCSprite spriteWithFile:@"blocks.png"];
//        [boxImage setPosition: CGPointMake(winSize.width/2, winSize.height/3)];
//        [self addChild:boxImage z:0 tag:0];
//        CCMoveTo * actionBoxMove = [CCMoveTo actionWithDuration:5.0
//                                                    position:ccp(boxImage.position.x
//                                                                 -winSize.width, winSize.height/3)];
//        CCMoveTo * actionBoxMoveDone = [CCMoveTo actionWithDuration:0 position:CGPointMake(winSize.width/2, winSize.height/3)];
//        CCSequence *sequenceBox=[CCSequence actionOne:actionBoxMove two:actionBoxMoveDone];
//        CCRepeatForever *repeatBox=[CCRepeatForever actionWithAction:sequenceBox];
//        [boxImage runAction:repeatBox];
        _enemyArray = [[NSMutableArray alloc] init];
        [self schedule:@selector(spawnEnemy:)interval:3.0];


        
    }
    return self;
    }
-(void) spawnEnemy:(ccTime)dt{
    [self addEnemy];
}

-(void) addEnemy{
    CCSprite *enemy= [CCSprite spriteWithFile:@"enemy.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [enemy setPosition: CGPointMake(winSize.width, winSize.height/3)];
    [self addChild:enemy z:0 tag:0];
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:5.0
                                                position:ccp(enemy.position.x
                                                             -winSize.width, winSize.height/3)];
    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [node removeFromParentAndCleanup:YES];
        // CCCallBlockN in addMonster
        [_enemyArray removeObject:node];
    }];
    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
    //CCRepeatForever *repeat=[CCRepeatForever actionWithAction:sequence];
    [enemy runAction:sequence];
    enemy.tag = 1;
    [_enemyArray addObject:enemy];
}
-(void) removeEnemy: (CCSprite*) enemy{
    [_enemyArray removeObject:enemy];
    [self removeChild:enemy cleanup:YES];

}

-(void)dealloc{
    [super dealloc];
    [_enemyArray release];
    _enemyArray=nil;
}
@end
