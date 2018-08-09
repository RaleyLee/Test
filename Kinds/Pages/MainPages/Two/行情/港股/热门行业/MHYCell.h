//
//  MHYCell.h
//  WBAPP
//
//  Created by hibor on 2018/4/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MHYModel;

@interface MHYCell : UITableViewCell

@property(nonatomic,strong)MHYModel *model;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *zdfLabel;
@property(nonatomic,strong)UILabel *gnLabel;

@end
