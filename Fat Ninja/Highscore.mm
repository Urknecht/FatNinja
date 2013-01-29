//
//  Highscore.m
//  Fat Ninja
//
//  Created by Manuel Graf on 1/27/13.
//  Copyright (c) 2013 DEATHSPIKE ENTERTAINMENT. All rights reserved.
//

#import "Highscore.h"

@implementation Highscore

@synthesize localScores;

NSUserDefaults *defaults;
int localScoresLimit = 10;


-(id) init{
    [super init];
    if(self){
        [self updateScores];
    }
    
    return self;
}

- (void) insertLocalScore:(int)score{
    if(! score < (int)[localScores objectAtIndex:[localScores count]-1]);{
        [localScores addObject:[NSNumber numberWithInt:score]];
        NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
        [localScores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];
        
        if([localScores count] > localScoresLimit){
            NSLog(@"too many local scores! Keeping Top %d", localScoresLimit);
            [localScores removeObjectsInRange:NSMakeRange(localScoresLimit, [localScores count]-localScoresLimit)];
            NSLog(@"sortedArray=%@",localScores);
            
        }
        
        [defaults setObject:localScores forKey:@"localScores"];
        [defaults synchronize];
    }

}
- (void) resetLocalScore{
    localScores = [NSMutableArray array];
    [defaults setObject:localScores forKey:@"localScores"];
    [defaults synchronize];
}

- (bool) isLocalHighScore:(int)score{
    if(score > (int)[localScores objectAtIndex:0]){
        return true;
    }else{
        return false;
    }

}

-(void) printLocalScores{
    NSLog(@"Local Scores: %@",localScores);
}


-(void) updateScores{
    defaults = [NSUserDefaults standardUserDefaults];
    NSArray *localScoresImmutable = [defaults arrayForKey:@"localScores"];
    // NSUserDefaults geben IMMER Immutable Objects zurück, deswegen muss das array extra in ein Mutable koopiert werden.
    localScores = [NSMutableArray arrayWithArray:localScoresImmutable];


}

@end
