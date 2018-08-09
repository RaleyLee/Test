//
//  RequestTool.h
//  WBAPP
//
//  Created by hibor on 2018/3/29.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface RequestTool : NSObject

singleton_interface(RequestTool)


/**
 用于请求行情页面的数据

 @param path 请求数据的接口
 @param failuare 请求失败
 @param success 请求成功
 */
- (void)HBGETRequestDataWithPath:(NSString *)path isHaveNetWork:(void (^)(void))isWorking failuare:(void (^)(NSError *error))failuare success:(void (^)(id jsonData))success;


- (void)HBGETRequestDataWithPath:(NSString *)path WithParamert:(NSDictionary *)paramert isHaveNetWork:(void (^)(void))isWorking failuare:(void (^)(void))failuare success:(void (^)(id jsonData))success;
@end
