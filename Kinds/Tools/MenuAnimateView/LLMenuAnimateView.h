//
//  LLMenuAnimateView.h
//  Kinds
//
//  Created by hibor on 2018/6/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LLMenuAnimatedViewDelegate <NSObject>

-(void)menuAnimatedViewClick:(NSInteger)index;

@end

@interface LLMenuAnimateView : UIView

@property(nonatomic,assign)NSInteger columnCount; //多少列/每行多少个
@property(nonatomic,strong)NSArray *titleArray;  //标题数组
@property(nonatomic,strong)NSArray *imageArray;  //图片数组

@property(nonatomic,weak)id <LLMenuAnimatedViewDelegate> delegate;

-(void)menuShow;
-(void)menuDiss;

@end
