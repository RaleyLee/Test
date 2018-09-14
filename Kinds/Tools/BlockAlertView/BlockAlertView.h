//
//  BlockAlertView.h
//  Kinds
//
//  Created by hibor on 2018/8/30.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : UIAlertView

/**
 封装UIAlertView
 
 @param title 标题
 @param message 内容
 @param clickedBlock 按钮点击回调
 @param cancelButtonTitle 取消按钮的标题
 @param otherButtonTitles 其他按钮的标题
 @return alert
 */
-(id)initWithTitle:(NSString *)title message:(NSString *)message clickedBlock:(void (^)(BlockAlertView *alertView, BOOL cancelled, NSInteger buttonIndex))clickedBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

@end
