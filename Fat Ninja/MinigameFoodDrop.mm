//
//  MinigameFoodDrop.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameFoodDrop.h"

@implementation MinigameFoodDrop

//Array mit allem was runterkommt
NSMutableArray *dropStuff;

//zählt wieviel schon runter ist
int dropCount;

//steht für die Anzahl an gefangenen Früchten
int foodCount;
//steht für die Anzahl an gefangenen Bomben
int bombCount;
//Anzahl von dem was runter kommt
int amountOfDrops;
//Anzahl der Food Drops
int amountOfFood;
//Anzahl der Bomben
int amountOfBombs;

- (id)init
{
    self = [super init];
    if (self) {
        
        
        
        game = @"Omnom-Jutsu";
        description = @"Move the Ninja with your finger.\rTry to catch all the food.\rBut watch out for the bombs!";
        timeCount = 20;
        dropCount = 0;
        foodCount = 0;
        bombCount = 0;
        amountOfDrops = 15;
        amountOfFood = 12;
        amountOfBombs = amountOfDrops - amountOfFood;
        
        dropStuff = [[NSMutableArray alloc] init];
        
        //Die Teile für richtiges Essen
        for (int i = 0; i < amountOfFood; i++) {
            [dropStuff addObject:[NSNumber numberWithInteger:2]];
        }
        //Die Teile für Bomben
        for (int j = 0; j < amountOfBombs; j++) {
            [dropStuff addObject:[NSNumber numberWithInteger:3]];
        }
        /*
         for (int i = 0; i < dropStuff.count; i++) {
         NSLog(@"Hier das Array an der Stelle %i: %i",i, [[dropStuff objectAtIndex:i] integerValue]);
         }
         */
        
        
        
        //Hier wird das Array gemischt
        for (int i = 0; i < dropStuff.count; i++) {
            int randomIndex = arc4random() % dropStuff.count;
            [dropStuff exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
        }
        
        
        
        /*
         for (int i = 0; i < dropStuff.count; i++) {
         NSLog(@"Hier das Array nach mischen an Stelle %i: %i",i, [[dropStuff objectAtIndex:i] integerValue]);
         }
         */
        
        
        
        [self initPhysics];
        //Erstellt das Spielfeld
        [self createGround];
        [self createNinja];
        
        [self schedule:@selector(tick:)];
        
        [self schedule:@selector(drop:)interval:1.0];
        [self setTouchEnabled:YES];
        
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(1.0f, 0.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(_ninjaBody, _groundBody,
                            _ninjaBody->GetWorldCenter(), worldAxis);
        _world->CreateJoint(&jointDef);
        
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        
        
        
        
        
    }
    return self;
}

-(void) initPhysics //erstellt welt, was gezeichnet werden soll, boden
{
	
	b2Vec2 gravity;
	gravity.Set(0.0f, -5.0f); // vektor in -y richtung für schwerkraft
	_world = new b2World(gravity); //welt erstellen
	
	
	// Do we want to let bodies sleep?
	_world->SetAllowSleeping(false);
	
	_world->SetContinuousPhysics(true);
	/*
	debugDraw = new GLESDebugDraw( PTM_RATIO );
	_world->SetDebugDraw(debugDraw);
	
	uint32 flags = 0;
	flags += b2Draw::e_shapeBit;
	//		flags += b2Draw::e_jointBit;
	//		flags += b2Draw::e_aabbBit;
	//		flags += b2Draw::e_pairBit;
	//		flags += b2Draw::e_centerOfMassBit;
	debugDraw->SetFlags(flags);
	*/
    
}


-(void) createNinja{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    // Create sprite and add it to the layer
    CCSprite *ninja = [CCSprite spriteWithFile:@"NinjaHead.png"];
    int positionX = winSize.width/2;
    int positionY = marginbot+(ninja.contentSize.height*ninja.scale);
    ninja.position = ccp(positionX, positionY);
    ninja.tag = 1;
    [self addChild:ninja];
    
    // Create ninja body
    b2BodyDef ninjaBodyDef;
    ninjaBodyDef.type = b2_dynamicBody;
    ninjaBodyDef.position.Set(positionX/PTM_RATIO, positionY/PTM_RATIO);
    ninjaBodyDef.userData = ninja;
    _ninjaBody = _world->CreateBody(&ninjaBodyDef);
    
    // Create circle shape
    b2CircleShape circle;
    //circle.m_radius = 26.0/PTM_RATIO;
    circle.m_radius = (ninja.contentSize.height*ninja.scale)/PTM_RATIO/2;
    
    // Create shape definition and add to body
    b2FixtureDef ninjaShapeDef;
    ninjaShapeDef.shape = &circle;
    ninjaShapeDef.density = 50000.0f;
    ninjaShapeDef.friction = 1.f;
    ninjaShapeDef.restitution = 0.0f;
    _ninjaFixture = _ninjaBody->CreateFixture(&ninjaShapeDef);
    
    
}

-(void) dropFoodAtLocation:(CGPoint)location{
    
    // Create Food and add it to the layer
    CCSprite *food = [CCSprite spriteWithFile:@"icon-sushi.png"];
    food.scale = 0.5;
    food.position = ccp(location.x, location.y);
    food.tag = 2;
    [self addChild:food];
    
    // Create Food body
    b2BodyDef blockBodyDef;
    blockBodyDef.type = b2_dynamicBody;
    blockBodyDef.position.Set(location.x/PTM_RATIO,
                              location.y/PTM_RATIO);
    blockBodyDef.userData = food;
    b2Body *blockBody = _world->CreateBody(&blockBodyDef);
    
    // Create Food shape
    b2PolygonShape blockShape;
    blockShape.SetAsBox((food.contentSize.width*food.scale)/PTM_RATIO/2,
                        (food.contentSize.height*food.scale)/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef blockShapeDef;
    blockShapeDef.shape = &blockShape;
    blockShapeDef.density = 1.0;
    blockShapeDef.friction = 0.0;
    blockShapeDef.restitution = 0.f;
    blockBody->CreateFixture(&blockShapeDef);
}

-(void) dropBombAtLocation:(CGPoint)location{
    
    // Create Bomb and add it to the layer
    CCSprite *bomb = [CCSprite spriteWithFile:@"shuriken.png"];
    bomb.position = ccp(location.x, location.y);
    bomb.tag = 3;
    [self addChild:bomb];
    
    // Create Bomb body
    b2BodyDef bombBodyDef;
    bombBodyDef.type = b2_dynamicBody;
    bombBodyDef.position.Set(location.x/PTM_RATIO,
                             location.y/PTM_RATIO);
    bombBodyDef.userData = bomb;
    b2Body *bombBody = _world->CreateBody(&bombBodyDef);
    
    // Create circle shape
    b2CircleShape circle;
    //circle.m_radius = 26.0/PTM_RATIO;
    circle.m_radius = (bomb.contentSize.height*bomb.scale)/PTM_RATIO/2;
    
    
    // Create shape definition and add to body
    b2FixtureDef bombShapeDef;
    bombShapeDef.shape = &circle;
    bombShapeDef.density = 1.0;
    bombShapeDef.friction = 0.0;
    bombShapeDef.restitution = 0.0f;
    bombBody->CreateFixture(&bombShapeDef);
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
	
	_world->DrawDebugData();
	
	kmGLPopMatrix();
}

- (void)drop:(ccTime)dt {
    
    
    if (timeCount < 19 && dropCount != amountOfDrops) {
        int aktuell = [[dropStuff objectAtIndex:dropCount] intValue];
        CGPoint location1;
        
        int start = x_left;
        int max = x_right;
        int drop = max;
        //NSLog(@"start %d",start);
        //NSLog(@"max %d",max);
        
        while (drop >= max) {
            drop = start + arc4random()%(int)gameWidth;
        }
        //NSLog(@"drop %d",drop);
        
        location1 = ccp(drop, y_top-30);
        
        switch (aktuell) {
            case 2:
                
                [self dropFoodAtLocation:location1];
                
                //NSLog(@"Food");
                break;
                
            case 3:
                
                [self dropBombAtLocation:location1];
                
                //NSLog(@"Bomb");
                break;
                
            default:
                break;
        }
        
        
        dropCount++;
        //NSLog(@"%d",timeCount);
    }
    
}

- (void)tick:(ccTime) dt {
    
    //Variable, die schaut ob das letzte Item noch da ist
    bool dropFound = false;
    
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            if (sprite.tag == 1) {
                //damit man den Ninja nichtmehr rumschießen kann
                b->SetLinearDamping(100.0);
                
            }
            //Während immernoch neue Drops gemacht werden wird die drop Found automatisch auf True gesetzt
            if (timeCount >= 5) {
                dropFound = true;
            }
            //hier schaut er ob noch ein Item runterfällt, falls ja schreibt er true für dropFound
            if (timeCount < 5) {
                CCSprite *sprite = (CCSprite *)b->GetUserData();
                if (sprite.tag == 2) {
                    dropFound = true;
                }
            }
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
        }
    }
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        //Prüft ob Food oder Bombe auf den Boden gefallen ist
        if (contact.fixtureA == _bottomFixture) {
            b2Body *bodyB = contact.fixtureB->GetBody();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            if (spriteB.tag == 2 || spriteB.tag == 3) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    // NSLog(@"Auf Boden Gefallen");
                }
            }
        }
        
        //Prüft ob Food oder Bombe auf den Boden gefallen ist
        if (contact.fixtureB == _bottomFixture) {
            b2Body *bodyA = contact.fixtureA->GetBody();
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            if (spriteA.tag == 2 || spriteA.tag == 3) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    // NSLog(@"Auf Boden Gefallen");
                }
                
            }
        }
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            //Prüft ob Ninja mit Food oder Bombe zusammengestoßen ist
            // Sprite A = Ninja, Sprite B = Food oder Bomb
            if (spriteA.tag == 1 && (spriteB.tag == 2 || spriteB.tag == 3)) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    if (spriteB.tag == 2) {
                        foodCount++;
                    }
                    if (spriteB.tag == 3) {
                        bombCount++;
                    }
                }
            }
            
            //Prüft ob Ninja mit Food oder Bombe zusammengestoßen ist
            // Sprite B = Food oder Bomb, Sprite A = Ninja
            else if ((spriteA.tag == 2 || spriteA.tag == 3)&& spriteB.tag == 1) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    if (spriteA.tag == 2) {
                        foodCount++;
                    }
                    if (spriteA.tag == 3) {
                        bombCount++;
                    }
                }
            }
        }
        
        
        
    }
    
    //Hier werden dann die erfassten Objekte gelöscht
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            [self removeChild:sprite cleanup:YES];
        }
        _world->DestroyBody(body);
    }
    //tritt ein wenn alle Drops weg sind
    if (!dropFound) {
        
        // [self calculateEvaluation];
        
        //NSLog(@"Alle Weg!");
    }
    
    // NSLog(@"Food: %d",foodCount);
    // NSLog(@"Bomb: %d",bombCount);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (_ninjaFixture->TestPoint(locationWorld)) {
        b2MouseJointDef md;
        md.bodyA = _groundBody;
        md.bodyB = _ninjaBody;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * _ninjaBody->GetMass();
        
        _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
        _ninjaBody->SetAwake(true);
    }
    
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
    
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}

