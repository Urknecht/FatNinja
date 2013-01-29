//
//  HighscoreScene.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/29/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "HighscoreScene.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"


@implementation HighscoreScene

Highscore *highscore;

-(id) init{
    self = [super init];
    if(self != nil){
        CGSize windowSize = [CCDirector sharedDirector].winSize;

        highscore = [[Highscore alloc] init];
        [highscore printLocalScores];
        
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"paperBg.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Top 10 Scores" fontName:@"Marker Felt" fontSize:24.0];
        title.color = ccc3(66,53,32);
        
        [title setPosition:ccp(windowSize.width / 2, windowSize.height-30)];
        [self addChild:title];

        [self drawHighScores];

    }
    
    return self;
    
}

-(void) drawHighScores{
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    NSMutableString *scoresString = [NSMutableString stringWithString:@""];
    for (int i = 0; i < [[highscore localScores] count]; i++)
    {
        [scoresString appendFormat:@"%i. %i\n", i + 1, [[[highscore localScores] objectAtIndex:i] intValue]];
    }
    
    CCLabelTTF *scoresLabel = [CCLabelTTF labelWithString:scoresString fontName:@"Marker Felt" fontSize:18.0];
    scoresLabel.color = ccc3(66,53,32);

    [scoresLabel setPosition:ccp(winSize.width / 2, winSize.height / 2)];
    [self addChild:scoresLabel];
    
    [CCMenuItemFont setFontSize:24];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    
    CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"Back To Main Menu" target:self selector:@selector(backToMain)];
    back.position = ccp(winSize.width/2, 30);
    back.color = ccc3(66,53,32);

    
    CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
    backMenu.position = CGPointZero;
    [self addChild:backMenu z:1 tag:1];


}

-(void) backToMain{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}
@end
