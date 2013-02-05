//
//  MinigameBreakout.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/26/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameBreakout.h"

@implementation MinigameBreakout

//Anzahl der Blöcke
float blockCount;
//Anzahl der zerstörten Blöcke
float brokenBlocks;

- (id)init {
    
    if ((self=[super init])) {
        
        game = @"Roll-Jutsu";
        description = @"Destroy all the blocks!\rDon't let the ninja touch the ground!\rMove the paddle with your finger!";
        timeCount = 35;
        blockCount = 0;
        brokenBlocks = 0;

        
        [self initPhysics];
        [self createGround];
        [self setTouchEnabled:YES];
        [self createBall];
        [self createPaddle];
        [self createBlocks];
        
        // Restrict paddle along the x axis
        b2PrismaticJointDef jointDef;
        b2Vec2 worldAxis(1.0f, 0.0f);
        jointDef.collideConnected = true;
        jointDef.Initialize(_paddleBody, _groundBody,
                            _paddleBody->GetWorldCenter(), worldAxis);
        _world->CreateJoint(&jointDef);
        
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        

        
        [self schedule:@selector(tick:)];
        
    }
    return self;
}

-(void) initPhysics //erstellt welt, was gezeichnet werden soll, boden
{
	
	b2Vec2 gravity;
	gravity.Set(0.0f, 0.0f); // vektor in -y richtung für schwerkraft
	_world = new b2World(gravity); //welt erstellen
	

	// Do we want to let bodies sleep?
	_world->SetAllowSleeping(true);
	
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

-(void) createPaddle{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Create paddle and add it to the layer
    CCSprite *paddle = [CCSprite spriteWithFile:@"Paddle.jpg"];
    paddle.scale = 0.4;
    int positionX = winSize.width/2;
    int positionY = 30+(paddle.contentSize.height*paddle.scale);
    paddle.position = ccp(positionX,positionY);
    [self addChild:paddle];
    
    // Create paddle body
    b2BodyDef paddleBodyDef;
    paddleBodyDef.type = b2_dynamicBody;
    paddleBodyDef.position.Set(positionX/PTM_RATIO, positionY/PTM_RATIO);
    paddleBodyDef.userData = paddle;
    _paddleBody = _world->CreateBody(&paddleBodyDef);
    
    // Create paddle shape
    b2PolygonShape paddleShape;
    paddleShape.SetAsBox((paddle.contentSize.width*paddle.scale)/PTM_RATIO/2,
                         (paddle.contentSize.height*paddle.scale)/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef paddleShapeDef;
    paddleShapeDef.shape = &paddleShape;
    paddleShapeDef.density = 10.0f;
    paddleShapeDef.friction = 0.4f;
    paddleShapeDef.restitution = 0.1f;
    _paddleFixture = _paddleBody->CreateFixture(&paddleShapeDef);
    
    
}

-(void) createBall{
    // Create sprite and add it to the layer
    CCSprite *ball = [CCSprite spriteWithFile:@"NinjaRoll6.png"];
    int positionX = 200;
    int positionY = 80;
    ball.scale = 0.4;
    ball.position = ccp(positionX, positionY);
    ball.tag = 1;
    [self addChild:ball];
    
    // Create ball body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(positionX/PTM_RATIO, positionY/PTM_RATIO);
    ballBodyDef.userData = ball;
    ballBody = _world->CreateBody(&ballBodyDef);
    
    
    // Create circle shape
    b2CircleShape circle;
    circle.m_radius = (ball.contentSize.height/2*ball.scale)/PTM_RATIO;
    
    
    
    // Create shape definition and add to body
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 5.0f;
    ballShapeDef.friction = 0.f;
    ballShapeDef.restitution = 1.0f;
    _ballFixture = ballBody->CreateFixture(&ballShapeDef);
    
    b2Vec2 force = b2Vec2(2, 5);
    ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
    ballBody->ApplyAngularImpulse(0.2);
}

-(void) createBlocks{
    for (int j = 0; j < 3; j++) {
        for(int i = 0; i < 5; i++) {
            
            static int padding=5;
            
            // Create block and add it to the layer
            CCSprite *block = [CCSprite spriteWithFile:@"Block.jpg"];
            block.scale = 0.65;
            int xOffset = x_left+block.contentSize.width/2*block.scale+((block.contentSize.width*block.scale+padding)*i);
            int yOffset = 250+j*(block.contentSize.height*block.scale+padding);
            block.position = ccp(xOffset, yOffset);
            block.tag = 2;
            [self addChild:block];
            
            // Create block body
            b2BodyDef blockBodyDef;
            blockBodyDef.type = b2_staticBody;
            blockBodyDef.position.Set(xOffset/PTM_RATIO, yOffset/PTM_RATIO);
            blockBodyDef.userData = block;
            b2Body *blockBody = _world->CreateBody(&blockBodyDef);
            
            // Create block shape
            b2PolygonShape blockShape;
            blockShape.SetAsBox((block.contentSize.width*block.scale)/PTM_RATIO/2,
                                (block.contentSize.height*block.scale)/PTM_RATIO/2);
            
            // Create shape definition and add to body
            b2FixtureDef blockShapeDef;
            blockShapeDef.shape = &blockShape;
            blockShapeDef.density = 10.0;
            blockShapeDef.friction = 0.0;
            blockShapeDef.restitution = 0.1f;
            blockBody->CreateFixture(&blockShapeDef);
            blockCount++;
            
        }

    }
}

- (void)tick:(ccTime) dt {
    bool blockFound = false;
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            if (sprite.tag == 2) {
                blockFound = true;
            }
            if (sprite.tag == 1) {
                static int maxSpeed = 10;
                
                b2Vec2 velocity = b->GetLinearVelocity();
                float32 speed = velocity.Length();
                
                if (speed > maxSpeed) {
                    b->SetLinearDamping(0.5);
                } else if (speed < maxSpeed) {
                    b->SetLinearDamping(0.0);
                }
                
            }
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
            sprite.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        }
    }
    
    std::vector<b2Body *>toDestroy;
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->_contacts.begin();
        pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        if ((contact.fixtureA == _bottomFixture && contact.fixtureB == _ballFixture) ||
            (contact.fixtureA == _ballFixture && contact.fixtureB == _bottomFixture)) {
            [self stopMinigame];
           // NSLog(@"Loose and GameEnd!");
        }
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            // Sprite A = ball, Sprite B = Block
            if (spriteA.tag == 1 && spriteB.tag == 2) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyB)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyB);
                    brokenBlocks++;
                }
            }
            // Sprite B = block, Sprite A = ball
            else if (spriteA.tag == 2 && spriteB.tag == 1) {
                if (std::find(toDestroy.begin(), toDestroy.end(), bodyA)
                    == toDestroy.end()) {
                    toDestroy.push_back(bodyA);
                    brokenBlocks++;
                }
            }
        }
    }
    
    std::vector<b2Body *>::iterator pos2;
    for(pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        if (body->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *) body->GetUserData();
            [self removeChild:sprite cleanup:YES];
        }
        _world->DestroyBody(body);
    }
    if (!blockFound) {
        [self stopMinigame];
        //NSLog(@"Alle Weg! Gewonnen!");
    }
}

