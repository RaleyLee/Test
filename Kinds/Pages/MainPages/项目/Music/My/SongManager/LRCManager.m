//
//  LRCManager.m
//  Kinds
//
//  Created by hibor on 2018/9/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LRCManager.h"
#import "NSDateFormatter+shared.h"
#import "LRCModel.h"

@implementation LRCManager

static LRCManager *_lrcInstance;

+(LRCManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lrcInstance = [[self alloc] init];
    });
    return _lrcInstance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lrcInstance = [super allocWithZone:zone];
    });
    return _lrcInstance;
}

-(NSMutableArray *)getCurrentSongLrcList:(NSString *)fileName{
    if (!fileName || fileName.length == 0) {
        return nil;
    }
    //根据文件名称获取文件地址
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
    //根据文件地址获取转化后的总体字符串
    NSString *lrcString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //将歌词总体字符串按行拆分开，每句都最为一个数组元素存放到数组中
    NSArray *lineStrings = [lrcString componentsSeparatedByString:@"\n"];
    //设置歌词时间的正则表达式
    NSString *lrcPattern = @"\\[[0-9]{2}:[0-9]{2}.[0-9]{2}\\]";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:lrcPattern options:0 error:nil];
    //创建可变数组存放歌词模型
    NSMutableArray *lrcArray = [NSMutableArray array];
    //遍历歌词字符串数组
    for (NSString *lineStr in lineStrings) {
        NSArray *results = [reg matchesInString:lineStr options:0 range:NSMakeRange(0, lineStr.length)];
        //获取歌词内容
        NSTextCheckingResult *lastResult = [results lastObject];
        NSString *content = [lineStr substringFromIndex:lastResult.range.location + lastResult.range.length];
        //每一个结果的range
        for (NSTextCheckingResult *result in results) {
            NSString *time = [lineStr substringWithRange:result.range];
            
            NSDateFormatter *formatter = [NSDateFormatter sharedDateFormatter];
            formatter.dateFormat = @"[mm:ss.SS]";
            
            NSDate *timeDate = [formatter dateFromString:time];
            NSDate *initDate = [formatter dateFromString:@"[00:00.00]"];
            
            //创建模型
            LRCModel *lrcModel = [[LRCModel alloc] init];
            lrcModel.content = content;   // 歌词内容
            lrcModel.time = time;//[timeDate timeIntervalSinceDate:initDate];  // 歌词开始时间
            //将歌词对象添加到模型数组汇总
            [lrcArray addObject:lrcModel];
        }
    }
    
    // 按照时间正序排序
    NSSortDescriptor *sortDes = [NSSortDescriptor sortDescriptorWithKey:@"time" ascending:YES];
    [lrcArray sortUsingDescriptors:@[sortDes]];
    
    return lrcArray;
}


@end
