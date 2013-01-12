//
//  EnemyLayer.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 12/16/12.
//  Copyright (c) 2012 Florian Weiß. All rights reserved.
//

#import "EnemyLayer.h"
#import "Skeleton.h"
#import "Sushi.h"


@implementation EnemyLayer
@synthesize enemyArray;
//@synthesize _sushiArray;

@synthesize nextStage;
@synthesize geschwindigkeitEnemy;


int enemyCounter;
double _geschwindigkeitSpawn;
int tag; //vorlaeufige variable zum auswaehlen welcher gegner auftaucht

-(id)init {
    self = [super init];
    if (self != nil) {
        tag=0;
        nextStage=false;

        geschwindigkeitEnemy=5.0;
        _geschwindigkeitSpawn=3.0;
        
        enemyArray = [[NSMutableArray alloc] init];
       // _sushiArray = [[NSMutableArray alloc] init];

        [self schedule:@selector(spawnEnemy:)interval:_geschwindigkeitSpawn];


        
    }
    return self;
    }
-(void) spawnEnemy:(ccTime)dt{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    Obstacle *enemy;
    //random tag ermitteln-toDo
//    tag=0;
    switch (tag) {
        case 0:
            tag++;
            enemy=[[Skeleton alloc] init];
            break;
        case 1:
            tag++;
            enemy=[[Sushi alloc] init];
            break;
            
        default:
            break;
    }
    [enemyArray addObject:enemy];
    [enemy setPosition: CGPointMake(winSize.width, winSize.height/3)];
    [self addChild:enemy z:0 tag:0];
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration: geschwindigkeitEnemy
                                                position:ccp(self.position.x
                                                             -winSize.width, winSize.height/3)];
    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [node removeFromParentAndCleanup:YES];
        [enemyArray removeObject:node];
    }];
    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
    [enemy runAction:sequence];
    enemy.tag = 1;
    enemyCounter++;

    if(enemyCounter==5){ // nach 5 gegnern
        nextStage=true;
        if(geschwindigkeitEnemy>1.0){ // wird die geschwindigkeit der animation bis zu einem miminum erhoeht
            geschwindigkeitEnemy-=1.0;
        }
        if(_geschwindigkeitSpawn>0.5){ // und der abstand zwischen den gegnern veringert
            _geschwindigkeitSpawn-=0.5;
            [self schedule:@selector(spawnEnemy:)interval:_geschwindigkeitSpawn];
        }
        enemyCounter=0;
    }
}

//-(void) addEnemy{
//    CCSprite *enemy= [CCSprite spriteWithFile:@"enemy.png"];
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    [enemy setPosition: CGPointMake(winSize.width, winSize.height/3)];
//    [self addChild:enemy z:0 tag:0];
//    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:geschwindigkeitEnemy
//                                                position:ccp(enemy.position.x
//                                                             -winSize.width, winSize.height/3)];
//    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
//        [node removeFromParentAndCleanup:YES];
//        // CCCallBlockN in addMonster
//        [enemyArray removeObject:node];
//    }];
//    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
//    //CCRepeatForever *repeat=[CCRepeatForever actionWithAction:sequence];
//    [enemy runAction:sequence];
//    enemy.tag = 1;
//    [enemyArray addObject:enemy];
//}

//-(void) addSushi{
//    CCSprite *sushi= [CCSprite spriteWithFile:@"sushi.png"];
//    CGSize winSize = [CCDirector sharedDirector].winSize;
//    [sushi setPosition: CGPointMake(winSize.width+100, winSize.height/3)];
//    [self addChild:sushi z:0 tag:0];
//    CCMoveTo * actionMove = [CCMoveTo actionWithDuration:geschwindigkeitEnemy+(geschwindigkeitEnemy/2)
//                                                position:ccp(sushi.position.x
//                                                             -(winSize.width+(winSize.width/2)), winSize.height/3)];
//    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
//        [node removeFromParentAndCleanup:YES];
//        // CCCallBlockN in addMonster
//        [_sushiArray removeObject:node];
//    }];
//    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
//    [sushi runAction:sequence];
//    sushi.tag = 1;
//    [_sushiArray addObject:sushi];
//    
//}
//
//
//-(void) removeEnemy: (CCSprite*) enemy{
//    [enemyArray removeObject:enemy];
//    [self removeChild:enemy cleanup:YES];
//
//}
//
//-(void) removeSushi: (CCSprite*) sushi{
//    [_sushiArray removeObject:sushi];
//    [self removeChild:sushi cleanup:YES];
//    
//}


-(void) removeObstacle: (CCSprite*) obstacle{
    [enemyArray removeObject:obstacle];
    [self removeChild:obstacle cleanup:YES];
}

-(void) stopAnimation{
//    for (CCSprite *sushi in self._sushiArray) {
//        [sushi stopAllActions];
//    }
    for (CCSprite *enemy in self.enemyArray) {
        [enemy stopAllActions];
    }
}


-(void)dealloc{
    [super dealloc];
    [enemyArray release];
    enemyArray=nil;
}
@end
