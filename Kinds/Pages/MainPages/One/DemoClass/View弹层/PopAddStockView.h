//
//  PopAddStockView.h
//  Kinds
//
//  Created by hibor on 2018/7/25.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PopAddViewStyle){
    PopAddViewStyleReName = 0,
    PopAddViewStyleAdd
};

@interface PopAddStockView : UIView

+(PopAddStockView *)popAddStockView;

@property (copy) void (^confirmClickBlock)(NSString *groupName);

@property(nonatomic,assign)PopAddViewStyle popStyle;

-(void)show;

-(void)dismiss;

@end
