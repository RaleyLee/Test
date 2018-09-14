//
//  NSTimer+marketTimer.m
//  Hibor副本
//
//  Created by hibor on 2018/7/13.
//  Copyright © 2018年 Hibor. All rights reserved.
//

#import "NSTimer+marketTimer.h"

@implementation NSTimer (marketTimer)

+(NSTimer *)eocScheduledTimerWithTimeInterval:(NSTimeInterval)timeInterval block:(void(^)()) block repeats:(BOOL)repeat{
    return  [self scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(startTimer:) userInfo:[block copy] repeats:repeat];
}
//定时器所执行的方法
+(void)startTimer:(NSTimer *)timer{
    void(^block)() = timer.userInfo;
    if (block) {
        block();
    }
    
}

@end
