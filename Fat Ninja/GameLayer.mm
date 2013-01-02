//
//  GameScene.m
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright 2012 Florian Weiß. All rights reserved.
//

#import "GameLayer.h"
#import "Ninja.h"
#import "EnemyLayer.h"
#import "HelloWorldLayer.h"
#import "GameOverScene.h"
#import "GameScene.h"



@implementation GameLayer
//startpunkt für swipe ueberpruefung
CGPoint _startPoint;
//endpunkt für swipe ueberpruefung
CGPoint _endPoint;
//gibt an ob ninja gerade springt
bool isJumping;
//array welches die wurfsterne enthaelt
NSMutableArray * _projectiles;


- (id) init
{
    if ((self = [super init])) {
        //ninja initialisieren
        ninja = [[Ninja alloc] initWithGameLayer:self];
        
        //position ninja
        CGSize winSize = [CCDirector sharedDirector].winSize;
        ninja.position = ccp(ninja.contentSize.width/2, winSize.height/3);
        [self addChild:ninja];
        
        isJumping=false;
        
        //enemy layer
        enemyLayer=[EnemyLayer node];
        [self addChild:enemyLayer z:2];
        [self schedule:@selector(updateNinjaIsHit:)]; // immer wieder pruefen ob ninja getroffen wurde

        _projectiles = [[NSMutableArray alloc] init];

        [self schedule:@selector(update:)]; // ueberpruefen ob monster abgeworfen wurden
        
    }
    
    [self setTouchEnabled:YES];

    
    return self;
    
    
}

//ueberprueft ob ninja getroffen wurde
-(void) updateNinjaIsHit:(ccTime)delta{
    for (CCSprite *enemy in enemyLayer._enemyArray) {

    if (CGRectIntersectsRect(ninja.boundingBox, enemy.boundingBox)) {
        isJumping=false;
        // zu GameOver Scene 
        [[CCDirector sharedDirector] replaceScene:[GameOverScene node]];

    }
    }
}

//pruefen ob monster agbeschossen wurden
- (void)update:(ccTime)dt {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        NSMutableArray *enemyToDelete = [[NSMutableArray alloc] init];
        for (CCSprite *enemy in enemyLayer._enemyArray) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, enemy.boundingBox)) {
                [enemyToDelete addObject:enemy];
            }
        }
        
        for (CCSprite *enemy in enemyToDelete) {
            [enemyLayer removeEnemy:enemy];
            [self removeChild:enemy cleanup:YES];
        }
        
        if (enemyToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
        [enemyToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    
    
}

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Anfangs und endpunkte vom touch speichern
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _startPoint = location;
        _endPoint = location;
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //endpunkt speichern
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint = location;
    }
    // Choose one of the touches to work with
    UITouch *touch = [touches anyObject];
    
    //ueberpruefen wie weit start und endpunkt in x richtung von einander entfernt sind --> swipe
    if (_endPoint.x-_startPoint.x>10) {

    CGPoint location = [self convertTouchToNodeSpace:touch];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"projectile.png"];
    projectile.position = ninja.position;
    
    // Determine offset of location to projectile
    CGPoint offset = ccpSub(location, projectile.position);
    
    // Bail out if you are shooting down or backwards
    if (offset.x <= 0) return;
    
    // Ok to add now - we've double checked position
    [self addChild:projectile];
    
    int realX = winSize.width + (projectile.contentSize.width/2);
    float ratio = (float) offset.y / (float) offset.x;
    int realY = (realX * ratio) + projectile.position.y;
    CGPoint realDest = ccp(realX, realY);
    
    // Determine the length of how far you're shooting
    int offRealX = realX - projectile.position.x;
    int offRealY = realY - projectile.position.y;
    float length = sqrtf((offRealX*offRealX)+(offRealY*offRealY));
    float velocity = 480/1; // 480pixels/1sec
    float realMoveDuration = length/velocity;
    
    // Move projectile to actual endpoint
    [projectile runAction:
     [CCSequence actions:
      [CCMoveTo actionWithDuration:realMoveDuration position:realDest],
      [CCCallBlockN actionWithBlock:^(CCNode *node) {
         // CCCallBlockN in ccTouchesEnded
         [_projectiles removeObject:node];
         [node removeFromParentAndCleanup:YES];
     }],
      nil]];
        projectile.tag = 2;
        [_projectiles addObject:projectile];
    }else {
        if(!isJumping){
            isJumping=true;
            [ninja runAction:
             [CCSequence actions:
              [CCJumpBy actionWithDuration:1.0f
                                  position:ccp(0, 0)
                                    height:65.0f
                                  jumps:1],
              [CCCallBlockN actionWithBlock:^(CCNode *node) {
                 isJumping=false;             }],
              nil]];

        }else{}
        
    }
    
}

- (void) dealloc
{
    
    [super dealloc];
    [_projectiles release];
    _projectiles = nil;
        
    
}

@end
