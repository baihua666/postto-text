//
//  TextEngineWrap.m
//  SwiftContainer
//
//  Created by yyf on 2017/3/1.
//  Copyright © 2017年 leo. All rights reserved.
//


#import "TextEngineWrap.h"
#include "PosttoText.h"

@implementation TextEngineWrap

+ (void) initialize: (NSString*) fontDir effect: (NSString*) effectDir {
    pttInitialize([fontDir UTF8String],
                  [effectDir UTF8String]);

    NSLog(@"pttInitialize", NULL);
}

+ (void) loadAllEffect {
    pttLoadAllEffect();
}

+ (int) animElapseTime:(pttAnimator) anim :(unsigned int) ms {
    return pttAnimElapseTime(anim, ms);
}

+ (int) createAnim: (pttAnimator*) lpAnim {
    return pttCreateAnim(lpAnim);
}

+ (int) addSectionToAnim: (pttAnimator) anim :(pttSection) section {
    return pttAddSectionToAnim(anim, section);
}

+ (void) releaseSection: (pttSection) section {
    pttReleaseSection(section);
}

+ (void) releaseLine: (pttLine) line {
    pttReleaseLine(line);
}

+ (int) createSection:(pttSection*) lpSection :(CGSize*) lpFrame fromString:(NSAttributedString*) attrstr :(CGRect*) lpRegion :(const char *) szEffectName :(const pttEffectConfig *) lpConfig {
    return pttCreateSectionFromString(lpSection, lpFrame, attrstr, lpRegion, 0, szEffectName, lpConfig);
}

+ (int) addLine:(pttSection) section :(pttLine*) lpLine fromString:(NSAttributedString*) attrstr :(const CGRect*) lpRegion {
    return pttAddLineFromString(section, lpLine, attrstr, lpRegion);
}

+ (int) renderAnim: (pttAnimator) anim {
    return pttRenderAnim(anim);
}

+ (void) resetAnim: (pttAnimator) anim {
    pttResetAnim(anim);
}

@end
