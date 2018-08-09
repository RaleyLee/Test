//
//  VRefreshBtn.h
//  PopupViewExample
//
//  Created by Vols on 2017/6/23.
//  Copyright © 2017年 vols. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger ,RefreshStockStatus){
    RefreshStockHomeStatus = 0,
    RefreshStockPageStatus
};

@interface VRefreshBtn : UIView
/**
 创建分类方法 
 */
+(instancetype)refreshButton;
/**
 开始刷新状态
 */
-(void)refreshStatusStart;
/**
 结束刷新状态
 */
-(void)refreshStatusEnd;

@property(nonatomic,strong)UIImage *buttonImage;

@property (nonatomic, copy) void(^clickHandler)(void);

@end
