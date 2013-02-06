//
//  MinigameLayer.h
//  Fat Ninja
//
//  Created by Florian Weiß on 1/20/13.
//  Copyright (c) 2013 Florian Weiß. All rights reserved.
//

#import "CCLayer.h"
#import "GLES-Render.h"
#import "Constants.h"
#define PTM_RATIO ((UI_USER_INTERFACE_IDIOM() == \
UIUserInterfaceIdiomPad) ? 100.0 : 50.0)

@interface MinigameLayer : CCLayer{
    
    NSString *game;
    NSString *description;
    int timeCount;
    
    //Abstand zu unten
    float32 marginbot;
    //Abstand zu oben
    float32 margintop;
    //Abstand zu den Seiten
    float32 marginx;
    
    
    //X-Wert der linken Minispielbegrenzung
    float32 x_left;
    //X-Wert der rechten Minispielbegrenzung
    float32 x_right;
    //Y-Wert der unteren Minispielbegrenzung
    float32 y_bottom;
    //Y-Wert der oberen Minispielbegrenzung
    float32 y_top;
    //Breite vom Spielfeld
    float32 gameWidth;
    //Höhe vom Spielfeld
    float32 gameHeight;
    
    b2World *_world;
    b2Body *_groundBody;
    b2Fixture *_bottomFixture;
    
    //% der erreichten Punkte zwischen 1 und 0
    float evaluation;
     float powerDuration;
}

@property(nonatomic, strong) NSString *game;
@property(nonatomic, strong) NSString *description;
@property (readwrite) int timeCount;
@property (readwrite) float evaluation;
@property (readwrite) float powerDuration;

- (void)timer:(ccTime)dt;


@end

