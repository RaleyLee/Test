//
//  SongListCell.m
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "SongListCell.h"

@interface SongListCell()

@property(nonatomic,strong)UIImageView *songListImageView;
@property(nonatomic,strong)UILabel *songListNameLabel;

@end

@implementation SongListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.songListImageView];
        [self.songListImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
        [self.contentView addSubview:self.songListNameLabel];
        [self.songListNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.songListImageView.mas_right).offset(15);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UIImageView *)songListImageView{
    if (!_songListImageView) {
        _songListImageView = [UIImageView new];
        _songListImageView.backgroundColor = [UIColor redColor];
    }
    return _songListImageView;
}
-(UILabel *)songListNameLabel{
    if (!_songListNameLabel) {
        _songListNameLabel = [UILabel new];
        _songListNameLabel.textColor = [UIColor whiteColor];
        _songListNameLabel.font = FONT_9_REGULAR(15);
        _songListNameLabel.text = @"歌单123";
        [_songListNameLabel sizeToFit];
    }
    return _songListNameLabel;
}

-(void)setListType:(SongListType)listType{
    if (listType == SongListTypeEnd) {
        _songListImageView.backgroundColor = [UIColor greenColor];
        _songListNameLabel.text = @"添加歌单";
    }else{
        _songListImageView.backgroundColor = [UIColor redColor];
        _songListNameLabel.text = @"歌单123";
    }
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
