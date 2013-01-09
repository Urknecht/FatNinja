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
@synthesize _sushiArray;

@synthesize boxImage;
@synthesize nextStage;

int enemyCounter;
double geschwindigkeitEnemy;
double geschwindigkeitSpawn;

-(id)init {
    self = [super init];
    if (self != nil) {
        nextStage=false;
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
        geschwindigkeitEnemy=5.0;
        geschwindigkeitSpawn=3.0;
        
        _enemyArray = [[NSMutableArray alloc] init];
        _sushiArray = [[NSMutableArray alloc] init];

        [self schedule:@selector(spawnEnemy:)interval:geschwindigkeitSpawn];


        
    }
    return self;
    }
-(void) spawnEnemy:(ccTime)dt{
    //random tag ermitteln-toDo
    int tag=0;
    switch (tag) {
        case 0:
            [self addEnemy];
            [self addSushi];
            enemyCounter++;
            break;
            
        default:
            break;
    }

    if(enemyCounter==5){ // nach 5 gegnern
        nextStage=true;
        if(geschwindigkeitEnemy>1.0){ // wird die geschwindigkeit der animation bis zu einem miminum erhoeht
            geschwindigkeitEnemy-=1.0;
        }
        if(geschwindigkeitSpawn>0.5){ // und der abstand zwischen den gegnern veringert
            geschwindigkeitSpawn-=0.5;
            [self schedule:@selector(spawnEnemy:)interval:geschwindigkeitSpawn];
        }
        enemyCounter=0;
    }
}

-(void) addEnemy{
    CCSprite *enemy= [CCSprite spriteWithFile:@"enemy.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [enemy setPosition: CGPointMake(winSize.width, winSize.height/3)];
    [self addChild:enemy z:0 tag:0];
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:geschwindigkeitEnemy
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

-(void) addSushi{
    CCSprite *sushi= [CCSprite spriteWithFile:@"sushi.png"];
    CGSize winSize = [CCDirector sharedDirector].winSize;
    [sushi setPosition: CGPointMake(winSize.width+100, winSize.height/3)];
    [self addChild:sushi z:0 tag:0];
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:geschwindigkeitEnemy+(geschwindigkeitEnemy/2)
                                                position:ccp(sushi.position.x
                                                             -(winSize.width+(winSize.width/2)), winSize.height/3)];
    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [node removeFromParentAndCleanup:YES];
        // CCCallBlockN in addMonster
        [_sushiArray removeObject:node];
    }];
    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
    [sushi runAction:sequence];
    sushi.tag = 1;
    [_sushiArray addObject:sushi];
    
}


-(void) removeEnemy: (CCSprite*) enemy{
    [_enemyArray removeObject:enemy];
    [self removeChild:enemy cleanup:YES];

}

-(void) removeSushi: (CCSprite*) sushi{
    [_sushiArray removeObject:sushi];
    [self removeChild:sushi cleanup:YES];
    
}

-(void)dealloc{
    [super dealloc];
    [_enemyArray release];
    _enemyArray=nil;
}
@end
