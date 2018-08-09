//
//  HUDHelper.m
//  WBAPP
//
//  Created by hibor on 2018/4/26.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HUDHelper.h"

@interface HUDHelper(){
    MBProgressHUD *hud;
}
@end

@implementation HUDHelper

singleton_implementation(HUDHelper)

-(void)stopLoadingHud{
    if (hud) {
        (void)([hud removeFromSuperview]),hud = nil;
    }
}
-(void)showLoadingHudWithMessage:(NSString *)message withView:(UIView *)view{
    
    if (!hud) {
        UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
        hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        hud.animationType = MBProgressHUDAnimationFade;
    }
    hud.mode = MBProgressHUDModeIndeterminate;
    if (!message) {
        hud.label.text = HUDLOADINGMESSAGE;
    }else{
        hud.label.text = message;
    }
    [hud hideAnimated:YES afterDelay:TIMEOUT];
}
-(void)showHudWithMessage:(NSString *)message withView:(UIView *)view{
    if (!hud) {
        UIView *inView = view ? view : [UIApplication sharedApplication].keyWindow;
        hud = [MBProgressHUD showHUDAddedTo:inView animated:YES];
        hud.removeFromSuperViewOnHide = YES;
        hud.animationType = MBProgressHUDAnimationFade;
        hud.mode = MBProgressHUDModeCustomView;
        hud.label.text = message;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self->hud removeFromSuperview];
            self->hud = nil;
        });
    }
}

@end
