//
//  GameScene.m
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright 2012 Florian Weiß. All rights reserved.
//

#import "GameLayer.h"
#import "EnemyLayer.h"
#import "NinjaLayer.h"
#import "HelloWorldLayer.h"
#import "GameOverScene.h"
#import "GameScene.h"
#import "BackgroundLayer.h"
#import "math.h"
#import "Constants.h"



@implementation GameLayer
@synthesize isPaused;
@synthesize distance;

//startpunkt für swipe ueberpruefung
CGPoint _startPoint;
//endpunkt für swipe ueberpruefung
CGPoint _endPoint;
bool isRolling;
//array welches die wurfsterne enthaelt
NSMutableArray * _projectiles;
int sushiCounter;
// Distanz
int distance;
//Punkte Label
CCLabelTTF *punkte;
//Punkte Label
CCLabelTTF *sushiLabel;

UITouch *lastTouch;



- (id) init
{
    if ((self = [super init])) {
        
        
        //        //ninja initialisieren
        //        ninja = [[Ninja alloc] initWithGameLayer:self];
        //
        
        isRolling=false;
        isPaused=false;
        
        // backgorund layer
        backgroundLayer =[BackgroundLayer node];
        [self addChild:backgroundLayer z:0 tag:backgroundLayerTag];
        
        //ninja layer
        ninjaLayer=[NinjaLayer node];
        [self addChild:ninjaLayer z:1];
        
        //enemy layer
        enemyLayer=[EnemyLayer node];
        [self addChild:enemyLayer z:2];
        [self schedule:@selector(updateNinjaIsHit:)]; //immer wieder pruefen ob ninja getroffen wurde
        
 
        
        _projectiles = [[NSMutableArray alloc] init];
        
        [self schedule:@selector(updateMonsterIsHit:)]; // ueberpruefen ob monster abgeworfen wurden
        //geschwindigkeit in der die distanz erhoeht wird
        self.geschwindigkeit= 1.0;
        //Distanz
        distance=0;
        
        //punkte anzeige
        CGSize winSize = [CCDirector sharedDirector].winSize;
        punkte = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:25];
        [self addChild:punkte z:0];
        punkte.position = ccp(winSize.width-20, winSize.height-20);
        [self schedule:@selector(updateDistance:)interval:self.geschwindigkeit];
        
        //Sushi anzeige
        sushiCounter=0;
        CCSprite *sushiImage= [CCSprite spriteWithFile:@"sushi.png"];
        [self addChild:sushiImage];
        sushiImage.position= ccp(winSize.width-80, winSize.height-50);
        
        sushiLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:25];
        [self addChild:sushiLabel];
        sushiLabel.position = ccp(winSize.width-20, winSize.height-50);
        [self schedule:@selector(updateSushiEaten:)];

    }
    
    [self setTouchEnabled:YES];
    
    return self;
    
}


- (void)updateDistance:(ccTime)dt {
    distance ++;
    [punkte setString:[NSString stringWithFormat:@"%i",distance]]; // anzeige anpassen
    if(enemyLayer.nextStage){ //nach bestimmter anzahl
        if(self.geschwindigkeit>0.21){ // wird bis zu minimum geschwindigkeit
            self.geschwindigkeit-=0.2; // die geschiwndigkeit angepasst
            [ninjaLayer reloadAnimsWithSpeed:self.geschwindigkeit];
            [backgroundLayer reloadBackgroundWithSpeed:self.geschwindigkeit];
            [self schedule:@selector(updateDistance:)interval:self.geschwindigkeit];

        }
        [enemyLayer setNextStage:false];
        
    }
    
    
}

