//
//  OCTableViewHeaderView.h
//  HangQingNew
//
//  Created by hibor on 2018/5/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCTableModel.h"


@interface OCTableViewHeaderView : UITableViewHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

/**
 是否隐藏More按钮
 */
@property(nonatomic,assign)BOOL hiddenMoreButton;

/**
 Section的背景颜色
 */
@property(nonatomic,strong)UIColor *contentBGColor;


@property(nonatomic,copy)OCTableModel *model;

@property(nonatomic,assign)BOOL hqDetail;

/**
 是否展示 **榜
 */
@property(nonatomic,assign)BOOL showDetailView;
/**
 当前**榜下标
 */
@property(nonatomic,assign)NSInteger selectedIndex;


/**
 Section下标
 */
@property(nonatomic,assign)NSInteger sectionTag;


/**
 点击More的回调 返回Section的下标
 */
@property(nonatomic,copy)void (^headerMoreClick)(NSInteger tag);


/**
 点击各种榜的回调方法 返回选择的榜的 请求链接/Title/DetailTitle
 */
@property(nonatomic,copy)void (^headerClickDetailBangButton)(NSDictionary *diction,NSInteger index);
/**
 点击整个Section的回调
 */
@property(nonatomic,copy)void (^headerSectionClick)(void);
@end
