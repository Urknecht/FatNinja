//
//  Sushi.m
//  Fat Ninja
//
//  Created by Linda Mai Bui on 1/12/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "Sushi.h"

@implementation Sushi

-(id) init{
    if ((self = [super init])) {
        self= [Sushi spriteWithFile:@"sushi.png"];
        isEatable=true;
        isShootable=true;
        //lol
    }
    return self;
}

-(void) changeState:(CharacterStates)newState{
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case StateDie:
            //sterbe animation  am ende muss gegner gelöscht werden
            break;
            
        default:
            break;
    }
    if (action != nil) {
        [self runAction:action];
    }
}

@end
