//
//  HUDHelper.h
//  WBAPP
//
//  Created by hibor on 2018/4/26.
//  Copyright © 2018年 hibor. All rights reserved.
//

#define HUDLOADINGMESSAGE @"加载中"
#define HUDFAILMESSAGE @"获取失败"
#define HUDNOTNETWORKINGMESSAGE @"暂无网络"

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface HUDHelper : NSObject

singleton_interface(HUDHelper)

-(void)stopLoadingHud;

-(void)showLoadingHudWithMessage:(NSString *)message withView:(UIView *)view;

-(void)showHudWithMessage:(NSString *)message withView:(UIView *)view;

@end
