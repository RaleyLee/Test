//
//  BDManager.h
//  Kinds
//
//  Created by hibor on 2018/8/14.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BDManager : NSObject

+(BDManager *)shareManager;


+(NSMutableDictionary *)getLayerContent;

+(void)writeLayerContentWithDictionary:(NSMutableDictionary *)dictionary;

@end
