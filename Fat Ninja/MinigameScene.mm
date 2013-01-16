//
//  MinigameScene.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/16/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameScene.h"
#import "cocos2d.h"

@implementation MinigameScene

int _gametype;

- (id) initWith:(int)gametype{
    self = [super init];
    if (self != nil) {
        
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"gameOverBackground.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
        
        // Default font size will be 30 points.
        [CCMenuItemFont setFontSize:30];
        
        _gametype = gametype;
        
        switch (_gametype) {
            case 0:
                game = @"OmNom-Jutsu";
                description = @"Hier kommt die Description rein";
                break;
                
            case 1:
                game = @"Blub-Jutsu";
                description = @"Hier kommt die Description rein";
                break;
                
            case 2:
                game = @"Bla-Jutsu";
                description = @"Hier kommt die Description rein";
                break;
                
            default:
                break;
        }
        
        
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:game fontName:@"Marker Felt" fontSize:40 ];
        label.color = ccc3(255,0,0);
        [self addChild:label z:2];
        label.position = ccp( size.width/2, size.height-30);
        
        CCLabelTTF *labelDescription = [CCLabelTTF labelWithString:description fontName:@"Marker Felt" fontSize:20];
        [self addChild:labelDescription z:2];
        labelDescription.position = ccp( size.width/2, size.height-65);
        
        //Distanz
        
        
        
        
    }
    return self;
}


@end

