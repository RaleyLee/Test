//
//  NSTimer+marketTimer.h
//  Hibor副本
//
//  Created by hibor on 2018/7/13.
//  Copyright © 2018年 Hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (marketTimer)

+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat;

@end