-(void) stopMinigame{
    if (timeCount > 3) {
        timeCount = 3;
    }
    ballBody->SetType(b2_staticBody);
    _paddleBody->SetType(b2_staticBody);
    
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    if (_paddleFixture->TestPoint(locationWorld)) {
        b2MouseJointDef md;
        md.bodyA = _groundBody;
        md.bodyB = _paddleBody;
        md.target = locationWorld;
        md.collideConnected = true;
        md.maxForce = 1000.0f * _paddleBody->GetMass();
        
        _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
        _paddleBody->SetAwake(true);
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


        evaluation = brokenBlocks/blockCount;
   ballBody->SetType(b2_staticBody);
    //NSLog(@"Win %f", evaluation);
    int powerDuration;
    //abstufung je nachdem wie gut man ein spiel geschafft hat
    if (evaluation == 0) {
        powerDuration = 0;
    }else if (evaluation > 0 && evaluation <= 0.20){
        powerDuration = 0;
    }else if (evaluation > 20 && evaluation <= 0.40){
        powerDuration = 3;
    }else if (evaluation > 40 && evaluation <= 0.60){
        powerDuration = 3;
    }else if (evaluation > 60 && evaluation <= 0.80){
        powerDuration = 6;
    }else if (evaluation > 80 && evaluation < 0.100){
        powerDuration = 6;
    }else if (evaluation == 0.100){
        powerDuration = 9;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(int)powerDuration forKey:@"powerDuration"];
}

- (void)dealloc {
    
    if (_world) {
        delete _world;
        _world = NULL;
    }
    /*
    if (debugDraw) {
        delete debugDraw;
        debugDraw = nil;
    }
     */
    _groundBody = NULL;
    delete _contactListener;
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    [super dealloc];
    
}

@end
