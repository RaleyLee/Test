//
//  LLTableViewHeaderView.h
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLTableViewHeaderView : UITableViewHeaderFooterView

-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@property(nonatomic,strong)UILabel *kindLabel;
@property(nonatomic,strong)UILabel *countLabel;

@property(nonatomic,strong)UIColor *bgColor;

@end
