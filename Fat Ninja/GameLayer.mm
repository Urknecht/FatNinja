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
#import "MinigameScene.h"
#import "Skeleton.h"
#import "SushiOb.h"
#import "WallOb.h"
#import "PowerUp.h"
#import "Stone.h"



@implementation GameLayer
@synthesize isPaused;
@synthesize distance;
@synthesize enemyArray;
@synthesize nextStage;
@synthesize geschwindigkeitEnemy,_enemyBatchNode,_wallBatchNode,_sushiBatchNode,_stoneBatchNode,_powerUpBatchNode;

//startpunkt für swipe ueberpruefung
CGPoint _startPoint;
//endpunkt für swipe ueberpruefung
CGPoint _endPoint;


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
//Für Präsentation Minispiel
int typePresentation;

double endSpeed;

- (id) init
{
    if ((self = [super init])) {
        //box2d
        [self initPhysics];
        [self scheduleUpdate];
        _enemyBatchNode =[CCSpriteBatchNode batchNodeWithFile:@"skeletonDying.png"];
        [self addChild:_enemyBatchNode];
        _sushiBatchNode =[CCSpriteBatchNode batchNodeWithFile:@"icon-sushi.png"];
        [self addChild:_sushiBatchNode];
        _wallBatchNode =[CCSpriteBatchNode batchNodeWithFile:@"brokenWall.png"];
        [self addChild:_wallBatchNode];
        _stoneBatchNode =[CCSpriteBatchNode batchNodeWithFile:@"stone.png"];
        [self addChild:_stoneBatchNode];
        _powerUpBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"powerup.png"];
        [self addChild:_powerUpBatchNode];
        tag=0;
        nextStage=false;
        enemyCounter=0;
        praesentationCounter = 0;
        typePresentation = 0;
        
        geschwindigkeitEnemy=5.0;
        _geschwindigkeitSpawn=3.5;
        
        enemyArray = [[NSMutableArray alloc] init];
        
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
        CCSprite *sushiImage= [CCSprite spriteWithFile:@"icon-sushi.png"];
        sushiImage.scale =0.5;
        [self addChild:sushiImage];
        sushiImage.position= ccp(winSize.width-80, winSize.height-50);
        
        sushiLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:25];
        [self addChild:sushiLabel];
        sushiLabel.position = ccp(winSize.width-20, winSize.height-50);
        endSpeed=0.66;
        
        
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
	
//	debugDraw = new GLESDebugDraw( PTM_RATIO );
//	world->SetDebugDraw(debugDraw);
//	
//	uint32 flags = 0;
//	flags += b2Draw::e_shapeBit;
//	//		flags += b2Draw::e_jointBit;
//	//		flags += b2Draw::e_aabbBit;
//	//		flags += b2Draw::e_pairBit;
//	//		flags += b2Draw::e_centerOfMassBit;
//	debugDraw->SetFlags(flags);
	
	
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

