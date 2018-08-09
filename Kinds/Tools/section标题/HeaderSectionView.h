//
//  HeaderSectionView.h
//  MarketAPP
//
//  Created by hibor on 2018/6/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SortButtonBlock) (BOOL hasNetWork);

@interface HeaderSectionView : UIView


/**
 点击排序标题的回调
 */
@property(nonatomic,copy)SortButtonBlock sortBlock;


/**
 初始化UITableViewHeaderView -- 标题

 @param frame 位置、大小
 @param titleArray 标题的数组
 @param canTouchIndex 可以进行排序的下标 【canTouchIndex == 888 没有排序】
 @param updown 升序、降序 【当canTouchIndex == 888 随意设置】
 @param block 排序回调
 @return return
 */
-(instancetype)initWithFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray canTouchIndex:(NSInteger)canTouchIndex isUPDown:(BOOL)updown withBlock:(SortButtonBlock)block;


/**
 升序、降序 【YES降序  NO升序】
 */
@property(nonatomic,assign)BOOL upDown;

/**
 TableViewHeaderView背景色
 */
@property(nonatomic,strong)UIColor *bgColor;


/**
 是否是【港股通-AH股】
 */
@property(nonatomic,assign)BOOL isAhStock;

@end
