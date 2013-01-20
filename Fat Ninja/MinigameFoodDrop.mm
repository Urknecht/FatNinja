//
//  MinigameFoodDrop.m
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "MinigameFoodDrop.h"

@implementation MinigameFoodDrop

NSMutableArray *dropStuff;
NSString *dropFood = @"1";
NSString *dropBomb = @"0";


- (id)init
{
    self = [super init];
    if (self) {
        
        game = @"Omnom-Jutsu";
        description = @"Alles essen!";
        
        //Die Teile für richtiges Essen
        for (int i = 0; i < 15; i++) {
            [dropStuff addObject:dropFood];
        }
        //Die Teile für Bomben
        for (int j = 0; j < 3; j++) {
            [dropStuff addObject:dropBomb];
        }
        //Hier wird das Array gemischt
        for (int i = 0; i < dropStuff.count; i++) {
            int randomIndex = arc4random() % dropStuff.count;
            [dropStuff exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
        }
        
    }
    return self;
}

@end

