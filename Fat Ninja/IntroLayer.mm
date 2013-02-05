//
//  IntroLayer.m
//  Fat Ninja
//
//  Created by Florian Weiß on 12/10/12.
//  Copyright Florian Weiß 2012. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "HelloWorldLayer.h"
#import <MediaPlayer/MediaPlayer.h>



#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

MPMoviePlayerController *player;
CCSprite *background;


// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

//
-(id) init
{
	if( (self=[super init])) {
		
		// ask director for the window size
		
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
//        
//        NSString *Path = [[NSBundle mainBundle] resourcePath];
//        NSString *filePath = [Path stringByAppendingPathComponent:@"Intro.mov"];
//        NSURL *url = [NSURL fileURLWithPath:filePath isDirectory:NO];
//        player = [[MPMoviePlayerController alloc] initWithContentURL:url];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(moviePlayBackDidFinish:)
//                                                     name:MPMoviePlayerPlaybackDidFinishNotification
//                                                   object:player];
//        
//            //Use the new 3.2 style API.
//            player.controlStyle = MPMovieControlStyleNone;
//        player.fullscreen = true;
//        player.shouldAutoplay = NO;
//        CGSize winSize = [[CCDirector sharedDirector] winSize];
//        player.view.frame = CGRectMake(0, 0, winSize.width,winSize.height);
//        
//        [self removeChild:background];
//        [[[CCDirector sharedDirector] openGLView] addSubview:player.view];
//        
//        [self playMovie];
		// add the label as a child to this Layer
        
		[self addChild: background];
	}
	
	return self;
}

-(void)moviePlayBackDidFinish:(NSNotification*)notification {
    [self removeChild:background];

    [self stopMovie];
}
    -(void)playMovie {
        //We do not play the movie if it is already playing.
        MPMoviePlaybackState state = player.playbackState;
        if(state == MPMoviePlaybackStatePlaying) {
            NSLog(@"Movie is already playing.");
            return; }
        [player play];
    }

    -(void)stopMovie {
        //We do not stop the movie if it is already stopped.
        MPMoviePlaybackState state = player.playbackState;
        if(state == MPMoviePlaybackStateStopped) {
            NSLog(@"Movie is already stopped.");
            return; }
        //Since playback has finished we remove the observer.
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:player];

        [player.view removeFromSuperview];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
        player.fullscreen = false;
        [player release];


    }

-(void) onEnter
{
	[super onEnter];
      [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene] ]];
}
@end
