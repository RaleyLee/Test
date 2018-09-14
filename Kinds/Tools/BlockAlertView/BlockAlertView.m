//
//  BlockAlertView.m
//  Kinds
//
//  Created by hibor on 2018/8/30.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BlockAlertView.h"

@interface BlockAlertView()<UIAlertViewDelegate>

@property(nonatomic,copy)void (^clickedBlock)(BlockAlertView *,BOOL,NSInteger);

@end

@implementation BlockAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message clickedBlock:(void (^)(BlockAlertView *, BOOL, NSInteger))clickedBlock cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...{
    //otherButtonTitles设置为nil 为了出现重复的按钮
    self = [self initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        _clickedBlock = clickedBlock;
        va_list _arguments;
        va_start(_arguments, otherButtonTitles);
        for (NSString *key = otherButtonTitles; key != nil; key = (__bridge NSString *)va_arg(_arguments,void *)) {
            [self addButtonWithTitle:key];
        }
        va_end(_arguments);
    }
    return self;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _clickedBlock(self,buttonIndex == self.cancelButtonIndex,buttonIndex);
}

@end
