//
//  LRCCell.m
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LRCCell.h"

@interface LRCCell ()



@end

@implementation LRCCell

+(instancetype)createLRCCell:(UITableView *)tableView{
    static NSString *lrcCell = @"lrcCell";
    LRCCell *cell = [tableView dequeueReusableCellWithIdentifier:lrcCell];
    if (!cell) {
        cell = [[LRCCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:lrcCell];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentLabel = [UILabel new];
        self.contentLabel.backgroundColor = [UIColor clearColor];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = FONT_9_REGULAR(15);
        self.contentLabel.textAlignment = NSTextAlignmentCenter;
        self.contentLabel.numberOfLines = 0;
        self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.contentLabel];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)setContent:(NSString *)content{
    _content = content;
    self.contentLabel.text = content;
    [self.contentLabel sizeToFit];
    
    self.rowHeight = CGRectGetHeight(self.contentLabel.frame);
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
  
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



@end
