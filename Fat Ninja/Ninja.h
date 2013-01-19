//
//  Ninja.h
//  Fat Ninja
//
//  Created by Manuel Graf on 1/19/13.
//  Copyright 2013 Florian Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"



@interface Ninja : GameObject {
    CharacterStates characterState;
}

-(void)checkAndClampSpritePosition;
-(int)getWeaponDamage;

@property (readwrite) CharacterStates characterState;

@end
