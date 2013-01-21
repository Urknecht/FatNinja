//
//  GameScene.m
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright 2012 Florian Weiß. All rights reserved.
//
#import "GameLayer.h"
#import "Ninja.h"
#import "HelloWorldLayer.h"
#import "GameOverScene.h"
#import "GameScene.h"
#import "BackgroundLayer.h"
#import "math.h"
#import "Constants.h"
#import "ObstacleObject.h"
#import "MinigameScene.h"
#import "Skeleton.h"
#import "Sushi.h"
#import "Wall.h"
#import "PowerUp.h"



@implementation GameLayer
@synthesize isPaused;
@synthesize distance;
@synthesize enemyArray;
@synthesize nextStage;
@synthesize geschwindigkeitEnemy;

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

int enemyCounter;
//nur für die Präsentation, später rausnehmen
int praesentationCounter;
double _geschwindigkeitSpawn;
int tag; //vorlaeufige variable zum auswaehlen welcher gegner auftaucht


- (id) init
{
    if ((self = [super init])) {
        //box2d
        [self initPhysics];
        [self scheduleUpdate];

        tag=0;
        nextStage=false;
        enemyCounter=0;
        praesentationCounter = 0;
        
        geschwindigkeitEnemy=5.0;
        _geschwindigkeitSpawn=3.5;
        
        enemyArray = [[NSMutableArray alloc] init];
        // _sushiArray = [[NSMutableArray alloc] init];
        
        [self schedule:@selector(spawnEnemy:)interval:_geschwindigkeitSpawn];
        
        isRolling=false;
        isPaused=false;
        
        //ninja 
        ninja=[[Ninja alloc] initWithWorld: world];
        [self addChild:ninja z:1];

        
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
        sushiImage.scale =0.5;
        [self addChild:sushiImage];
        sushiImage.position= ccp(winSize.width-80, winSize.height-50);
        
        sushiLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:25];
        [self addChild:sushiLabel];
        sushiLabel.position = ccp(winSize.width-20, winSize.height-50);
        //[self schedule:@selector(updateSushiEaten:)];
        
    }
    
    [self setTouchEnabled:YES];
    
    return self;
    
}
#pragma mark box2d methoden

