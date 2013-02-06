//
//  MinigameScene.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/16/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameScene.h"
#import "cocos2d.h"
#import "MinigameLayer.h"
#import "MinigameFoodDrop.h"
#import "MinigameBreakout.h"


@implementation MinigameScene

int _gametype;
NSString *game;
NSString *description;
int timeCount;
CCLabelTTF *timeLabel;
MinigameLayer *minigamelayer;



- (id) initWith:(int)gametype andPointer: (NSInteger*)pointer{
    self = [super init];
    if (self != nil) {
        

        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"gameOverBackground.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
        
        // Default font size will be 30 points.
        [CCMenuItemFont setFontSize:30];
        _pointer = pointer;
        _gametype = gametype;
        
        switch (_gametype) {
            case 0:
                minigamelayer = [[MinigameFoodDrop alloc] init];
                break;
                
            case 1:
                minigamelayer = [[MinigameBreakout alloc] init];                
                break;
                
                
            default:
                break;
        }
        [self addChild: minigamelayer z:1];
        game = minigamelayer.game;
        timeCount = minigamelayer.timeCount;
        description = minigamelayer.description;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:game fontName:@"Marker Felt" fontSize:30 ];
        label.tag = 13;
        label.color = ccc3(66,53,32);

        [self addChild:label z:3];
        label.position = ccp( size.width/2, size.height-30);
        
        CCLabelTTF *labelDescription = [CCLabelTTF labelWithString:description fontName:@"Marker Felt" fontSize:20];
        labelDescription.tag = 11;
        [self addChild:labelDescription z:3];
        labelDescription.position = ccp( size.width/2, size.height-95);
        labelDescription.color = ccc3(66,53,32);

        
        //Zeit anzeige
        timeLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"0:%d",timeCount] fontName:@"Marker Felt" fontSize:45];
        timeLabel.tag = 9;
        timeLabel.color = ccc3(66,53,32);

        [self addChild:timeLabel z:3];
        timeLabel.position = ccp(50, winSize.height-25);
        
        [CCMenuItemFont setFontSize:50];
        CCMenuItemLabel *startMinigame = [CCMenuItemFont itemWithString:@"Tap Here To Start" target:self selector:@selector(startMinigame:)];
        startMinigame.color = ccc3(66,53,32);
        CCMenu *menu = [CCMenu menuWithItems:startMinigame, nil];
        [menu setPosition:ccp( size.width/2, size.height/3)];
        [menu setVisible:YES];
        menu.tag = 10;
        
        [self addChild: menu z:2];
        
        [[CCDirector sharedDirector] pause];
        
        //ruft timer ab
        [self schedule:@selector(timer:)interval:1.0];
        
        
    }
    return self;
}

- (void)timer:(ccTime)dt {
    timeCount = minigamelayer.timeCount;
    if (timeCount < 10 && timeCount > 0) {
        [timeLabel setString:[NSString stringWithFormat:@"0:0%i", timeCount]];
    }
    if (timeCount >=10){
        [timeLabel setString:[NSString stringWithFormat:@"0:%i",timeCount]];
    }
    
    // NSLog(@"TimerAufruf");
    if (timeCount == 0) {
        [minigamelayer calculateEvaluation];
        float inte =minigamelayer.powerDuration;
        NSLog(@"INTE IN MINIGAMESCENE : %1f",minigamelayer.powerDuration);
        *(_pointer) = inte;
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        [CCMenuItemFont setFontSize:40];
        CCMenuItemLabel *showScore = [CCMenuItemFont itemWithString:[NSString stringWithFormat:@"Congratulations for:\r%.0f %%",minigamelayer.evaluation*100] target:self selector:@selector(resumeMaingame:)];
        showScore.color = ccc3(0,255,0);
        CCMenu *menu = [CCMenu menuWithItems:showScore, nil];
        [menu setPosition:ccp( size.width/2, size.height/2)];
        [menu setVisible:YES];
        menu.tag = 12;
        

        
        [self addChild: menu z:5];
        //mach die Zeitanzeige raus
        [self removeChildByTag:9];
        
    }
    
    if (timeCount == -3) {
        [[CCDirector sharedDirector] popScene];
    }
    
}

- (void) startMinigame: (id) sender
{
    [[CCDirector sharedDirector] resume];
    CGSize size = [[CCDirector sharedDirector] winSize];
    //lösche die Beschreibung und das Feld zum Starten
    [self removeChildByTag:10];
    [self removeChildByTag:11];
    [[self getChildByTag:13] setPosition:ccp(size.width/2, 15)];
    
}

- (void) resumeMaingame: (id) sender
{
    
    [[CCDirector sharedDirector] popScene];
}


-(void)dealloc{
    [super dealloc];
    
}

@end