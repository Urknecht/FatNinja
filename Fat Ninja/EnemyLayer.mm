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
#import "Wall.h"
#import "PowerUp.h"


@implementation EnemyLayer
@synthesize enemyArray;
//@synthesize _sushiArray;

@synthesize nextStage;
@synthesize geschwindigkeitEnemy;


int enemyCounter;
//nur für die Präsentation, später rausnehmen
int praesentationCounter;
double _geschwindigkeitSpawn;
int tag; //vorlaeufige variable zum auswaehlen welcher gegner auftaucht

-(id)init {
    self = [super init];
    if (self != nil) {
        tag=0;
        nextStage=false;
        
        praesentationCounter = 0;

        geschwindigkeitEnemy=5.0;
        _geschwindigkeitSpawn=3.5;
        
        enemyArray = [[NSMutableArray alloc] init];
       // _sushiArray = [[NSMutableArray alloc] init];

        [self schedule:@selector(spawnEnemy:)interval:_geschwindigkeitSpawn];


        
    }
    return self;
    }
-(void) spawnEnemy:(ccTime)dt{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    Obstacle *enemy;
    
    
    //Sucht eine Random Zahl zwischen 0 und einschließlich 2
    int randomTag = arc4random()%3;
    //NSLog(@"Hier sind die RandomTags: %i",randomTag);
    
    int randomPowerUp = arc4random()%1;
        
    if (praesentationCounter < 3) {
        randomTag = praesentationCounter;
        praesentationCounter++;
    }
    
//    tag=0;
    if(tag>3){
        tag=0;
    }
    switch (randomTag) {
        case 0:
            tag++;
            enemy=[[Skeleton alloc] init];
            break;
        case 1:
            tag++;
            enemy=[[Sushi alloc] init];
            break;
        case 2:
            tag++;
            enemy=[[Wall alloc] init];
            break;
                    
        default:
            break;
    }
    
    if (randomPowerUp == 0) {
        Obstacle *powerUp = [[PowerUp alloc] init];
        //spawnPowerUp = true;
        [enemyArray addObject:powerUp];
        int randomHeight = (arc4random() % 51)*3;
        [powerUp setPosition: CGPointMake(winSize.width, winSize.height/3+randomHeight)];
        [self addChild:powerUp];

        CCMoveTo * actionMovePowerUp = [CCMoveTo actionWithDuration: geschwindigkeitEnemy*0.5
                                                    position:ccp(self.position.x
                                                                 -winSize.width, winSize.height/3+randomHeight)];
        CCCallBlockN* actionMoveDonePowerUp = [CCCallBlockN actionWithBlock:^(CCNode *node){
            [node removeFromParentAndCleanup:YES];
            [enemyArray removeObject:node];
            //spawnPowerUp = false;
        }];
        CCSequence *sequencePowerUp=[CCSequence actionOne:actionMovePowerUp two:actionMoveDonePowerUp];
        [powerUp runAction:sequencePowerUp];

    }
    
    
    
    [enemyArray addObject:enemy];
    [enemy setPosition: CGPointMake(winSize.width, winSize.height/3)];
    [self addChild:enemy];
    CCMoveTo * actionMove = [CCMoveTo actionWithDuration: geschwindigkeitEnemy
                                                position:ccp(self.position.x
                                                             -winSize.width, winSize.height/3)];
    CCCallBlockN* actionMoveDone = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [node removeFromParentAndCleanup:YES];
        [enemyArray removeObject:node];
    }];
    CCSequence *sequence=[CCSequence actionOne:actionMove two:actionMoveDone];
    [enemy runAction:sequence];
    
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


-(void) removeObstacle: (CCSprite*) obstacle{
    [enemyArray removeObject:obstacle];
    [self removeChild:obstacle cleanup:YES];
}


-(void) stopAnimation{

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