-(void) updateSushiEaten:(ccTime) dt{
    NSMutableArray *sushiToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *sushi in enemyLayer._sushiArray) {
        
        if (CGRectIntersectsRect([ninjaLayer getCurrentNinjaSprite].boundingBox, sushi.boundingBox)) {
            sushiCounter++;
            [sushiLabel setString:[NSString stringWithFormat:@"%i",sushiCounter]]; // anzeige anpassen
            [sushiToDelete addObject:sushi];

        }
    }
    for (CCSprite *sushi in sushiToDelete) {
        [enemyLayer removeSushi:sushi];
        [self removeChild:sushi cleanup:YES];
    }
    [sushiToDelete release];

}

//ueberprueft ob ninja getroffen wurde
-(void) updateNinjaIsHit:(ccTime)delta{
    NSMutableArray *enemyToDeleteRolling = [[NSMutableArray alloc] init];

    for (CCSprite *enemy in enemyLayer._enemyArray) {
        
        if (CGRectIntersectsRect([ninjaLayer getCurrentNinjaSprite].boundingBox, enemy.boundingBox)) {
            // zu GameOver Scene
            if(!isRolling){
                
                [self stopGame];
                [ninjaLayer die:self];
            }
            else{
                [enemyToDeleteRolling addObject:enemy];
            }
        }
    }
    for (CCSprite *enemy in enemyToDeleteRolling) {
        [enemyLayer removeEnemy:enemy];
        [self removeChild:enemy cleanup:YES];
    }
    [enemyToDeleteRolling release];
}

-(void) stopGame{
    //Leider ging es nicht über Pause zu machen, deswegen eigene funktion:
    [backgroundLayer stopBackgroundAnimation];
}

-(void) endGame{
    [[CCDirector sharedDirector] replaceScene:[[GameOverScene alloc] initWith:distance andSushi: sushiCounter]];
}

//pruefen ob monster agbeschossen wurden
- (void)updateMonsterIsHit:(ccTime)dt {
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

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint=location;
    }
    if (_startPoint.y-_endPoint.y>10 and abs(_endPoint.x-_startPoint.x)<5) {
        isRolling=true;
        [ninjaLayer startRoll];
        
        
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = [touch tapCount];
    lastTouch = touch;
    
    //endpunkt speichern
    for (UITouch *touch in touches){
        CGPoint location = [touch locationInView:[touch view]];
        location = [[CCDirector sharedDirector] convertToGL:location];
        _endPoint = location;
    }

    if(isRolling){
        isRolling=false;
        [ninjaLayer endRoll];
    }
    
    // Choose one of the touches to work with
    else if(isPaused){
        
    }
    //ueberpruefen wie weit start und endpunkt in x richtung von einander entfernt sind --> swipe
    else if (_endPoint.x-_startPoint.x>10) {
        
        [ninjaLayer throwProjectile:self];
        
        
    }
    //Hier werden die Fälle für Single und DoubleTap abgeprüft
    else if (tapCount == 1){
        //Wenn Single Tap ist führt er die Methode für normalen Jump aus
        [self performSelector:@selector(singleTapMethod) withObject:nil afterDelay:0.4];
        
    }else if (tapCount == 2){
        //Im Fall von DoubleTap bricht er die Animation vo, normalen Jump ab und startet die für den DoubleJump
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapMethod) object:nil];
        [self performSelector:@selector(doubleTapMethod) withObject:nil afterDelay:0];
        
    }
}

-(void)throwProjectile{
    CGPoint location = [self convertTouchToNodeSpace:lastTouch];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"shuriken.png"];
    projectile.position = [ninjaLayer getCurrentNinjaSprite].position;
    
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
    
    [projectile runAction: [CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:0.08 angle:-360]]];
    projectile.tag = 2;
    [_projectiles addObject:projectile];
}

-(void)singleTapMethod{
    [ninjaLayer jump];
}

-(void)doubleTapMethod{
    [ninjaLayer doubleJump];
}

-(void)pauseGame
{
    [[CCDirector sharedDirector] pause];
}

- (void) dealloc
{
    
    [super dealloc];
    [_projectiles release];
    _projectiles = nil;
    
    
}

@end
