//
//  MessageCell.m
//  Kinds
//
//  Created by hibor on 2018/8/8.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell()

@property(nonatomic,weak)UILabel *lblTime;
@property(nonatomic,weak)UIImageView *imgViewIcon;
@property(nonatomic,weak)UIButton *btnText;

@end

@implementation MessageCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建子控件
        
        //显示时间的label
        UILabel *lblTime = [[UILabel alloc] init];
        lblTime.font = [UIFont systemFontOfSize:12];
        lblTime.textAlignment = NSTextAlignmentCenter;
        lblTime.textColor = [UIColor whiteColor];
        lblTime.backgroundColor = RGB_color(206);
        lblTime.layer.cornerRadius = 3;
        lblTime.layer.masksToBounds = YES;
        [self.contentView addSubview:lblTime];
//        [lblTime mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView);
//            make.top.mas_equalTo(5);
//            make.height.mas_equalTo(20);
//        }];
        self.lblTime = lblTime;
        
        //显示头像的UIImageView
        UIImageView *imgViewIcon = [[UIImageView alloc] init];
        imgViewIcon.backgroundColor = RGB_random;
        [self.contentView addSubview:imgViewIcon];
        self.imgViewIcon = imgViewIcon;
        
        //显示正文的UIButton
        UIButton *btnText = [UIButton buttonWithType:UIButtonTypeCustom];
        btnText.titleLabel.font = FONT_9_REGULAR(15);//[UIFont systemFontOfSize:15];
        [btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnText.titleLabel.numberOfLines = 0;
        btnText.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;

        [self.contentView addSubview:btnText];
        self.btnText = btnText;
    }
    return self;
}


-(void)setMessageFrame:(MessageFrame *)messageFrame{
    _messageFrame = messageFrame;
    
    //获取数据模型
    MessageModel *message = messageFrame.message;
    
    //分别设置么个子控件的数据和frame
    
    //设置时间label的数据和frame
    self.lblTime.text = message.time;
    self.lblTime.frame = messageFrame.timeFrame;
    self.lblTime.hidden = message.hideTime;
    
    
    //设置头像  根据消息类型判断使用的头像
    NSString *iconImg = message.type == CZMessageTypeMe ? @"me" : @"other";
    self.imgViewIcon.image = [UIImage imageNamed:iconImg];
    self.imgViewIcon.frame = messageFrame.iconFrame;
    
    //设置消息正文
    [self.btnText setTitle:message.text forState:UIControlStateNormal];
    [self.btnText setFrame:messageFrame.textFrame];
    
    //设置正文的背景图
    NSString *imgNor,*imgHighLighted;
    if (message.type == CZMessageTypeMe) {
        //自己发的消息
        imgNor = @"wechatback2";//@"rightBG";
        imgHighLighted = @"wechatback2cover";
        [self.btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置按钮内边距
        self.btnText.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 15);
    }else{
        imgNor = @"wechatback1";//@"leftBG";
        imgHighLighted = @"wechatback1cover";
        [self.btnText setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置按钮内边距
        self.btnText.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 10);
    }
    UIImage *normal = [UIImage imageNamed:imgNor];
    //用平铺的方式拉伸图片
    normal = [normal stretchableImageWithLeftCapWidth:normal.size.width*0.5 topCapHeight:normal.size.height*0.8];
    
    [self.btnText setBackgroundImage:normal forState:UIControlStateNormal];
    UIImage *hight = [UIImage imageNamed:imgHighLighted];
    //用平铺的方式拉伸图片
    hight = [hight stretchableImageWithLeftCapWidth:hight.size.width*0.5 topCapHeight:hight.size.height*0.8];
    
    [self.btnText setBackgroundImage:hight forState:UIControlStateHighlighted];
}

-(void)setHeadName:(NSString *)headName{
    
    //获取数据模型
    MessageModel *message = _messageFrame.message;

    self.imgViewIcon.image = message.type == CZMessageTypeMe ? [UIImage imageNamed:@"g.gif"]: [UIImage imageNamed:headName];
}
#pragma mark - 创建自定义cell的类方法

+(instancetype)messageCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"message_cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
