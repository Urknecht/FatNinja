//
//  TutorialScene.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "TutorialScene.h"
#import "cocos2d.h"


@implementation TutorialScene
@synthesize next;
@synthesize cursor;

bool startgame = false;
;
-(void)dealloc{
    [next release];
}

- (id) init{
    self = [super init];
    if (self != nil) {
        
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"gameOverBackground.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
        
        cursor = [CCSprite spriteWithFile:@"tutFinger.png"];
        CCTexture2D *cursorTexture = [cursor texture];
        
        CCSprite *cursor2 = [CCSprite spriteWithTexture:cursorTexture];
        
        CCAction *swipeDown = [CCMoveBy actionWithDuration:1.0f
                                                   position:ccp(0.0f,50.0f)];
        [cursor runAction:swipeDown];
        [self addChild:cursor z:10 tag:20];
        
        
        // Default font size will be 30 points.
        [CCMenuItemFont setFontSize:30];
                
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Für Bilder später
//        CCMenuItem *starMenuItem = [CCMenuItemImage
//                                    itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
//                                    target:self selector:@selector(starButtonTapped:)];
        
        CCMenuItemLabel *next = [CCMenuItemFont itemWithString:@"Next" target:self selector:@selector(showNextTut:)];
        ;

        next.position = ccp(350, 60);
        
        CCMenu *tutMenu = [CCMenu menuWithItems:next, nil];
        tutMenu.position = CGPointZero;
        [self addChild:tutMenu z:1 tag:1];
    }
    return self;
}
-(void) showNextTut{
}

@end
