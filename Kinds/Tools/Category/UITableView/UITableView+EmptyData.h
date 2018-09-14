//
//  UITableView+EmptyData.h
//  HangQingNew
//
//  Created by hibor on 2018/5/28.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,DisplayType){
    //没网
    DisplayTypeNotNetWork = 0,
    //没数据
    DisplayTypeNoData,
    //获取数据异常
    DisplayTypeGetDataFailure,
};

typedef void (^ReloadButtonBlock)(void);

@interface UITableView (EmptyData)


@property(nonatomic,copy)ReloadButtonBlock myBlock;

@property(nonatomic,strong) UIView *signView;
@property(nonatomic,strong) UIImageView *messageImage;
@property(nonatomic,strong) UILabel *messageLabel;
@property(nonatomic,strong) UIImageView *singerImageView;

- (void)tableViewDisplayWithMessage:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount;



/**
 tableView占位

 @param image 占位图
 @param message 占位内容
 @param type 占位类型
 @param rowCount 根据rowCount判断时候显示占位图
 @param block 点击重试按钮
 */
-(void)tableViewDisplayWithImage:(UIImage *)image withMessage:(NSString *)message withType:(DisplayType)type ifNecessaryForRowCount:(NSUInteger)rowCount reloadButtonBlock:(ReloadButtonBlock)block;



/**
 tableView占位
 
 @param image 占位图
 @param message 占位内容
 @param type 占位类型
 @param rowCount 根据rowCount判断时候显示占位图
 */
-(void)tableViewDisplayWithImage:(UIImage *)image withMessage:(NSString *)message withType:(DisplayType)type ifNecessaryForRowCount:(NSUInteger)rowCount;


/**
 tableview 歌手占位

 @param image 歌手图片
 */
-(void)tableViewDisplaySingerImage:(UIImage *)image;

@end