- (b2Body*)createBodyFor: (GameObjectType) type AtLocation:(CGPoint)location withSize:(CGSize)size {
    
    b2BodyDef bodyDef;      //body erstellen
    bodyDef.type = b2_dynamicBody; //dynamic: box2d kuemmert sich um bewegungen
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = world->CreateBody(&bodyDef);
    b2PolygonShape shape;           //shape erstellen
    b2FixtureDef fixtureDef;
    
    switch (type) {
        case Enemy:{
            //row 1, col 1
            int num = 8;
            b2Vec2 verts[] = {
                b2Vec2(-5.0f / PTM_RATIO, 14.7f / PTM_RATIO),
                b2Vec2(-10.3f / PTM_RATIO, 10.9f / PTM_RATIO),
                b2Vec2(-9.7f / PTM_RATIO, -0.7f / PTM_RATIO),
                b2Vec2(-3.6f / PTM_RATIO, -14.1f / PTM_RATIO),
                b2Vec2(5.4f / PTM_RATIO, -14.6f / PTM_RATIO),
                b2Vec2(11.3f / PTM_RATIO, 3.7f / PTM_RATIO),
                b2Vec2(10.9f / PTM_RATIO, 10.5f / PTM_RATIO),
                b2Vec2(-4.0f / PTM_RATIO, 14.2f / PTM_RATIO)};
            shape.Set(verts, num);
            fixtureDef.shape = &shape;
            
            
        }
            break;
        case Sushi:{
            int num = 8;
            b2Vec2 verts[] = {
                b2Vec2(-15.8f*0.7 / PTM_RATIO, 24.6f*0.7 / PTM_RATIO),
                b2Vec2(-27.1f*0.7 / PTM_RATIO, 17.4f*0.7 / PTM_RATIO),
                b2Vec2(-26.9f*0.7 / PTM_RATIO, -15.4f*0.7 / PTM_RATIO),
                b2Vec2(0.9f*0.7 / PTM_RATIO, -23.6f*0.7 / PTM_RATIO),
                b2Vec2(27.1f*0.7 / PTM_RATIO, -13.8f*0.7 / PTM_RATIO),
                b2Vec2(28.4f*0.7 / PTM_RATIO, 14.3f*0.7 / PTM_RATIO),
                b2Vec2(12.0f*0.7 / PTM_RATIO, 23.6f*0.7 / PTM_RATIO),
                b2Vec2(-15.7f*0.7 / PTM_RATIO, 23.3f*0.7 / PTM_RATIO)};
            shape.Set(verts, num);
            
            fixtureDef.shape = &shape;
            // fixtureDef.density = 0;           //für gewicht,desto hoeher desto schwerer, bei 0 wird es static bewegt sich nicht mehr !, default ist 0
            //mass=density*volume
        }
            break;
        case Wall:
        {
            shape.SetAsBox(size.width/2/PTM_RATIO, size.height/2/PTM_RATIO);
            fixtureDef.shape = &shape;
        }
            break;
        case StoneType:{
            int num = 7;
            b2Vec2 verts[] = {
                b2Vec2(-9.1f / PTM_RATIO, 19.5f / PTM_RATIO),
                b2Vec2(-19.5f / PTM_RATIO, 1.5f / PTM_RATIO),
                b2Vec2(-19.3f / PTM_RATIO, -15.3f / PTM_RATIO),
                b2Vec2(14.7f / PTM_RATIO, -19.5f / PTM_RATIO),
                b2Vec2(19.7f / PTM_RATIO, -3.0f / PTM_RATIO),
                b2Vec2(-0.0f / PTM_RATIO, 18.3f / PTM_RATIO),
                b2Vec2(-8.9f / PTM_RATIO, 18.0f / PTM_RATIO)};
            shape.Set(verts, num);
            
            fixtureDef.shape = &shape;
        }
            break;
        case Powerup:{
            int num = 5;
            b2Vec2 verts[] = {
                
                b2Vec2 (-17.3f / PTM_RATIO, 21.4f / PTM_RATIO),
                b2Vec2 (-17.2f / PTM_RATIO, -18.4f / PTM_RATIO),
                b2Vec2 (17.2f / PTM_RATIO, -19.3f / PTM_RATIO),
                b2Vec2 (16.6f / PTM_RATIO, 20.8f / PTM_RATIO),
                b2Vec2 (-16.3f / PTM_RATIO, 20.7f / PTM_RATIO)};
            shape.Set(verts, num);
            
            fixtureDef.shape = &shape;
        }
            break;
        case None:
        {
            shape.SetAsBox(size.width/2/PTM_RATIO, size.height/2/PTM_RATIO);
            fixtureDef.shape = &shape;
        }
            break;
        default:
            break;
    }
    
    body->CreateFixture(&fixtureDef);
    return body;
    
}

//-(void) draw
//{
//	//
//	// IMPORTANT:
//	// This is only for debug purposes
//	// It is recommend to disable it
//	//
//	[super draw];
//	
//	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
//	
//	kmGLPushMatrix();
//	
//	world->DrawDebugData();
//	
//	kmGLPopMatrix();
//}

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
            
            [self schedule:@selector(updateDistance:)interval:self.geschwindigkeit];
            
        }
        nextStage=false;
        
    }
    
    
}


