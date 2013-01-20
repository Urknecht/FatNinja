//
//  Ninja.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/19/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import "Ninja.h"
#import "GameLayer.h"
#import "Constants.h"



@implementation Ninja
-(id)initWithWorld: (b2World*) physicworld {
    self = [super init];
    if (self != nil) {
        world=physicworld;
//        self.isJumping= false;
//        self.isDoubleJumping= false;
//        self.isDying = false;
//        self.isRolling = false;
        [self loadAnims];
        
        self.ninjaJumpMove = [CCJumpBy actionWithDuration:1.0f
                                                 position:ccp(0, 0)
                                                   height:70.0f
                                                    jumps:1];
        
        self.ninjaDoubleJumpMove= [CCSequence actions: [CCJumpBy actionWithDuration:0.3f
                                                                           position:ccp(0, 0)
                                                                             height:50.0f
                                                                              jumps:1],[CCJumpBy actionWithDuration:0.7f
                                                                                                           position:ccp(0, 0)
                                                                                                             height:120.0f
                                                                                                              jumps:1],nil];
    }
    return self;
    
}



-(void) jump{
    if(characterState!=StateJumping&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        
       [self setCharacterState: StateJumping];
        
        [_spriteSheetJumping setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaJumping runAction:self.jumpAction];
        [_ninjaRunning stopAction: self.walkSpeedAction];
        
        
        [_ninjaJumping runAction:
         [CCSequence actions:
          self.ninjaJumpMove,
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             [self setCharacterState: StateStart];
             [_spriteSheetJumping setVisible:(false)];
             [_ninjaJumping stopAction:self.jumpAction];
             if(!_wasJumpingAndThrowing){//Falls ein Shuricen gleichzeitig geworfen wurde
                 [_spriteSheetRunning setVisible:(true)];
                 [_ninjaRunning runAction: self.walkSpeedAction];
             }
         }],
          nil]];
        
        //ThrowLayer soll immer auf der gleichen Position sein, falls man schießen und hüfen gleichzeitig will
        [_spriteSheetThrow runAction:[[self.ninjaJumpMove copy] autorelease]]; // for all subsequent uses
    }
}

-(void) doubleJump{
    if(characterState!=StateDoubleJumping&&characterState!=StateDie&&characterState!=StateJumping){
        
        [self setCharacterState: StateDoubleJumping];
        
        [_spriteSheetDoubleJump setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaDoubleJump runAction:self.doubleJumpAction];
        [_ninjaRunning stopAction: self.walkSpeedAction];
        
        [_ninjaDoubleJump runAction:
         [CCSequence actions:
          self.ninjaDoubleJumpMove,
          
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [self setCharacterState: StateStart];
             [_spriteSheetDoubleJump setVisible:(false)];
             [_ninjaDoubleJump stopAction:self.doubleJumpAction];
             
             if(!_wasJumpingAndThrowing){//Falls ein Shuricen gleichzeitig geworfen wurde
                 [_ninjaRunning runAction: self.walkSpeedAction];
                 [_spriteSheetRunning setVisible:(true)];
             }
             
         }],
          nil]];
        
        //im moment kein throw bei double jump moeglich
        
    }
}

-(void) startRoll{
    if(characterState!=StateRolling&&characterState!=StateJumping&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        
        [self setCharacterState: StateRolling];
        [_spriteSheetRoll setVisible:(true)];
        [_spriteSheetRunning setVisible:(false)];
        [_ninjaRoll runAction:self.rollAction];
        [_ninjaRunning stopAction: self.walkSpeedAction];
    }
}

-(void) endRoll{
    if(characterState==StateRolling){
        [self setCharacterState: StateStart];
        [_spriteSheetRoll setVisible:(false)];
        [_spriteSheetRunning setVisible:(true)];
        [_ninjaRoll stopAction:self.rollAction];
        [_ninjaRunning runAction: self.walkSpeedAction];
    }
}