-(void) calculateEvaluation{
    //NSLog(@"food %i", foodCount);
    //NSLog(@"bomb %i", bombCount);
    float score = foodCount - bombCount;
    float percent = score / amountOfFood;
    if (percent < 0) {
        evaluation = 0;
    }
    else{
        evaluation = percent;
    }
    //NSLog(@"Win %f", evaluation);
    NSInteger powerDuration;
    //abstufung je nachdem wie gut man ein spiel geschafft hat
    if (evaluation == 0) {
        powerDuration = 0;
    }else if (evaluation > 0 && evaluation <= 0.20){
        powerDuration = 2;
    }else if (evaluation > 0.20 && evaluation <= 0.40){
        powerDuration = 4;
    }else if (evaluation > 0.40 && evaluation <= 0.60){
        powerDuration = 4;
    }else if (evaluation > 0.60 && evaluation <= 0.80){
        powerDuration = 6;
    }else if (evaluation > 0.80 && evaluation < 1.00){
        powerDuration = 8;
    }else if (evaluation == 1.00){
        powerDuration = 10;
    }
    NSLog(@"POWERURATION----- %d",powerDuration);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:powerDuration forKey:@"powerDuration"];
}

- (void)dealloc {
    
    if (_world) {
        delete _world;
        _world = NULL;
    }
    _groundBody = NULL;
    /*
    if (debugDraw) {
        delete debugDraw;
        debugDraw = nil;
    }
     */
    delete _contactListener;
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
    [super dealloc];
}

@end

