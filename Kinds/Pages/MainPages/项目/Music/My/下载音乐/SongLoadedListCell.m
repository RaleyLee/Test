//
//  SongLoadedListCell.m
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "SongLoadedListCell.h"

@interface SongLoadedListCell ()

@property(nonatomic,strong) UILabel *numberLabel;
@property(nonatomic,strong) UILabel *songLabel;
@property(nonatomic,strong) UILabel *singerLabel;

@end

@implementation SongLoadedListCell


+(instancetype)createSongListCell:(UITableView *)tableView{
    static NSString *songID = @"songID";
    SongLoadedListCell *cell = [tableView dequeueReusableCellWithIdentifier:songID];
    if (!cell) {
        cell = [[SongLoadedListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:songID];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.numberLabel];
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.mas_equalTo(15);
        }];
        
        [self.contentView addSubview:self.songLabel];
        [self.songLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.numberLabel.mas_right).offset(15);
            make.top.mas_equalTo(10);
            make.height.mas_equalTo(25);
        }];
        
        [self.contentView addSubview:self.singerLabel];
        [self.singerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.songLabel.mas_left);
            make.height.mas_equalTo(20);
            make.bottom.mas_equalTo(-10);
        }];
    }
    return self;
}

-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
}


-(void)setSModel:(SongModel *)sModel{
    _sModel = sModel;
    
    self.songLabel.text = sModel.song;
    self.singerLabel.text = sModel.singer;
    
}
-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [UILabel new];
        _numberLabel.font = FONT_9_MEDIUM(13);
        _numberLabel.textColor = RGB_color(151);
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

-(UILabel *)songLabel{
    if (!_songLabel) {
        _songLabel = [UILabel new];
        _songLabel.font = FONT_9_MEDIUM(16);
        _songLabel.textColor = RGB_color(50);
    }
    return _songLabel;
}

-(UILabel *)singerLabel{
    if (!_singerLabel) {
        _singerLabel = [UILabel new];
        _singerLabel.font = FONT_9_MEDIUM(12);
        _singerLabel.textColor = RGB_color(137);
    }
    return _singerLabel;
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