-(void) throwProjectile:(GameLayer *)gameLayer{
    if(characterState!=StateRolling&&characterState!=StateThrowing&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        _wasJumpingAndThrowing = false;
        
        [self setCharacterState: StateThrowing];
        [_spriteSheetThrow setVisible:(true)];
        if(characterState==StateJumping){
            _wasJumpingAndThrowing = true;
            [_spriteSheetJumping setVisible:(false)];
        }
        else{
            [_spriteSheetRunning setVisible:(false)];
            [_ninjaRunning stopAction: self.walkSpeedAction];
        }
        
        [_ninjaThrow runAction:
         [CCSequence actions: [CCAnimate actionWithAnimation:self.throwAnim],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             [self setCharacterState: StateStart];
             [_spriteSheetThrow setVisible:(false)];
             if(characterState==StateJumping){
                 [_spriteSheetJumping setVisible:(true)];
                 _wasJumpingAndThrowing = false;
             }
             else{
                 [_spriteSheetRunning setVisible:(true)];
                 [_ninjaRunning runAction: self.walkSpeedAction];
             }
             
         }],
          nil]];
        
        [gameLayer throwProjectile];
    }
}

-(void) die:(GameLayer *)gameLayer{
    
    if(characterState!=StateJumping&&characterState!=StateThrowing&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        [self setCharacterState: StateDie];
        
        if(characterState==StateRolling){
            [_ninjaRoll stopAction:self.rollAction];
        }
        else{
            [_ninjaRunning stopAction: self.walkSpeedAction];
        }
        NSLog(@"ninja1");
        
        [self removeChild:(_spriteSheetRoll)];
        [self removeChild:(_spriteSheetRunning)];
        [self removeChild:(_spriteSheetJumping)];
        [self removeChild:(_spriteSheetDoubleJump)];
        [self removeChild:(_spriteSheetThrow)];
        NSLog(@"ninja2");
        [_spriteSheetDie setVisible:(true)];
        [_ninjaDie runAction:self.dieAction];
        
        [_ninjaDie runAction:
         [CCSequence actions:
          [CCFadeTo actionWithDuration:3 opacity:0],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             [gameLayer endGame];
             //self.isDying = false;
         }], nil]];
    }
}

- (b2Body*)createNinjaAtLocation:(CGPoint)location withSize:(CGSize)size {
    
    b2BodyDef bodyDef;      //body erstellen
    bodyDef.type = b2_dynamicBody; //dynamic: box2d kuemmert sich um bewegungen
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 25.0/PTM_RATIO;
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &circle;
    fixtureDef.density = 2.0;           //für gewicht,desto hoeher desto schwerer, bei 0 wird es static bewegt sich nicht mehr !, default ist 0
    //mass=density*volume
    body->CreateFixture(&fixtureDef);
    return body;
    
}


