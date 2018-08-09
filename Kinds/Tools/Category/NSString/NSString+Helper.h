//
//  NSString+Helper.h
//  WBAPP
//
//  Created by hibor on 2018/3/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    WeekTypeEnglish    = 0,
    WeekTypeChinese_1,
    WeekTypeChinese_2,
} ;
typedef NSUInteger WeekType;

@interface NSString (Helper)
//eg.
// NSString *base64Str = [codeString base64EncodedString];
//转换为Base64编码
- (NSString *)base64EncodedString;

//eg.
//NSString *decodeStr = [base64Str base64DecodedString];
//将Base64编码还原
- (NSString *)base64DecodedString;


//转成MD5
- (NSString *)md5;

//在iPhone中使用bg.png，在iPhone和iPad中使用bg@2x，iPad中使用bg@4x
+ (UIImage *) imageNamed:(NSString *)name;


/**
 获取当前时间戳

 @return 返回获取当前时间戳
 */
+ (NSString *)getNowTimeTimeStamp;

//获取周几
+ (NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString withWeekType:(WeekType)type;

-(BOOL)isEmail;

- (BOOL)isPhone;
@end
