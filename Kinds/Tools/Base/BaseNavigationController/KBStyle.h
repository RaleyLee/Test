//
//  KBStyle.h
//  Kinds
//
//  Created by hibor on 2018/6/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#ifndef KBStyle_h
#define KBStyle_h

struct KBStyle {
    __unsafe_unretained UIColor *KBbarTintColor;
    __unsafe_unretained UIColor *KBtintColor;
    __unsafe_unretained UIFont *KBtitleFont;
};
typedef struct KBStyle KBStyle;

CG_INLINE KBStyle
mKBStyle(__unsafe_unretained UIColor *KBbarTintColor,__unsafe_unretained UIColor *KBtintColor,__unsafe_unretained UIFont *KBtitleFont)
{
    KBStyle kbstyle;
    kbstyle.KBbarTintColor = KBbarTintColor;
    kbstyle.KBtintColor = KBtintColor;
    kbstyle.KBtitleFont = KBtitleFont;
    return kbstyle;
}


#endif /* KBStyle_h */
