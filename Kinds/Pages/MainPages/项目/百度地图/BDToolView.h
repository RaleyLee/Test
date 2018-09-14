//
//  BDToolView.h
//  Kinds
//
//  Created by hibor on 2018/8/13.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ItemClickBlock)(NSInteger index,BOOL state);

@interface BDToolView : UIView


-(instancetype)initWithDataSource:(NSArray *)dataArray;

@property(nonatomic,copy)ItemClickBlock clickBlock;

@end
