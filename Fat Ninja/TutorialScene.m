//
//  TutorialScene.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "TutorialScene.h"
#import "cocos2d.h"
#import "GameScene.h"



@implementation TutorialScene
@synthesize next;

bool startgame;
CCAnimation *tut1Anim;
CCAnimation *tut2Anim;
CCAnimation *tut3Anim;
CCAnimation *tut4Anim;
CCSprite *tut1;
CCSprite *tut2;
CCSprite *tut3;
CCSprite *tut4;
NSString *descriptionJump;
NSString *descriptionDJump;
NSString *descriptionThrow;
NSString *descriptionRoll;
CCLabelTTF *jumpDescriptionText;
CCLabelTTF *dJumpDescriptionText;
CCLabelTTF *throwDescriptionText;
CCLabelTTF *rollDescriptionText;



-(void)dealloc{
    [super dealloc];
    //[self.next release];
}

- (id) init{
    self = [super init];
    if (self != nil) {
        startgame=false;
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"tutBg.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
        
        BOOL showTutorial = true;

#pragma mark descriptions
        
        descriptionJump = @"Tap once to jump over obstacles.";
        descriptionDJump = @"Tap twice to bounce of the ground and jump higher";
        descriptionThrow = @"By swiping right you can throw shuriken to kill enemies.";
        descriptionRoll = @"Roll by swiping down and holding as long as you want to roll.";
        
        
        jumpDescriptionText = [CCLabelTTF labelWithString: descriptionJump dimensions:CGSizeMake(100, 150)
                                    alignment:UITextAlignmentLeft  fontName: @"Marker Felt" fontSize:14 ];
        jumpDescriptionText.color = ccc3(66,53,32);
        jumpDescriptionText.position = ccp( 380 , 200 );
        [self addChild: jumpDescriptionText];
        
        
         dJumpDescriptionText = [CCLabelTTF labelWithString: descriptionDJump dimensions:CGSizeMake(100, 150)
                                                            alignment:UITextAlignmentLeft  fontName: @"Marker Felt" fontSize:14 ];
        dJumpDescriptionText.color = ccc3(66,53,32);
        dJumpDescriptionText.position = ccp( 380 , 100 );
        [self addChild: dJumpDescriptionText];

        throwDescriptionText = [CCLabelTTF labelWithString: descriptionThrow dimensions:CGSizeMake(100, 150)
                                                 alignment:UITextAlignmentLeft  fontName: @"Marker Felt" fontSize:14 ];
        throwDescriptionText.color = ccc3(66,53,32);
        throwDescriptionText.position = ccp( 380 , 200 );
        [throwDescriptionText setVisible:false];
        [self addChild: throwDescriptionText];
        
        
        rollDescriptionText = [CCLabelTTF labelWithString: descriptionRoll dimensions:CGSizeMake(100, 150)
                                                 alignment:UITextAlignmentLeft  fontName: @"Marker Felt" fontSize:14 ];
        rollDescriptionText.color = ccc3(66,53,32);
        rollDescriptionText.position = ccp( 380 , 100 );
        [rollDescriptionText setVisible:false];
        [self addChild: rollDescriptionText];
        
        
        
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:showTutorial forKey:@"showTutorial"];
//        [defaults synchronize];
//        NSLog(@"Data saved");
        
        

        
        // Default font size will be 30 points.
        [CCMenuItemFont setFontSize:30];
                
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Für Bilder später
//        CCMenuItem *starMenuItem = [CCMenuItemImage
//                                    itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
//                                    target:self selector:@selector(starButtonTapped:)];
        
        next = [CCMenuItemFont itemWithString:@"Continue" target:self selector:@selector(showNextTut)];
        ;

        next.position = ccp(350, 60);
        
        CCMenu *tutMenu = [CCMenu menuWithItems:next, nil];
        tutMenu.position = CGPointZero;
        [self addChild:tutMenu z:1 tag:1];
        
        [self loadAnims];
        [self addChild:tut1];
        [self addChild:tut2];
        
        [tut3 setVisible:false];
        [self addChild:tut3];
        
        [tut4 setVisible:false];
        [self addChild:tut4];
        
    }
    return self;
}

-(void) showNextTut{
    if(!startgame){
        [tut1 setVisible:false];
        [tut2 setVisible:false];
        [jumpDescriptionText setVisible:false];
        [dJumpDescriptionText setVisible:false];
        
        [tut3 setVisible:true];
        [tut4 setVisible:true];
        [throwDescriptionText setVisible:true];
        [rollDescriptionText setVisible:true];
        startgame = true;
    }else{
        [[CCDirector sharedDirector] replaceScene:[GameScene node]];
    }

}

-(void)loadAnims{
    

    //JUMPING###########################################################
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile: (@"tutorialSpriteSheet.plist")];
    CCSpriteBatchNode *_tutorialSpriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"tutorialSpriteSheet.png"];
    [self addChild:_tutorialSpriteSheet];
    
    //load each frame included in the sprite sheet into an array for use with the CCAnimation object below
    NSMutableArray *tut1Frames = [NSMutableArray array];
    for(int i = 1; i <= 5; ++i) {
        [tut1Frames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"tut1%d.png", i]]];
    }
    
    NSMutableArray *tut2Frames = [NSMutableArray array];
    for(int i = 1; i <= 9; ++i) {
        [tut2Frames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"tut2%d.png", i]]];
    }
    NSMutableArray *tut3Frames = [NSMutableArray array];
    for(int i = 1; i <= 7; ++i) {
        [tut3Frames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"tut3%d.png", i]]];
    }
    NSMutableArray *tut4Frames = [NSMutableArray array];
    for(int i = 1; i <= 7; ++i) {
        [tut4Frames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
          [NSString stringWithFormat:@"tut4%d.png", i]]];
    }
    
    tut1Anim = [CCAnimation animationWithSpriteFrames:tut1Frames delay:0.1f];
    tut2Anim = [CCAnimation animationWithSpriteFrames:tut2Frames delay:0.1f];
    tut3Anim = [CCAnimation animationWithSpriteFrames:tut3Frames delay:0.1f];
    tut4Anim = [CCAnimation animationWithSpriteFrames:tut4Frames delay:0.1f];
    
    tut1 = [CCSprite spriteWithSpriteFrameName:@"tut11.png"];
    tut1.position = ccp(220.0f,270.0f);
    tut1.scale = 0.7;
    tut2 = [CCSprite spriteWithSpriteFrameName:@"tut21.png"];
    tut2.position = ccp(220.0f,170.0f);
    tut2.scale = 0.7;
    tut3 = [CCSprite spriteWithSpriteFrameName:@"tut31.png"];
    tut3.position = ccp(220.0f,270.0f);
    tut3.scale = 0.7;
    tut4 = [CCSprite spriteWithSpriteFrameName:@"tut41.png"];
    tut4.position = ccp(220.0f,170.0f);
    tut4.scale = 0.7;
    
    [tut1 runAction:[CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:tut1Anim restoreOriginalFrame:NO]]];

    [tut2 runAction:[CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:tut2Anim restoreOriginalFrame:NO]]];

    [tut3 runAction:[CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:tut3Anim restoreOriginalFrame:NO]]];

    [tut4 runAction:[CCRepeatForever actionWithAction:
                     [CCAnimate actionWithAnimation:tut4Anim restoreOriginalFrame:NO]]];
    

    
    
}


@end
