//
//  MessageCell.h
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageFrame.h"
#import "MessageModel.h"

@interface MessageCell : UITableViewCell

@property(nonatomic,strong)MessageFrame *messageFrame;

@property(nonatomic,copy)NSString *headName;

//封装一个创建自定义cell的方法
+(instancetype)messageCellWithTableView:(UITableView *)tableView;

@end
