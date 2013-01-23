//
//  MinigameFoodDrop.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameFoodDrop.h"

@implementation MinigameFoodDrop

NSMutableArray *dropStuff;
NSString *dropFood = @"1";
NSString *dropBomb = @"0";


- (id)init
{
    self = [super init];
    if (self) {
        
        [self initPhysics];
        [self scheduleUpdate];
        [self setTouchEnabled:YES];

        
        game = @"Omnom-Jutsu";
        description = @"Alles essen!";
        timeCount = 2;
        
        //Die Teile für richtiges Essen
        for (int i = 0; i < 15; i++) {
            [dropStuff addObject:dropFood];
        }
        //Die Teile für Bomben
        for (int j = 0; j < 3; j++) {
            [dropStuff addObject:dropBomb];
        }
        //Hier wird das Array gemischt
        for (int i = 0; i < dropStuff.count; i++) {
            int randomIndex = arc4random() % dropStuff.count;
            [dropStuff exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
        }
        
    }
    return self;
}

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

- (void)createBoxAtLocation:(CGPoint)location withSize:(CGSize)size {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position =
    b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = world->CreateBody(&bodyDef);
    b2PolygonShape shape;
    shape.SetAsBox(size.width/2/PTM_RATIO, size.height/2/PTM_RATIO);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0;
    body->CreateFixture(&fixtureDef);
}

- (void)registerWithTouchDispatcher {
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self
                                                     priority:0 swallowsTouches:YES];
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector]
                     convertToGL:touchLocation];
    touchLocation = [self convertToNodeSpace:touchLocation];
    b2Vec2 locationWorld =
    b2Vec2(touchLocation.x/PTM_RATIO, touchLocation.y/PTM_RATIO);
    [self createBoxAtLocation:touchLocation
                     withSize:CGSizeMake(50, 50)];
    return TRUE;
}

- (void)dealloc {
    [super dealloc];
    if (world) {
        delete world;
        world = NULL;
    }
    if (debugDraw) {
        delete debugDraw;
        debugDraw = nil;
    }    
}

@end

