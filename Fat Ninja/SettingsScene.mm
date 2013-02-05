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
bool showIntro;
bool muteSfx;
bool muteMusic;

-(id) init{
    self = [super init];
    if(self != nil){
        
        defaults = [NSUserDefaults standardUserDefaults];
        showTuts = [defaults boolForKey:@"showTutorial"];
        showIntro = [defaults boolForKey:@"showIntro"];
        muteSfx = [defaults boolForKey:@"muteSfx"];
        muteMusic = [defaults boolForKey:@"showTutorial"];
        
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
        [self setupCheckBoxes];

  
    }
  
    return self;
    
}


-(void)checkBoxTutorialValue:(NSNumber *)value {
    BOOL boxChecked = [value boolValue];
    [defaults setBool:boxChecked forKey:@"showTutorial"];
    [defaults synchronize];
    
    bool test = [defaults boolForKey:@"showTutorial"];
    if (test) {
        NSLog(@"Tutorials will be shown.");
    } else {
        NSLog(@"Tutorials will be hidden.");
    }
    
}

-(void)checkBoxIntroValue:(NSNumber *)value {
    BOOL boxChecked = [value boolValue];
    [defaults setBool:boxChecked forKey:@"showIntro"];
    [defaults synchronize];
    
    bool test = [defaults boolForKey:@"showIntro"];
    if (test) {
        NSLog(@"Intro will be shown.");
    } else {
        NSLog(@"Intro will be hidden.");
    }
    
}

-(void)checkBoxMuteSfxValue:(NSNumber *)value {
    BOOL boxChecked = [value boolValue];
    [defaults setBool:boxChecked forKey:@"muteSound"];
    [defaults synchronize];
    
    bool test = [defaults boolForKey:@"muteSound"];
    if (test) {
        NSLog(@"Sound Effects are muted.");
    } else {
        NSLog(@"Sound Effects are enabled.");
    }
    
}

-(void)checkBoxMuteMusicValue:(NSNumber *)value {
    BOOL boxChecked = [value boolValue];
    [defaults setBool:boxChecked forKey:@"muteMusic"];
    [defaults synchronize];
    
    bool test = [defaults boolForKey:@"muteMusic"];
    if (test) {
        NSLog(@"Music is muted.");
    } else {
        NSLog(@"Music is enabled.");
    }
}


-(void)setupCheckBoxes {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // TUTORIAL
    tutCheckBox = [BBCheckBox checkBoxWithDelegate:self callback:@selector(checkBoxTutorialValue:) uncheckedImage:@"checkbox_unchecked.png" checkedImage:@"checkbox_checked.png" isChecked:showTuts];
    tutCheckBox.position=ccp(100,winSize.height-60);
    [self addChild:tutCheckBox z:3];
    
    
    CCLabelTTF *showTutorialText = [CCLabelTTF labelWithString:@"Show tutorial at begin of each round" fontName:@"Marker Felt" fontSize:16];
    showTutorialText.position = ccp(250,winSize.height-60);
    showTutorialText.color = ccc3(66,53,32);
    [self addChild:showTutorialText];

    // SHOW INTRO
    introCheckBox = [BBCheckBox checkBoxWithDelegate:self callback:@selector(checkBoxIntroValue:) uncheckedImage:@"checkbox_unchecked.png" checkedImage:@"checkbox_checked.png" isChecked:showIntro];
    introCheckBox.position=ccp(100,winSize.height-150);
    [self addChild:introCheckBox z:3];
    
    
    CCLabelTTF *showIntroText = [CCLabelTTF labelWithString:@"Show Intro at App start" fontName:@"Marker Felt" fontSize:16];
    showIntroText.position = ccp(250,winSize.height-150);
    showIntroText.color = ccc3(66,53,32);
    [self addChild:showIntroText];

    // MUTE SFX
    muteSfxCheckBox = [BBCheckBox checkBoxWithDelegate:self callback:@selector(checkBoxMuteSfxValue:) uncheckedImage:@"checkbox_unchecked.png" checkedImage:@"checkbox_checked.png" isChecked:muteSfx];
    muteSfxCheckBox.position=ccp(100,winSize.height-90);
    [self addChild: muteSfxCheckBox z:3];
    
    
    CCLabelTTF *muteSfxText = [CCLabelTTF labelWithString:@"Mute sound effects" fontName:@"Marker Felt" fontSize:16];
    muteSfxText.position = ccp(250,winSize.height-90);
    muteSfxText.color = ccc3(66,53,32);
    [self addChild:muteSfxText];

    // MUTE MUSIC
    muteMusicCheckbox = [BBCheckBox checkBoxWithDelegate:self callback:@selector(checkBoxMuteMusicValue:) uncheckedImage:@"checkbox_unchecked.png" checkedImage:@"checkbox_checked.png" isChecked:muteMusic];
    muteMusicCheckbox.position=ccp(100,winSize.height-120);
    [self addChild: muteMusicCheckbox z:3];
    
    
    CCLabelTTF *muteMusicText = [CCLabelTTF labelWithString:@"Background music muted" fontName:@"Marker Felt" fontSize:16];
    muteMusicText.position = ccp(250,winSize.height-120);
    muteMusicText.color = ccc3(66,53,32);
    [self addChild:muteMusicText];
    
}

-(void) backToMain{
    [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer node]];
}



@end
