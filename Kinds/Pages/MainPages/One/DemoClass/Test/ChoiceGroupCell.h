//
//  ChoiceGroupCell.h
//  易投标-官方正版
//
//  Created by 秦景洋 on 2018/8/14.
//  Copyright © 2018年 秦景洋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoiceGroupModel.h"

@interface ChoiceGroupCell : UICollectionViewCell
@property(nonatomic,strong)UIButton * clickButton;
@property(nonatomic,strong)ChoiceGroupModel * model;
@end
