//
//  SearchView.h
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^changBlock)(CGFloat height);
typedef void(^itemClickBlock) (NSString *title);

@interface SearchView : UIView

-(instancetype)initWithFrame:(CGRect)frame withBlock:(changBlock) block;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,copy)changBlock block;
@property(nonatomic,copy)itemClickBlock itemBlock;

@property(nonatomic,assign) CGSize size;

@end
