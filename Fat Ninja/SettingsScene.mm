//
//  SettingsScene.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/29/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "SettingsScene.h"
#import "HelloWorldLayer.h"

@implementation SettingsScene
@synthesize defaults;

bool showTuts;

-(id) init{
    self = [super init];
    if(self != nil){
        
        defaults = [NSUserDefaults standardUserDefaults];
        showTuts = [defaults boolForKey:@"showTutorial"];
        
        CCSprite *backgroundImage= [CCSprite spriteWithFile:@"paperBg.png"];
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [backgroundImage setPosition: CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
        CCLabelTTF *title = [CCLabelTTF labelWithString:@"Settings" fontName:@"Marker Felt" fontSize:24.0];
        title.color = ccc3(66,53,32);
        
        [title setPosition:ccp(winSize.width / 2, winSize.height-30)];
        [self addChild:title];
        
        CCMenuItemLabel *back = [CCMenuItemFont itemWithString:@"Back To Main Menu" target:self selector:@selector(backToMain)];
        back.position = ccp(winSize.width/2, 30);
        back.color = ccc3(66,53,32);
        
        
        CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
        backMenu.position = CGPointZero;
        [self addChild:backMenu z:1 tag:1];
        [self setupCheckBox];

  
    }
  
    return self;
    
}


-(void)checkBoxValue:(NSNumber *)value {
    BOOL boxChecked = [value boolValue];
    [defaults setBool:boxChecked forKey:@"showTutorial"];
    [defaults synchronize];
    
    bool test = [defaults boolForKey:@"showTutorial"];
    if (test) {
        NSLog(@"Show Tutorials");
    } else {
        NSLog(@"Hide Tutorials");
    }
    
}

-(void)setupCheckBox {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    myCheckBox = [BBCheckBox checkBoxWithDelegate:self callback:@selector(checkBoxValue:) uncheckedImage:@"checkbox_unchecked.png" checkedImage:@"checkbox_checked.png" isChecked:showTuts];
    
    myCheckBox.position=ccp(100,winSize.height-60);
    [self addChild:myCheckBox z:3];
    
    CCLabelTTF *showTutorialText = [CCLabelTTF labelWithString:@"Show tutorial at begin of each round" fontName:@"Marker Felt" fontSize:16];
    showTutorialText.position = ccp(250,winSize.height-60);
    showTutorialText.color = ccc3(66,53,32);
    [self addChild:showTutorialText];
    
}

-(void) backToMain{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}



@end
