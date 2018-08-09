//
//  PopChooseView.h
//  Kinds
//
//  Created by hibor on 2018/7/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PopAddStockView.h"

@class PopChooseCell,PopViewAddCell;
typedef void(^CancelButtonBlock)(void);
typedef void(^AddButtonBlock)(NSMutableArray * addArray);


typedef NS_ENUM(NSInteger,PopChooseViewStyle){
    PopChooseViewStyleDelete = 0,
    PopChooseViewStyleAdd
};


@interface PopChooseView : UIView

+(PopChooseView *)popChooseView;

@property(nonatomic,assign)BOOL showNoDataSign; //没有分组数据时 是否显示提示

@property(nonatomic,assign)BOOL showAddCount; //是否现在当前选中分组的数量 确认添加(number)

@property(nonatomic,assign)PopChooseViewStyle popChooseViewStyle;  //弹窗框的类型（添加、删除）

-(void)setListDataArray:(NSArray *)dataArray cancelClick:(CancelButtonBlock)cancel addClick:(AddButtonBlock)add;

-(void)show;
-(void)dismiss;

@property(nonatomic,copy)CancelButtonBlock cancelBlock;
@property(nonatomic,copy)AddButtonBlock addBlock;

@end


@protocol chooseItemButtonDelegate <NSObject>

-(void)chooseItemButtonDidSelected:(NSInteger)index;

@end

@interface PopChooseCell : UITableViewCell

@property(nonatomic,strong)UILabel *groupNameLabel;
@property(nonatomic,strong)UIButton *chooseButton;
@property(nonatomic,assign)NSInteger rowIndex;


@property(nonatomic,assign)id <chooseItemButtonDelegate> delegate;

@end


@protocol chooseAddStockGroupDelegate <NSObject>

-(void)addStockGroupAction;

@end

@interface PopViewAddCell : UITableViewCell

@property(nonatomic,assign)id <chooseAddStockGroupDelegate> delegate;

@end
