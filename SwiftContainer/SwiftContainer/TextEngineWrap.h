//
//  TextEngineWrap.h
//  SwiftContainer
//
//  Created by yyf on 2017/3/1.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include "PosttoText.h"
#import <CoreText/CoreText.h>

@interface TextEngineWrap : NSObject


/**
 初始化字效引擎

 @param fontDir 字体文件目录
 @param effectDir 字效文件目录
 */
+ (void) initialize: (NSString*) fontDir effect: (NSString*) effectDir;


/**
 加载特效
 */
+ (void) loadAllEffect;

/**
 时间偏移

 @param anim anim
 @param ms ms
 @return return value description
 */
+ (int) animElapseTime:(pttAnimator) anim :(unsigned int) ms;


+ (int) createAnim: (pttAnimator*) lpAnim;

+ (int) addSectionToAnim: (pttAnimator) anim :(pttSection) section;

+ (void) releaseSection: (pttSection) section;

+ (void) releaseLine: (pttLine) line;



+ (int) createSection:(pttSection*) lpSection :(CGSize*) lpFrame fromString:(NSAttributedString*) attrstr :(CGRect*) lpRegion :(const char *) szEffectName :(const pttEffectConfig *) lpConfig;


+ (int) addLine:(pttSection) section :(pttLine*) lpLine fromString:(NSAttributedString*) attrstr :(const CGRect*) lpRegion;

+ (int) renderAnim: (pttAnimator) anim;

+ (void) resetAnim: (pttAnimator) anim;

@end
