//
//  UIColor+Helper.h
//  WBAPP
//
//  Created by hibor on 2018/3/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)

//将十六进制的转换成UIColor对象
+ (UIColor *)colorFromHexRGB:(NSString *)inColorString;


@end
