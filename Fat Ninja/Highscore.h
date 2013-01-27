//
//  Highscore.h
//  Fat Ninja
//
//  Created by Manuel Graf on 1/27/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Highscore : NSObject

- (void) insertLocalScore:(int)score;
- (void) resetLocalScore;

@property(readonly) NSMutableArray *localScores;

@end
