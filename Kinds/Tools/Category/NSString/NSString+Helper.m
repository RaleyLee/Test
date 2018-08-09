//
//  NSString+Helper.m
//  WBAPP
//
//  Created by hibor on 2018/3/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "NSString+Helper.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#import <CommonCrypto/CommonDigest.h>//MD5需要导入的框架



@implementation NSString (Helper)

- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:0];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (UIImage *) imageNamed:(NSString *)name
{
    name = [name stringByReplacingOccurrencesOfString:@".png" withString:@""];
    UIImage *image;
    if (IS_IPAD) {
        if (IS_RETINA) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@@4x.png", name]];
            if (image) {
                return image;
            }
        }
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", name]];
    }
    else {
        if (IS_RETINA) {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"%@@2x.png", name]];
            if (image) {
                return image;
            }
        }
        return [UIImage imageNamed:name];
    }
}

+ (NSString *)getNowTimeTimeStamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}



+ (NSString *)getTheDayOfTheWeekByDateString:(NSString *)dateString withWeekType:(WeekType)type{
    
    NSDateFormatter *inputFormatter=[[NSDateFormatter alloc]init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //如果传进来的是空值 自动取值当前时间
    if (!dateString || dateString.length == 0) {
        NSDate *dateNow = [NSDate date];
        dateString = [inputFormatter stringFromDate:dateNow];
    }
    
    NSDate *formatterDate=[inputFormatter dateFromString:dateString];
    NSDateFormatter *outputFormatter=[[NSDateFormatter alloc]init];
    [outputFormatter setDateFormat:@"EEEE-MMMM-d"];
    NSString *outputDateStr=[outputFormatter stringFromDate:formatterDate];
    NSArray *weekArray=[outputDateStr componentsSeparatedByString:@"-"];
    
    NSString *key = [weekArray objectAtIndex:0];
    NSArray *dictionArray = @[
                              @{@"english":@"SunDay",@"chinese_1":@"星期日",@"chinese_2":@"周日"},
                              @{@"english":@"Monday",@"chinese_1":@"星期一",@"chinese_2":@"周一"},
                              @{@"english":@"Tuesday",@"chinese_1":@"星期二",@"chinese_2":@"周二"},
                              @{@"english":@"Wednesday",@"chinese_1":@"星期三",@"chinese_2":@"周三"},
                              @{@"english":@"Thursday",@"chinese_1":@"星期四",@"chinese_2":@"周四"},
                              @{@"english":@"Friday",@"chinese_1":@"星期五",@"chinese_2":@"周五"},
                              @{@"english":@"Saturday",@"chinese_1":@"星期六",@"chinese_2":@"周六"}
                              ];
    for (NSDictionary *diction in dictionArray) {
        for (NSString *value in [diction allValues]) {
            if ([value isEqualToString:key]) {
                switch (type) {
                    case WeekTypeEnglish:
                        return diction[@"english"];
                        break;
                    case WeekTypeChinese_1:
                        return diction[@"chinese_1"];
                        break;
                    case WeekTypeChinese_2:
                        return diction[@"chinese_2"];
                        break;
                    default:
                        break;
                }
            }
        }
        
    }
    
    return key;
    
}

-(BOOL)isEmail{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
    
}

- (BOOL)isPhone
{
    //    NSString *regex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    //    NSString *regex = @"^((14[0-9])|(13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSString *regex = @"^1(3|4|5|8|7)[0-9]{1}\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}
@end
