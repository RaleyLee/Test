//
//  FDetailViewController.h
//  WBAPP
//
//  Created by hibor on 2018/4/26.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BaseViewController.h"
#import "OCTableModel.h"
#import "OCTableViewHeaderView.h"

@interface FDetailViewController : BaseViewController

@property(nonatomic,copy)NSString *requestURLString;
@property(nonatomic,strong)NSArray *keysArray;
@property(nonatomic,strong)NSArray *titlesArray;
@property(nonatomic,copy)NSString *titleName;

@end
