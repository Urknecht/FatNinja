/*
 * cocos2d tutorials: http://bobueland.com/cocos2d
 *
 * Copyright (c) 2012 Bob Ueland
*/

#import "BBCheckBox.h"

@implementation BBCheckBox
@synthesize checked;

#pragma mark -
#pragma mark Class methods

+(id)checkBoxWithDelegate:(id)delegate callback:(SEL)method uncheckedImage:(NSString *)uncheckedImage checkedImage:(NSString *)checkedImage isChecked:(BOOL)isChecked {
    
return [[[BBCheckBox alloc] initWithDelegate:delegate callback:method uncheckedImage:uncheckedImage checkedImage:checkedImage isChecked:isChecked] autorelease];
}

#pragma mark -
#pragma mark Convenience methods

-(BOOL)containsTouch:(UITouch *)touch {
    CGRect r=[uncheckedBox textureRect];
    CGPoint p=[uncheckedBox convertTouchToNodeSpace:touch];
    return CGRectContainsPoint(r, p );
}

-(void)update {
    uncheckedBox.visible = NO;
    checkedBox.visible = NO;
    
    if (checked) checkedBox.visible = YES;
    else uncheckedBox.visible = YES;
}

-(void)flipChecked {
    if (checked) checked=NO;
    else checked=YES;
    
    [self update];
}

#pragma mark -
#pragma mark Touches

- (void)onEnter
{
    [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    [super onEnter];
}

- (void)onExit
{
    [[CCTouchDispatcher sharedDispatcher] removeDelegate:self];
    [super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (![self containsTouch:touch]) return NO;
    
    [self flipChecked];
    
    [delegate performSelector:callback withObject:[NSNumber numberWithFloat:self.checked]];

    return YES;
}

#pragma mark -
#pragma mark Initialization

-(id)initWithDelegate:(id)theDelegate callback:(SEL)method uncheckedImage:(NSString *)uncheckedImage checkedImage:(NSString *)checkedImage isChecked:(BOOL)isChecked
{
	if( self=[super init] ) {
        
        uncheckedBox=[CCSprite spriteWithFile:uncheckedImage];
        [self addChild:uncheckedBox];
        
        checkedBox=[CCSprite spriteWithFile:checkedImage];
        [self addChild:checkedBox];
        
        delegate = theDelegate;
        callback= method;
        checked = isChecked;
        [self update];
	}
	return self;
}

@end