-(void)loadAnims{
    
    
    
    //RUNNING###########################################################
    //add the frames and coordinates to the cach
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaRunning.plist")];
    
    //load the sprite sheet into a CCSpriteBatchNode object. If you’re adding a new sprite
    //to your scene, and the image exists in this sprite sheet you should add the sprite
    //as a child of the same CCSpriteBatchNode object otherwise you could get an error.
    _spriteSheetRunning = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRunning.png"];
    //add the CCSpriteBatchNode to your scene
    [self addChild: _spriteSheetRunning];
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *walkAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaRunning%d.png", i]]];
    }
    //Create the animation from the frame flyAnimFrames array
    CCAnimation *walkAnim = [CCAnimation animationWithSpriteFrames:walkAnimFrames delay:0.1f];
    
    //create a sprite and set it to be the first image in the sprite sheet
    _ninjaRunning = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaRunning1.png"];
    
    //create a looping action using the animation created above. This just continuosly
    //loops through each frame in the CCAnimation object
    
    
    self.walkSpeedAction = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:
                                                       [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]] speed:1.0f];
    [self.walkSpeedAction setTag:'walk'];
    
    //start the action
    [_ninjaRunning runAction: self.walkSpeedAction];
    
    //set its position to be dead center, i.e. screen width and height divided by 2
    CGSize winSize = [CCDirector sharedDirector].winSize;
    _ninjaRunning.scale = (winSize.height / 400) ;
    //_ninjaRunning.position = ccp(_ninjaRunning.contentSize.width, winSize.height / 3);
    CGPoint location = ccp(_ninjaRunning.contentSize.width, winSize.height);
	b2Body *body=[self createNinjaAtLocation:location withSize:_ninjaRunning.contentSize];
    
    [_ninjaRunning setPTMRatio:PTM_RATIO];
	[_ninjaRunning setBody:body];
	[_ninjaRunning setPosition: location];
    [_spriteSheetRunning addChild:_ninjaRunning];
    
    //JUMPING###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaJumping.plist")];
    _spriteSheetJumping = [CCSpriteBatchNode batchNodeWithFile:@"NinjaJumping.png"];
    [self addChild:_spriteSheetJumping];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *jumpAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [jumpAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaJumping%d.png", i]]];
    }
    
    CCAnimation *jumpAnim = [CCAnimation animationWithSpriteFrames:jumpAnimFrames delay:0.05f];
    _ninjaJumping = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaJumping1.png"];
    
    self.jumpAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:jumpAnim]];
    _ninjaJumping.scale = (winSize.height / 400) ;
    [_ninjaJumping setPTMRatio:PTM_RATIO];
	[_ninjaJumping setBody:body];
	[_ninjaJumping setPosition: location];
    //_ninjaJumping.position = ccp(_ninjaJumping.contentSize.width, winSize.height / 3);
    
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetJumping addChild:_ninjaJumping];
    [_spriteSheetJumping setVisible:(false)];
    
    //DOUBLEJUMPING###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaDoubleJump.plist")];
    _spriteSheetDoubleJump = [CCSpriteBatchNode batchNodeWithFile:@"NinjaDoubleJump.png"];
    [self addChild:_spriteSheetDoubleJump];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *doubleJumpAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 11; ++i) {
        [doubleJumpAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaDoubleJump%d.png", i]]];
    }
    
    CCAnimation *doubleJumpAnim = [CCAnimation animationWithSpriteFrames:doubleJumpAnimFrames delay:0.05f];
    _ninjaDoubleJump = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaDoubleJump1.png"];
    
    self.doubleJumpAction = [CCRepeatForever actionWithAction:
                             [CCAnimate actionWithAnimation:doubleJumpAnim]];
    _ninjaDoubleJump.scale = (winSize.height / 400) ;
    //_ninjaDoubleJump.position = ccp(_ninjaJumping.contentSize.width, winSize.height / 3);
    [_ninjaDoubleJump setPTMRatio:PTM_RATIO];
	[_ninjaDoubleJump setBody:body];
	[_ninjaDoubleJump setPosition: location];
    
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetDoubleJump addChild:_ninjaDoubleJump];
    [_spriteSheetDoubleJump setVisible:(false)];
    
    
    
    //ROLLEN###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaRoll.plist")];
    _spriteSheetRoll = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRoll.png"];
    [self addChild:_spriteSheetRoll];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *rollAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [rollAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaRoll%d.png", i]]];
    }
    
    CCAnimation *rollAnim = [CCAnimation animationWithSpriteFrames:rollAnimFrames delay:0.02f];
    _ninjaRoll = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaRoll1.png"];
    
    self.rollAction = [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:rollAnim]];
    _ninjaRoll.scale = (winSize.height / 350) ;
    //_ninjaRoll.position = ccp(_ninjaRoll.contentSize.width, winSize.height / 3);
    [_ninjaRoll setPTMRatio:PTM_RATIO];
	[_ninjaRoll setBody:body];
	[_ninjaRoll setPosition: location];
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetRoll addChild:_ninjaRoll];
    [_spriteSheetRoll setVisible:(false)];
    
    //DIE##########################################################
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaDie.plist")];
    self.spriteSheetDie = [CCSpriteBatchNode batchNodeWithFile:@"NinjaDie.png"];
    [self addChild:_spriteSheetDie];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *dieAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 8; ++i) {
        [dieAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaDie%d.png", i]]];
    }
    
    CCAnimation *dieAnim = [CCAnimation animationWithSpriteFrames:dieAnimFrames delay:0.08f];
    _ninjaDie = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaDie1.png"];
    
    self.dieAction =  [CCAnimate actionWithAnimation:dieAnim];
    _ninjaDie.scale = (winSize.height / 400) ;
    //_ninjaDie.position = ccp(_ninjaDie.contentSize.width, winSize.height / 3);
    [_ninjaDie setPTMRatio:PTM_RATIO];
	[_ninjaDie setBody:body];
	[_ninjaDie setPosition: location];
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetDie addChild:_ninjaDie];
    [_spriteSheetDie setVisible:(false)];
    
    //THROW##########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaThrowShuricen.plist")];
    self.spriteSheetThrow = [CCSpriteBatchNode batchNodeWithFile:@"NinjaThrowShuricen.png"];
    [self addChild:_spriteSheetThrow];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *throwAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [throwAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaThrowShuricen%d.png", i]]];
    }
    
    self.throwAnim = [CCAnimation animationWithSpriteFrames:throwAnimFrames delay:0.04f];
    _ninjaThrow = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaThrowShuricen1.png"];
    
    //self.throwAction =  [CCAnimate actionWithAnimation:throwAnim];
    
    _ninjaThrow.scale = (winSize.height / 400) ;
    //_ninjaThrow.position = ccp(_ninjaThrow.contentSize.width, winSize.height / 3);
    [_ninjaThrow setPTMRatio:PTM_RATIO];
	[_ninjaThrow setBody:body];
	[_ninjaThrow setPosition: location];
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetThrow addChild:_ninjaThrow];
    [_spriteSheetThrow setVisible:(false)];
    
}


