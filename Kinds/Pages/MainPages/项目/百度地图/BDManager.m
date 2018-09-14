//
//  BDManager.m
//  Kinds
//
//  Created by hibor on 2018/8/14.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BDManager.h"

@implementation BDManager

static BDManager *_manager;

+(BDManager *)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] init];
    });
    return _manager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [super allocWithZone:zone];
    });
    return _manager;
}

+(NSMutableDictionary *)getLayerContent{
    //获取到项目的指定文件
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"BDLayerPlist" ofType:@"plist"];
    //获取目标文件的地址
    NSString *targetPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/BDLayerPlist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断目标文件是否存在
    BOOL isExist = [fileManager fileExistsAtPath:targetPath];
    if (!isExist) {
        [fileManager copyItemAtPath:sourcePath toPath:targetPath error:nil];
    }
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:targetPath];
    return dictionary;
}

+(void)writeLayerContentWithDictionary:(NSMutableDictionary *)dictionary{
    //获取到项目的指定文件
    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"BDLayerPlist" ofType:@"plist"];
    //获取目标文件的地址
    NSString *targetPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/BDLayerPlist.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断目标文件是否存在
    BOOL isExist = [fileManager fileExistsAtPath:targetPath];
    if (!isExist) {
        [fileManager copyItemAtPath:sourcePath toPath:targetPath error:nil];
    }
    [dictionary writeToFile:targetPath atomically:YES];
}

@end
