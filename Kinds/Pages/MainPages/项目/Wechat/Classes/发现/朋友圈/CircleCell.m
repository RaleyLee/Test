//
//  CircleCell.m
//  Kinds
//
//  Created by hibor on 2018/8/1.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "CircleCell.h"

@interface CircleCell()

@property(nonatomic,strong)UIImageView *headImageView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)LLabel *contentLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIButton *ocButton;  //展开 收起

@end

@implementation CircleCell

+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIden = @"cellIden";
    CircleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[CircleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    return cell;
}

-(void)hidden{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENMENU" object:nil];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        __weak typeof (self) weakSelf = self;
        
        [self.contentView addSubview:self.headImageView];
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(15);
            make.left.mas_equalTo(12);
            make.size.mas_equalTo(CGSizeMake(42, 42));
        }];
        
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.headImageView.mas_right).offset(10);
            make.top.equalTo(weakSelf.headImageView.mas_top);
            make.height.mas_equalTo(20);
        }];
        
        [self.contentView addSubview:self.contentLabel];
        
        [self.contentView addSubview:self.ocButton];
        [self.contentView addSubview:self.mediaView];
        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.addressLabel];
        [self.contentView addSubview:self.menuView];
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}


-(UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.backgroundColor = [UIColor redColor];
        _headImageView.contentMode = UIViewContentModeCenter;
    }
    return _headImageView;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = RGB(91, 106, 146);
        _nameLabel.font = FONT_9_MEDIUM(15);
    }
    return _nameLabel;
}

//-(MLLinkLabel *)contentLabel{
//    if (!_contentLabel) {
//        _contentLabel = [MLLinkLabel new];
//        _contentLabel.font = [UIFont systemFontOfSize:15];
//        _contentLabel.textColor = RGB(26, 26, 26);
//        _contentLabel.linkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.09 green:0.49 blue:0.99 alpha:1.0]};
//        _contentLabel.activeLinkTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.09 green:0.49 blue:0.99 alpha:1.0],NSBackgroundColorAttributeName: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]};
//        _contentLabel.numberOfLines = 0;
//        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
//    }
//    return _contentLabel;
//}
-(LLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [LLabel new];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = RGB(26, 26, 26);
        _contentLabel.edgInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}

-(UIButton *)ocButton{
    if (!_ocButton) {
        _ocButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _ocButton.titleLabel.font = FONT_9_REGULAR(15);
        _ocButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_ocButton setTitleColor:RGB(91, 106, 146) forState:UIControlStateNormal];
        [_ocButton addTarget:self action:@selector(ocButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ocButton;
}

-(MediaView *)mediaView{
    if (!_mediaView) {
        _mediaView = [[MediaView alloc] init];
    }
    return _mediaView;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textColor = RGB(115, 115, 115);
    }
    return _timeLabel;
}

-(UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textColor = RGB(115, 115, 115);
    }
    return _addressLabel;
}


-(WeMenuView *)menuView{
    if (!_menuView) {
        _menuView = [[WeMenuView alloc] init];
        _menuView.show = NO;
        __weak typeof (self) weakSelf = self;
        [_menuView setLikeMoment:^{
            NSLog(@"11111");
        }];
        [_menuView setCommentMoment:^{
            NSLog(@"22222");
        }];
    }
    return _menuView;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _ocButton.tag = indexPath.row;
}
-(void)ocButtonAction:(UIButton *)sender{
    if (_model.open) {
        _model.open = NO;
    }else{
        _model.open = YES;
    }
    NSLog(@"sender = %ld",sender.tag);
    if (self.delegate && [self.delegate respondsToSelector:@selector(ocButtonClickWithIndexPath:)]) {
        [self.delegate ocButtonClickWithIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    }

}

-(void)setModel:(CircleModel *)model{
    if (model) {
        __weak typeof (self) weakSelf = self;
        _model = model;
        _model.rowHeight = 0;
        
        _headImageView.image = [UIImage imageNamed:model.headImage];
        _nameLabel.text = model.nickName;
        _model.rowHeight += 40;
        
        _contentLabel.text = model.content;
        CGSize sizeContentLabel = CGSizeMake(0, 0);
        CGFloat contentH = 0.0;
        if (model.content.length) {//[_contentLabel preferredSizeWithMaxWidth:(SCREEN_WIDTH-79)];//
            sizeContentLabel = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-79, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_contentLabel.font} context:nil].size;
            if (model.open) {
                [_ocButton setTitle:@"收起" forState:UIControlStateNormal];
                _model.rowHeight += sizeContentLabel.height;
                contentH = sizeContentLabel.height;
            }else{
                if (sizeContentLabel.height > 100) {
                    _model.rowHeight += 90;
                    contentH = 90;
                    if (model.open) {
                        [_ocButton setTitle:@"收起" forState:UIControlStateNormal];
                    }else{
                        [_ocButton setTitle:@"展开" forState:UIControlStateNormal];
                    }
                }else{
                    _model.rowHeight += sizeContentLabel.height+10;
                    contentH = sizeContentLabel.height+10;
                }
            }
            
        }else{
            contentH = 0;
        }
        
        [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.headImageView.mas_right).offset(10);
            make.top.equalTo(weakSelf.nameLabel.mas_bottom).offset(5);
            make.right.equalTo(weakSelf.contentView).offset(-15);
            if (!weakSelf.model.open) {
                make.height.mas_equalTo(contentH);
            }
            
//            make.height.mas_equalTo(sizeContentLabel.height > 100 ? 100 : ((model.content) ? sizeContentLabel.height : 0));
        }];
        
        [self.ocButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.contentLabel.mas_left);
            make.top.equalTo(weakSelf.contentLabel.mas_bottom).offset(5);
            make.size.mas_equalTo(CGSizeMake(50, ((model.content && contentH >= 90) ? 20 : 0)));
//            make.size.mas_equalTo(CGSizeMake(50, ((model.content && sizeContentLabel.height > 100) ? 20 : 0)));
        }];
        if (sizeContentLabel.height < 100) {
            self.ocButton.hidden = YES;
        }else{
            self.ocButton.hidden = NO;
        }
        _mediaView.model = model;
        
        _timeLabel.text = model.time;
        _addressLabel.text = model.address;
        
        
        NSLog(@"%@",NSStringFromCGRect(_mediaView.frame));
        
        CGSize size = _mediaView.frame.size;
        _model.rowHeight += size.height;
        [self.mediaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.headImageView.mas_right).offset(10);
            make.top.equalTo(weakSelf.ocButton.mas_bottom).offset(5);
            make.size.mas_equalTo(size);
        }];
        
        
        [self.addressLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel.mas_left);
            make.top.equalTo(weakSelf.mediaView.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
        }];
        
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.nameLabel.mas_left);
            make.top.equalTo(weakSelf.addressLabel.mas_bottom).offset(5);
            make.height.mas_equalTo(20);
        }];
        

        [self.menuView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.centerY.equalTo(weakSelf.timeLabel);
            make.size.mas_equalTo(CGSizeMake(200, 38));
        }];
        NSLog(@"%lf",self.timeLabel.bottom);
        _model.rowHeight += 100;
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    
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
