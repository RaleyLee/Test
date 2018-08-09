//
//  HeaderColor.h
//  Market
//
//  Created by hibor on 2018/6/7.
//  Copyright © 2018年 hibor. All rights reserved.
//

#ifndef HeaderColor_h
#define HeaderColor_h

#define GlobalTopBarColor hbKColor(228,19,72,1.0)


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define IS_IOS9 ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONEX   (IS_IPHONE &&SCREEN_MAX_LENGTH == 812.0)


#define MAX_WIDTH SCREEN_WIDTH > SCREEN_HEIGHT ? SCREEN_WIDTH : SCREEN_HEIGHT

#define SafeAreaTopHeight (SCREEN_MAX_LENGTH == 812.0 ? 88 : 64)
#define SafeAreaBottomMargin (SCREEN_MAX_LENGTH == 812.0 ? 44 : 0)
//Tabbar高度
#define TabBarHeight (SCREEN_WIDTH > SCREEN_HEIGHT) ? 32 : 49


static CGFloat const kIPhoneX_BottomLayoutZeroConstant = 0;

static CGFloat const kIPhoneX_TopLayoutConstant = 44;
static CGFloat const kIPhone_TopLayoutConstant  = 20;
static CGFloat const kIPhone_Horizontal_TopLayoutConstant  = 20;


#endif /* HeaderColor_h */
