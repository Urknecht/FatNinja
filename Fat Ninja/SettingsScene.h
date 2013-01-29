//
//  SettingsScene.h
//  Fat Ninja
//
//  Created by Manuel Graf on 1/29/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCScene.h"

#import "BBCheckBox.h"



@interface SettingsScene : CCScene{
    BBCheckBox *myCheckBox;
    NSUserDefaults *defaults;
}

@property(readwrite) NSUserDefaults* defaults;
-(id)init;

@end