//ueberprueft ob ninja getroffen wurde
-(void) updateNinjaIsHit:(ccTime)delta{
    NSMutableArray *enemyToDelete = [[NSMutableArray alloc] init];
    
    for (ObstacleObject *enemy in enemyArray) {
        b2ContactEdge* edge = [ninja getCurrentBody]->GetContactList();
        while (edge)
        {
            b2Contact* contact = edge->contact;
            b2Fixture* fixtureA = contact->GetFixtureA();
            b2Fixture* fixtureB = contact->GetFixtureB();
            b2Body *bodyA = fixtureA->GetBody();
            b2Body *bodyB = fixtureB->GetBody();
            
                 if (bodyA == enemy.body || bodyB == enemy.body) {
                if(contact->IsTouching()){
                    
                    if(enemy.isEatable){
                        sushiCounter++;
                        [sushiLabel setString:[NSString stringWithFormat:@"%i",sushiCounter]]; // anzeige anpassen
                        [enemyToDelete addObject:enemy];
                    }
                    else if(enemy.isRollable and isRolling and enemy.enemyState!= StateDie){
                        [enemy changeState:StateDie];
                        //[enemyToDelete addObject:enemy];
                    }
                    else if(enemy.isPowerUp){
                        //hier kommt das mit dem PowerUp rein
                        [enemyToDelete addObject:enemy];
                        if(isRolling){
                            isRolling=false;
                            [ninja endRoll];
                        }
                        int type = enemy.type;
                        if (typePresentation < 2) {
                            type = typePresentation;
                            typePresentation++;
                        }
                        [[CCDirector sharedDirector] pushScene:[[MinigameScene alloc] initWith:type]];
                    }
                    else if(!enemy.enemyState==StateDie){
                        [ninja die:self];
                        [self stopGame];
                    }
                }
            }
            edge = edge->next;
            
        }
        if(enemy.position.x==0){
            [enemyToDelete addObject:enemy];
        }
        
        for(b2Body *b = world->GetBodyList(); b != NULL; b = b->GetNext()) {
            if (b->GetUserData() != NULL) {
                CCPhysicsSprite *sprite = (CCPhysicsSprite *) b->GetUserData();
                sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                      b->GetPosition().y * PTM_RATIO);
                sprite.rotation = CC_RADIANS_TO_DEGREES(b->GetAngle() * -1);
                
            }
        }
        
    }
    
    for (ObstacleObject *enemy in enemyToDelete) {
        [self removeObstacle:enemy];
    }
    [enemyToDelete release];
    
}

-(void) stopGame{
    //Während der Ninja stirbt
    //Leider ging es nicht über Pause zu machen, deswegen eigene funktion:
    BackgroundLayer *bl = (BackgroundLayer *)[self.parent getChildByTag:backgroundLayerTag];
    [self unscheduleAllSelectors];
    [bl stopBackgroundAnimation];
    [self stopAnimation];
}

-(void) endGame{
    NSLog(@"Zeige Highscore!");
//    [ninja dealloc];
//    [self dealloc];
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
                    [enemy changeState:StateDie];
                    
                    if(enemy.isPowerUp||enemy.isEatable){
                        [enemyToDelete addObject:enemy];
                    }
                }
                else{
                    [projectilesToDelete addObject:projectile];
                    
                }
            }
        }
        for (ObstacleObject *enemy in enemyToDelete) {
            [self removeEnemy:(enemy)];
        }
        
        if (enemyToDelete.count > 0) {
            [projectilesToDelete addObject:projectile];
        }
        [enemyToDelete release];
    }
    
    for (CCSprite *projectile in projectilesToDelete) {
        //world->DestroyBody(projectile.body);
        [_projectiles removeObject:projectile];
        [self removeChild:projectile cleanup:YES];
    }
    [projectilesToDelete release];
    
    
}

