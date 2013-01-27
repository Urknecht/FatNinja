//
//  GameOverScene.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/2/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "GameOverScene.h"
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "GameScene.h"

@implementation GameOverScene
int _endDistance;
int _sushiCounter;
int _score;
NSMutableArray *localScores;

-(id)initWith: (int) distance andSushi: (int) sushiCounter {
    self = [super init];
    if (self != nil) {
        
#pragma mark highscore get
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *localScoresImmutable = [defaults arrayForKey:@"localScores"];
        // NSUserDefaults geben IMMER Immutable Objects zurück, deswegen muss das array extra in ein Mutable koopiert werden.
        localScores = [NSMutableArray arrayWithArray:localScoresImmutable];
        
        //Distanz
        _endDistance=distance;
        _sushiCounter=sushiCounter;
        //Score dann aufaddieren
       _score=distance+sushiCounter*30;
        
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"gameOverBackground.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];

        
	// Default font size will be 30 points.
	[CCMenuItemFont setFontSize:30];
	
	// Replay Button
        CCMenuItemLabel *replay = [CCMenuItemFont itemWithString:@"Replay" block:^(id sender){

            [[CCDirector sharedDirector] replaceScene:[GameScene node]];

        }];
	
	
	// Main Menu Item
	CCMenuItem *backToMainMenu = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {

        [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];

	}];
	
	// Shop Menu Item
//	CCMenuItem *shop = [CCMenuItemFont itemWithString:@"Shop" block:^(id sender) {
//		
//	}];
	
	CCMenu *menu = [CCMenu menuWithItems:backToMainMenu, replay, nil];
	
	[menu alignItemsHorizontallyWithPadding:20];
	
	CGSize size = [[CCDirector sharedDirector] winSize];
	[menu setPosition:ccp( size.width/2, size.height/3)];
	
	
	[self addChild: menu z:1];

        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Run Finished" fontName:@"Marker Felt" fontSize:30];
        [self addChild:label z:2];
        label.position = ccp( size.width/2, size.height-50);
    
        //Distanz
        CCLabelTTF *distanceLabel = [CCLabelTTF labelWithString:@"Distance:" fontName:@"Marker Felt" fontSize:25];
        [distanceLabel setString:[NSString stringWithFormat:@"Distance:      %i",_endDistance]];

        [self addChild:distanceLabel z:2];
        distanceLabel.position = ccp( size.width/2, size.height-90);
        
        //Sushi
        CCLabelTTF *sushiLabel = [CCLabelTTF labelWithString:@"Distance:" fontName:@"Marker Felt" fontSize:25];
        [sushiLabel setString:[NSString stringWithFormat:@"Sushi:   %i * 30",_sushiCounter]];
        
        [self addChild:sushiLabel z:2];
        sushiLabel.position = ccp( size.width/2, size.height-120);
        
        //Score
        CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:@"Score:" fontName:@"Marker Felt" fontSize:25];
        [scoreLabel setString:[NSString stringWithFormat:@"Score:         %i",_score]];
        
        [self addChild:scoreLabel z:2];
        scoreLabel.position = ccp( size.width/2, size.height-150);

        
        [localScores addObject:[NSNumber numberWithInt:_score]];
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [localScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        NSLog(@"sortedArray=%@",localScores);
        
        [defaults setObject:localScores forKey:@"localScores"];
        [defaults synchronize];
        

    }
    return self;
}

-(void)dealloc{
    [super dealloc];

}
@end
