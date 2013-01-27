/*
 * cocos2d for iPhone: http://bobueland.com/cocos2d
 *
 * Copyright (c) 2012 Bob Ueland
 */


#import "cocos2d.h"



@interface BBCheckBox : CCNode <CCTouchOneByOneDelegate>
{    
    // checkBox
    CCSprite *checkedBox;
    CCSprite *uncheckedBox;
    
    // delegate
    id delegate;
    SEL callback;

}
@property (nonatomic, assign) BOOL checked;

+checkBoxWithDelegate:(id)delegate callback:(SEL)method uncheckedImage:(NSString *)checkedImage checkedImage:(NSString *)checkedImage isChecked:(BOOL)isChecked;

-(id)initWithDelegate:(id)delegate callback:(SEL)method uncheckedImage:(NSString *)checkedImage checkedImage:(NSString *)checkedImage isChecked:(BOOL)isChecked;

@end