//
//  MinigameLayer.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameLayer.h"

#import "MinigameLayer.h"

@implementation MinigameLayer

@synthesize game;
@synthesize description;
@synthesize timeCount;
@synthesize evaluation;
@synthesize powerDuration;

- (id) init
{
    if ((self = [super init])) {
        
        //zählt timer runter
        [self schedule:@selector(timer:)interval:1.0];
        
        
    }
    
    [self setTouchEnabled:YES];
    
    return self;
    
}

- (void)timer:(ccTime)dt {
    timeCount--;
}

- (void)createGround {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    marginbot = 5.0f;
    margintop = 0.0f;
    marginx = 80.0f;
    
    x_left = marginx;
    x_right = winSize.width-marginx;
    y_bottom = marginbot;
    y_top = winSize.height-margintop;
    
    gameWidth = x_right - x_left;
    gameHeight = y_top - y_bottom;
    
    b2Vec2 lowerLeft = b2Vec2(x_left/PTM_RATIO, y_bottom/PTM_RATIO);
    b2Vec2 lowerRight = b2Vec2((x_right)/PTM_RATIO,
                               y_bottom/PTM_RATIO);
    b2Vec2 upperRight = b2Vec2((x_right)/PTM_RATIO,
                               (y_top)/PTM_RATIO);
    b2Vec2 upperLeft = b2Vec2(x_left/PTM_RATIO,
                              (y_top)/PTM_RATIO);
    
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    b2EdgeShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    groundBox.Set(lowerLeft, lowerRight);
    _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
    groundBox.Set(lowerRight, upperRight);
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.Set(upperRight, upperLeft);
    _groundBody->CreateFixture(&groundBoxDef);
    groundBox.Set(upperLeft, lowerLeft);
    _groundBody->CreateFixture(&groundBoxDef);
    
}


@end

