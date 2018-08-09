//
//  HBGGTCell2.h
//  WBAPP
//
//  Created by hibor on 2018/5/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HBGGTModel2;

@interface HBGGTCell2 : UITableViewCell

@property(nonatomic,strong)HBGGTModel2 *model2;
@property(nonatomic,strong)HBHQModel *hqModel;

@property(nonatomic,strong)UIImageView *stockImageView;
@property(nonatomic,assign)BOOL isShowFlag;

@property(nonatomic,strong)LLabel *nameLabel;
@property(nonatomic,strong)LLabel *codeLabel;
@property(nonatomic,strong)LLabel *zxjLabel;
@property(nonatomic,strong)LLabel *zdfLabel;


@property(nonatomic,strong)UIImageView *delayImageView; //延
@property(nonatomic,strong)LLabel *delayLabel;

@end