-(void)removeEnemy:(ObstacleObject *)enemy{
    [self removeObstacle:enemy];
    [self removeChild:enemy cleanup:YES];
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
//    [projectile setPTMRatio:PTM_RATIO];
//	[projectile setBody:[self createBodyFor: (GameObjectType) None AtLocation:[ninja getCurrentNinjaSprite].position withSize:projectile.contentSize]];
	[projectile setPosition: [ninja getCurrentNinjaSprite].position];
    
    
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
    int randomTag = arc4random()%5;
    //NSLog(@"Hier sind die RandomTags: %i",randomTag);
    
    int randomPowerUp = arc4random()%1;
    if (praesentationCounter < 6) {
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
            enemy=[[Skeleton alloc] initWith: geschwindigkeitEnemy andWinSize:winSize];
            [_enemyBatchNode addChild:enemy];
            break;
        case 1:
            tag++;
            enemy=[[SushiOb alloc] initWith:geschwindigkeitEnemy andWinSize:winSize];
            enemy.scale =0.7;
            [_sushiBatchNode addChild:enemy];
            
            break;
        case 2:
            tag++;
            enemy=[[WallOb alloc] initWith:geschwindigkeitEnemy andWinSize:winSize];
            [_wallBatchNode addChild:enemy];
            break;
        case 3:
            tag++;
            enemy=[[Stone alloc] initWith:geschwindigkeitEnemy andWinSize:winSize];
            [_stoneBatchNode addChild:enemy];
            break;
        case 4:
            enemy = [[PowerUp alloc] initWith:geschwindigkeitEnemy andWinSize:winSize];
            [_powerUpBatchNode addChild:enemy];
            break;
        case 5:
            enemy = [[PowerUp alloc] initWith:geschwindigkeitEnemy andWinSize:winSize];
            [_powerUpBatchNode addChild:enemy];
            break;
        default:
            break;
    }
    /*
     if (randomPowerUp == 0) {
     ObstacleObject *powerUp = [[PowerUp alloc] init];
     //spawnPowerUp = true;
     [enemyArray addObject:powerUp];
     int randomHeight = (arc4random() % 51)*2.5;
     CGPoint location =CGPointMake(winSize.width, winSize.height/3+randomHeight);
     b2Body *body=[self createBodyFor:powerUp.enemyType AtLocation:location withSize:powerUp.contentSize];
     [powerUp setPTMRatio:PTM_RATIO];
     [powerUp setBody:body];
     [powerUp setPosition: location];
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
     */
    
    
    [enemyArray addObject:enemy];
    CGPoint location= ccp(winSize.width, winSize.height/3);
    b2Body *body=[self createBodyFor: enemy.enemyType AtLocation:location withSize:enemy.contentSize];
    
    [enemy setPTMRatio:PTM_RATIO];
    [enemy setBody:body];
    [enemy setPosition: location];
    [enemy loadAnim];
    
    
    enemyCounter++;
    
    if(enemyCounter==5){ // nach 5 gegnern
        nextStage=true;
        BackgroundLayer *bl = (BackgroundLayer *)[self.parent getChildByTag:backgroundLayerTag];
        double geschwindigkeitAlt=geschwindigkeitEnemy;
        
        if(geschwindigkeitEnemy>1.0){ // wird die geschwindigkeit der animation bis zu einem miminum erhoeht
            if (geschwindigkeitEnemy>2.0) {
                geschwindigkeitEnemy-=1.0;
                
                [bl reloadBackgroundWithSpeed:geschwindigkeitEnemy/geschwindigkeitAlt];
                
            }else{
                geschwindigkeitEnemy-=0.1;
                endSpeed=endSpeed-0.05;
                [bl reloadBackgroundWithSpeed:endSpeed];
            }
        }
        if(_geschwindigkeitSpawn>0.5){ // und der abstand zwischen den gegnern veringert
            if (_geschwindigkeitSpawn>2.0) {
                _geschwindigkeitSpawn-=0.5;
            }else{
                _geschwindigkeitSpawn-=0.1;
            }
            [self schedule:@selector(spawnEnemy:)interval:_geschwindigkeitSpawn];
        }
        enemyCounter=0;
    }
}


-(void) removeObstacle: (ObstacleObject*) obstacle{
    
    world->DestroyBody(obstacle.body);
    [enemyArray removeObject:obstacle];
    if(obstacle.class==Skeleton.class){
        [_enemyBatchNode removeChild:obstacle cleanup:YES];
    }else if(obstacle.class==SushiOb.class){
        [_sushiBatchNode removeChild:obstacle cleanup:YES];
    }else if(obstacle.class==WallOb.class){
        [_wallBatchNode removeChild:obstacle cleanup:YES];
    }else if(obstacle.class==Stone.class){
        [_stoneBatchNode removeChild:obstacle cleanup:YES];
    }else if (obstacle.class==PowerUp.class){
        [_powerUpBatchNode removeChild:obstacle cleanup:YES];
    }else{
        [self removeChild:obstacle cleanup:YES];
    }
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
//    if (debugDraw) {
//        delete debugDraw;
//        debugDraw = nil;
//    }
    [enemyArray release];
    enemyArray=nil;
    [_projectiles release];
    _projectiles = nil;    
    
}

@end
