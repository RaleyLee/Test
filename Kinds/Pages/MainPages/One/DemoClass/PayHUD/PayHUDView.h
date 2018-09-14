//
//  PayHUDView.h
//  Kinds
//
//  Created by hibor on 2018/8/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PayHUDStyle){
    PayHUDStyleLoading = 0,  //开始加载
    PayHUDStyleSuccess,      //支付成功
    PayHUDStyleFailure,      //支付失败
    PayHUDStyleWarning,      //支付警告
};


@interface PayHUDView : UIView<CAAnimationDelegate>


@property(nonatomic,assign)PayHUDStyle payStyle;

-(void)startPayAnimation;

-(void)endPayAnimation;

-(void)startFinishAnimation:(PayHUDStyle)style;


+(PayHUDView *)showIn:(UIView *)view withAnimation:(PayHUDStyle)style;

+(PayHUDView *)hideIn:(UIView *)view;

@end