-(void) initPhysics //erstellt welt, was gezeichnet werden soll, boden
{
	
	CGSize s = [[CCDirector sharedDirector] winSize];
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -10.0f); // vektor in -y richtung für schwerkraft
	world = new b2World(gravity); //welt erstellen
	
	
	// Do we want to let bodies sleep?
	world->SetAllowSleeping(false);
	
	world->SetContinuousPhysics(true);
	
	debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	debugDraw->SetFlags(flags);
	
	
	// Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, (s.height/3-10)/PTM_RATIO); // bottom-left corner, auf hoehe winSize.height/3
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	
	groundBox.Set(b2Vec2(0,0), b2Vec2(2*s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(2*s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,0), b2Vec2(0,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(2*s.width/PTM_RATIO,0), b2Vec2(2*s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
}

- (b2Body*)createBodyAtLocation:(CGPoint)location withSize:(CGSize)size {
    
    b2BodyDef bodyDef;      //body erstellen
    bodyDef.type = b2_dynamicBody; //dynamic: box2d kuemmert sich um bewegungen
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2PolygonShape shape;           //shape erstellen
    shape.SetAsBox(size.width/2/PTM_RATIO, size.height/2/PTM_RATIO);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0;           //für gewicht,desto hoeher desto schwerer, bei 0 wird es static bewegt sich nicht mehr !, default ist 0
    //mass=density*volume
    body->CreateFixture(&fixtureDef);
    return body;
    
}

-(void) draw
{
	//
	// IMPORTANT:
	// This is only for debug purposes
	// It is recommend to disable it
	//
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
	
	kmGLPopMatrix();
}

-(void)update:(ccTime)dt {
    int32 velocityIterations = 3;
    int32 positionIterations = 2;
    world->Step(dt, velocityIterations, positionIterations);
}

#pragma mark game methoden

- (void)updateDistance:(ccTime)dt {
    distance ++;
    [punkte setString:[NSString stringWithFormat:@"%i",distance]]; // anzeige anpassen
    if(nextStage){ //nach bestimmter anzahl
        if(self.geschwindigkeit>0.21){ // wird bis zu minimum geschwindigkeit
            self.geschwindigkeit-=0.2; // die geschiwndigkeit angepasst
            [ninja reloadAnimsWithSpeed:self.geschwindigkeit];
           
            BackgroundLayer *bl = (BackgroundLayer *)[self.parent getChildByTag:backgroundLayerTag];

            [bl reloadBackgroundWithSpeed:self.geschwindigkeit];
            [self schedule:@selector(updateDistance:)interval:self.geschwindigkeit];

        }
        nextStage=false;
        
    }
    
    
}


//ueberprueft ob ninja getroffen wurde
-(void) updateNinjaIsHit:(ccTime)delta{
    NSMutableArray *enemyToDelete = [[NSMutableArray alloc] init];

    for (ObstacleObject *enemy in enemyArray) {
        
        if (CGRectIntersectsRect([ninja getCurrentNinjaSprite].boundingBox, enemy.boundingBox)) {
            if(enemy.isEatable){
                sushiCounter++;
                [sushiLabel setString:[NSString stringWithFormat:@"%i",sushiCounter]]; // anzeige anpassen
                [enemyToDelete addObject:enemy];
            }
            else if(enemy.isRollable and isRolling){
                [enemyToDelete addObject:enemy];
            }
            else if(enemy.isPowerUp){
                //hier kommt das mit dem PowerUp rein                
                [enemyToDelete addObject:enemy];
                [[CCDirector sharedDirector] pushScene:[[MinigameScene alloc] initWith:enemy.type]];
            }
            else{
                [ninja die:self];
                [self stopGame];

            }
        }
    }

    for (ObstacleObject *enemy in enemyToDelete) {
        [self removeObstacle:enemy];
        //geht auch ohne das, kA was das macht
        //[self removeChild:enemy cleanup:YES];
    }
    [enemyToDelete release];
    
}

-(void) stopGame{
    //Leider ging es nicht über Pause zu machen, deswegen eigene funktion:
    BackgroundLayer *bl = (BackgroundLayer *)[self.parent getChildByTag:backgroundLayerTag];

    [bl stopBackgroundAnimation];
    [self stopAnimation];
}

-(void) endGame{
    [[CCDirector sharedDirector] replaceScene:[[GameOverScene alloc] initWith:distance andSushi: sushiCounter]];
}

//pruefen ob monster abgeschossen wurden
- (void)updateMonsterIsHit:(ccTime)dt {
    NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    for (CCSprite *projectile in _projectiles) {
        
        NSMutableArray *enemyToDelete = [[NSMutableArray alloc] init];
        for (ObstacleObject *enemy in enemyArray) {
            
            if (CGRectIntersectsRect(projectile.boundingBox, enemy.boundingBox)) {
                if(enemy.isShootable){
                    [enemyToDelete addObject:enemy];
                }
                else{
                    [projectilesToDelete addObject:projectile];

                }
            }
        }        
        for (ObstacleObject *enemy in enemyToDelete) {
            [self removeObstacle:enemy];
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
    if (_startPoint.y-_endPoint.y>10 and abs(_endPoint.x-_startPoint.x)<5 and !ninja.characterState==StateJumping) {
        isRolling=true;
        [ninja startRoll];
        
        
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
        [ninja endRoll];
    }
    
    // Choose one of the touches to work with
    else if(isPaused){
        
    }
    //ueberpruefen wie weit start und endpunkt in x richtung von einander entfernt sind --> swipe
    else if (_endPoint.x-_startPoint.x>10) {
        
        [ninja throwProjectile:self];
        
        
    }
    //Hier werden die Fälle für Single und DoubleTap abgeprüft
    else if (tapCount == 1){
        //Wenn Single Tap ist führt er die Methode für normalen Jump aus
        [self performSelector:@selector(singleTapMethod) withObject:nil afterDelay:0.2];
        
    }else if (tapCount == 2){
        //Im Fall von DoubleTap bricht er die Animation von normalen Jump ab und startet die für den DoubleJump
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapMethod) object:nil];
        [self performSelector:@selector(doubleTapMethod) withObject:nil afterDelay:0];
        
    }
}

-(void)throwProjectile{
    CGPoint location = [self convertTouchToNodeSpace:lastTouch];
    
    // Set up initial location of projectile
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *projectile = [CCSprite spriteWithFile:@"shuriken.png"];
    projectile.position = [ninja getCurrentNinjaSprite].position;
    
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
    float velocity = 480/1*1+1-1; // 480pixels/1sec
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
    [ninja jump];
}

-(void)doubleTapMethod{
    [ninja doubleJump];
}

-(void)pauseGame
{
    [[CCDirector sharedDirector] pause];
}

-(void) spawnEnemy:(ccTime)dt{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    ObstacleObject *enemy;
    
    
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
            enemy.scale =0.7;
            break;
        case 2:
            tag++;
            enemy=[[Wall alloc] init];
            break;
            
        default:
            break;
    }
    
    if (randomPowerUp == 0) {
        ObstacleObject *powerUp = [[PowerUp alloc] init];
        //spawnPowerUp = true;
        [enemyArray addObject:powerUp];
        int randomHeight = (arc4random() % 51)*2.5;
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
    CGPoint location= ccp(winSize.width, winSize.height/3);
    b2Body *body=[self createBodyAtLocation:location withSize:enemy.contentSize];

//    [enemy setPTMRatio:PTM_RATIO];
//	[enemy setBody:body];
	[enemy setPosition: location];
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


- (void) dealloc
{
    [super dealloc];

    if (world) {        //dealloc world
        delete world;
        world = NULL;
    }
    if (debugDraw) {
        delete debugDraw;
        debugDraw = nil;
    }
    [enemyArray release];
    enemyArray=nil;
    [_projectiles release];
    _projectiles = nil;
    
    
}

@end