-(void) reloadAnimsWithSpeed:(double)geschwindigkeit{
    if(characterState!=StateDie){
        id speedAction = [_ninjaRunning getActionByTag:'walk'];
        [speedAction setSpeed: (1.0f/geschwindigkeit)];
    }}


-(CCSprite*)getCurrentNinjaSprite{
    if(characterState==StateJumping){
        return _ninjaJumping;
    }else if(characterState==StateDoubleJumping){
        return _ninjaDoubleJump;
    }
    else if(characterState==StateRolling){
        return _ninjaRoll;
    }
    else if(characterState==StateDie){
        return _ninjaDie;
    }
    else if(characterState==StateThrowing){
        return _ninjaThrow;
    }
    else{
        return _ninjaRunning;
    }
}


-(void) dealloc {
    [super dealloc];
}
-(int)getWeaponDamage {
    // Default to zero damage
    CCLOG(@"getWeaponDamage should be overridden");
    return 0;
}
-(void)checkAndClampSpritePosition {
    CGPoint currentSpritePosition = [self position];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        // Clamp for the iPad
        if (currentSpritePosition.x < 30.0f) {
            [self setPosition:ccp(30.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 1000.0f) {
            [self setPosition:ccp(1000.0f, currentSpritePosition.y)];
        }
    } else {
        // Clamp for iPhone, iPhone 4, or iPod touch
        if (currentSpritePosition.x < 24.0f) {
            [self setPosition:ccp(24.0f, currentSpritePosition.y)];
        } else if (currentSpritePosition.x > 456.0f) {
            [self setPosition:ccp(456.0f, currentSpritePosition.y)];
        }
    } }
@end
