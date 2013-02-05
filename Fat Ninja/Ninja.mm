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
b2Body *bodyNinja;

-(id)initWithWorld: (b2World*) physicworld {
    self = [super init];
    if (self != nil) {
        world=physicworld;
        
        _jumpWasDouble = false;
        _wasJumpingAndThrowing = false;
        _shouldDie=false;
        _runningFast=false;
        _geschToChange = false;
        _isInvincibru = false;
        _geschwindigkeit = 5;
        
        [self loadAnims];
        gameObjectType=Character;
        self.ninjaJumpMove = [CCJumpBy actionWithDuration:1.5f
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

-(void) changeState:(CharacterStates)newState{
    if(characterState!=newState){
        // [self stopAllActions];
        //    id action = nil;
        
        //BEENDE alte Animationen etc
        switch (characterState) {
            case StateStart:
                [_spriteSheetRunning setVisible:(false)];
                [_ninjaRunning stopAction: self.walkSpeedAction];
                break;
            case StateJumping:
                [_spriteSheetJumping setVisible:(false)];
                if(newState != StateThrowing){
                    //Beende Jumpen
                    [_ninjaJumping stopAction:self.jumpAction];
                }
                break;
            case StateDoubleJumping:
                [_spriteSheetDoubleJump setVisible:(false)];
                if(newState != StateThrowing){
                    //Beende DoubleJumpen
                    [_ninjaDoubleJump stopAction:self.doubleJumpAction];
                }
                break;
            case StateRolling:
                //End Rolling
                [_spriteSheetRoll setVisible:(false)];
                [_ninjaRoll stopAction:self.rollAction];
                break;
            case StateThrowing:
                //Beende Throw
                [_spriteSheetThrow setVisible:(false)];
                break;
                
            case StateInvincibruRolling:
                self.isInvincibru = false;
                [_spriteSheetRoll setVisible:(false)];
                [_ninjaRoll stopAction:self.rollAction];
                break;
            case StateBIG:
                self.isInvincibru = false;
                [_spriteSheetBIG setVisible:(false)];
                [_ninjaBIG stopAction:self.BIGAction];
                break;
                
            default:
                break;
        }
        
        
        //Starte neue
        switch (newState) {
                
            case StateStart:
                [_spriteSheetRunning setVisible:(true)];
                [_ninjaRunning runAction: self.walkSpeedAction];
                if(_geschToChange){
                    [self reloadAnimsWithSpeed: _geschwindigkeit];
                }
                break;
            case StateJumping:
                [_spriteSheetJumping setVisible:(true)];
                if(!_wasJumpingAndThrowing){
                    [_ninjaJumping runAction:self.jumpAction];
                }
                _wasJumpingAndThrowing = false;
                break;
                
            case StateDoubleJumping:
                [_spriteSheetDoubleJump setVisible:(true)];
                if(!_wasJumpingAndThrowing){
                    [_ninjaDoubleJump runAction:self.doubleJumpAction];
                }
                _wasJumpingAndThrowing = false;
                break;
                
            case StateRolling:
                [_spriteSheetRoll setVisible:(true)];
                [_ninjaRoll runAction:self.rollAction];
                break;
                
            case StateDie:
                //sterbe animation, am ende muss gegner gelöscht werden
                break;
                
            case StateThrowing:
                [_spriteSheetThrow setVisible:(true)];
                
                if(characterState==StateJumping){
                    _wasJumpingAndThrowing = true;
                    
                }
                else if(characterState==StateDoubleJumping){
                    _wasJumpingAndThrowing = true;
                    _jumpWasDouble = true;
                }
                break;
           
            case StateBIG:
                   self.isInvincibru  = true;
                [_spriteSheetBIG setVisible:(true)];
                [_ninjaBIG runAction:self.BIGAction];
                break;     
            
           case StateInvincibruRolling:
               self.isInvincibru  = true;
                [_spriteSheetRoll setVisible:(true)];
                [_ninjaRoll runAction:self.rollAction];
                break;
                
            default:
                break;
        }
        
        [self setCharacterState:newState];
        
        
    }
}


-(void) jump{
    if(characterState!=StateJumping&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        
        //Change State
        [self changeState: StateJumping];
        
        //Animation
        [_ninjaJumping runAction:
         [CCSequence actions:
          self.ninjaJumpMove,
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             //Starte Neuen Status
             if(!_wasJumpingAndThrowing){//Falls kein Shuricen gleichzeitig geworfen wurde
                 [self changeState: StateStart];
             }
             else{
                 _wasJumpingAndThrowing = false;
                  [_ninjaJumping stopAction:self.jumpAction];
             }
             if(_shouldDie){
                 [self die:_gameLayer];
             }
             
         }],
          nil]];
        
    }
}

-(void) doubleJump{
    if(characterState!=StateDoubleJumping&&characterState!=StateDie&&characterState!=StateJumping){
        
        //Change State
        [self changeState: StateDoubleJumping];
        
        
        //Animation
        [_ninjaDoubleJump runAction:
         [CCSequence actions:
          self.ninjaDoubleJumpMove,
          
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             
             if(!_wasJumpingAndThrowing){//Falls ein Shuricen gleichzeitig geworfen wurde
                 [self changeState: StateStart];
                 
             }
             else{
                 _wasJumpingAndThrowing = false;
                  [_ninjaDoubleJump stopAction:self.doubleJumpAction];
             }
             if(_shouldDie){
                 [self die:_gameLayer];
             }
             
         }],
          nil]];
        
        //im moment kein throw bei double jump moeglich
        
    }
}

