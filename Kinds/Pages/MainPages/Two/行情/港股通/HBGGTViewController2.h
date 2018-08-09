//
//  HBGGTViewController2.h
//  WBAPP
//
//  Created by hibor on 2018/5/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"
@class HBGGTModel2,HBGGTModel;
#import "HBGGTCell2.h"
#import "HBStockInfoViewController.h"

#import "HBGGTCell.h"


@interface HBGGTViewController2 : BaseViewController

@property(nonatomic,copy)NSString *urlString;
@property(nonatomic,copy)NSString *title1;

@property(nonatomic,assign)BOOL IS_AHStock; //是不是AH股

@property(nonatomic,assign)BOOL isShowFlag;

@end
