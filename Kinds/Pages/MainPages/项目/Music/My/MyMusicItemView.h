//
//  MyMusicItemView.h
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMusicItemView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong) NSDictionary *diction;

@property(nonatomic,assign)NSInteger itemTag;
/**
 点击Item的block回调
 */
@property(nonatomic,strong)void (^clickItemBlock)(NSInteger tag);

@end