-(void) startRoll{
    if(characterState!=StateRolling&&characterState!=StateJumping&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        [self changeState: StateRolling];
    }
}

-(void) endRoll{
    if(characterState==StateRolling){
        
        [self changeState: StateStart];
        if(_shouldDie){
            [self die:_gameLayer];
        }
        
    }
}

-(void) throwProjectile:(GameLayer *)gameLayer{
    if(characterState!=StateRolling&&characterState!=StateThrowing&&characterState!=StateDie){
        
        
        
        [self changeState: StateThrowing];
        
        
        [_ninjaThrow runAction:
         [CCSequence actions: [CCAnimate actionWithAnimation:self.throwAnim],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             
             
             if(_wasJumpingAndThrowing){
                 
                 if(_jumpWasDouble){
                     [self changeState: StateDoubleJumping];
                 }
                 else{
                     [self changeState: StateJumping];
                     
                 }}
             
             else{
                 [self changeState: StateStart];
                 
             }
             if(_shouldDie){
                 [self die:_gameLayer];
             }
             
         }],
          nil]];
        
        [gameLayer throwProjectile];
    }
}

-(void) die:(GameLayer *)gameLayer{
    
    if(characterState!=StateJumping&&characterState!=StateThrowing&&characterState!=StateDie&&characterState!=StateDoubleJumping){
        
        [self setCharacterState: StateDie];
        
        _shouldDie = false;
        [gameLayer stopGame];
        
        [self removeChild:(_spriteSheetRoll)];
        [self removeChild:(_spriteSheetRunning)];
        [self removeChild:(_spriteSheetJumping)];
        [self removeChild:(_spriteSheetDoubleJump)];
        [self removeChild:(_spriteSheetThrow)];
        
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
    
    else{
        [self setCharacterState: StateDie];
        _shouldDie = true;
        _gameLayer = gameLayer;
    }
}


- (b2Body*)createNinjaAtLocation:(CGPoint)location withSize:(CGSize)size {
    
    b2BodyDef bodyDef;      //body erstellen
    bodyDef.type = b2_dynamicBody; //dynamic: box2d kuemmert sich um bewegungen
    bodyDef.position = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    bodyDef.fixedRotation=true;
    b2Body *body = world->CreateBody(&bodyDef);
    
    b2CircleShape circle1;
    circle1.m_radius = 23.0/PTM_RATIO;
    circle1.m_p.Set(0.06,-0.22);
    b2FixtureDef fixtureDef1;
    fixtureDef1.shape = &circle1;
    fixtureDef1.density = 5.0;
    //für gewicht,desto hoeher desto schwerer, bei 0 wird es static bewegt sich nicht mehr !, default ist 0
    //mass=density*volume
    body->CreateFixture(&fixtureDef1);
    
    b2CircleShape circle2;
    circle2.m_radius = 9.0/PTM_RATIO;
    circle2.m_p.Set(0.1,0.7);
    b2FixtureDef fixtureDef2;
    fixtureDef2.shape = &circle2;
    fixtureDef2.density = 0;
    body->CreateFixture(&fixtureDef2);
    
    return body;
    
}

-(b2Body*) getCurrentBody{
    return [self getCurrentNinjaSprite].body;
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
	bodyNinja=[self createNinjaAtLocation:location withSize:_ninjaRunning.contentSize];
    
    [_ninjaRunning setPTMRatio:PTM_RATIO];
	[_ninjaRunning setBody:bodyNinja];
	[_ninjaRunning setPosition: location];
    [_spriteSheetRunning addChild:_ninjaRunning];
    
    
    //RUNNING FAST###########################################################
    //add the frames and coordinates to the cach
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaRunningFast.plist")];
    
    //load the sprite sheet into a CCSpriteBatchNode object. If you’re adding a new sprite
    //to your scene, and the image exists in this sprite sheet you should add the sprite
    //as a child of the same CCSpriteBatchNode object otherwise you could get an error.
    _spriteSheetRunningFast = [CCSpriteBatchNode batchNodeWithFile:@"NinjaRunningFast.png"];
    
    //add the CCSpriteBatchNode to your scene
    [self addChild: _spriteSheetRunningFast];
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *walkFastAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i) {
        [walkFastAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaRunningFast%d.png", i]]];
    }
    //Create the animation from the frame flyAnimFrames array
    CCAnimation *walkAnimFast = [CCAnimation animationWithSpriteFrames:walkFastAnimFrames delay:0.1f];
    
    //create a sprite and set it to be the first image in the sprite sheet
    _ninjaRunningFast = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaRunningFast1.png"];
    
    //create a looping action using the animation created above. This just continuosly
    //loops through each frame in the CCAnimation object
    
    
    self.walkSpeedActionFast = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:
                                                           [CCAnimate actionWithAnimation:walkAnimFast restoreOriginalFrame:NO]] speed:1.0f];
    [self.walkSpeedActionFast setTag:'walkf'];
    
    //start the action
    //[_ninjaRunningFast runAction: self.walkSpeedActionFast];
    
    //set its position to be dead center, i.e. screen width and height divided by 2
    _ninjaRunningFast.scale = (winSize.height / 400) ;
    
    [_ninjaRunningFast setPTMRatio:PTM_RATIO];
	[_ninjaRunningFast setBody:bodyNinja];
	[_ninjaRunningFast setPosition: location];
    [_spriteSheetRunningFast addChild:_ninjaRunningFast];
    
    [_spriteSheetRunningFast setVisible:false];
    
    
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
    
    
    self.jumpAction = [CCSpeed actionWithAction: [CCRepeatForever actionWithAction:
                       [CCAnimate actionWithAnimation:jumpAnim restoreOriginalFrame:NO]] speed:1.0f];
    
    [self.jumpAction setTag:'jump'];
    
  
    _ninjaJumping.scale = (winSize.height / 400) ;
    [_ninjaJumping setPTMRatio:PTM_RATIO];
	[_ninjaJumping setBody:bodyNinja];
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
	[_ninjaDoubleJump setBody:bodyNinja];
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
	[_ninjaRoll setBody:bodyNinja];
	[_ninjaRoll setPosition: location];
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetRoll addChild:_ninjaRoll];
    [_spriteSheetRoll setVisible:(false)];
    
    //STAMPFEN NINJA BIG###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"NinjaBig.plist")];
    _spriteSheetBIG= [CCSpriteBatchNode batchNodeWithFile:@"NinjaBig.png"];
    [self addChild:_spriteSheetBIG];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *bigAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 15; ++i) {
        [bigAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"NinjaBig%d.png", i]]];
    }
    
    CCAnimation *bigAnim = [CCAnimation animationWithSpriteFrames:bigAnimFrames delay:0.02f];
    _ninjaBIG = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaBig1.png"];
    
    self.BIGAction = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:bigAnim]];
    _ninjaBIG.scale = (winSize.height / 350) ;
    
    [_ninjaBIG setPTMRatio:PTM_RATIO];
	[_ninjaBIG setBody:bodyNinja];
	[_ninjaBIG setPosition: location];
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetBIG addChild:_ninjaBIG];
    [_spriteSheetBIG setVisible:(false)];
    
    
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
    
    CCAnimation *dieAnim = [CCAnimation animationWithSpriteFrames:dieAnimFrames delay:0.1f];
    _ninjaDie = [CCPhysicsSprite spriteWithSpriteFrameName:@"NinjaDie1.png"];
    
    self.dieAction =  [CCAnimate actionWithAnimation:dieAnim];
    _ninjaDie.scale = (winSize.height / 400) ;
    //_ninjaDie.position = ccp(_ninjaDie.contentSize.width, winSize.height / 3);
    [_ninjaDie setPTMRatio:PTM_RATIO];
	[_ninjaDie setBody:bodyNinja];
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
	[_ninjaThrow setBody:bodyNinja];
	[_ninjaThrow setPosition: location];
    //add the sprite to the CCSpriteBatchNode object
    [_spriteSheetThrow addChild:_ninjaThrow];
    [_spriteSheetThrow setVisible:(false)];
    
}


-(void) reloadAnimsWithSpeed:(double)geschwindigkeit{
    if(characterState==StateStart){
        _geschToChange = false;
        
        if(geschwindigkeit>2||_runningFast){
            id speedAction = [_ninjaRunning getActionByTag:'walk'];
            [speedAction setSpeed: (5.0f/geschwindigkeit)];

        }
        else if(!_runningFast){
            _runningFast=true;
            [_ninjaRunning stopAllActions];
            [self removeChild:_spriteSheetRunning];
            
            self.walkSpeedAction = self.walkSpeedActionFast;
            _spriteSheetRunning = _spriteSheetRunningFast;
            _ninjaRunning = _ninjaRunningFast;
            [_spriteSheetRunning setVisible:true];
            [_ninjaRunning runAction: self.walkSpeedAction];
            
            
        }
    }
    else{
        _geschToChange = true;
        _geschwindigkeit = geschwindigkeit;
    }
    
}


-(CCPhysicsSprite*)getCurrentNinjaSprite{
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
