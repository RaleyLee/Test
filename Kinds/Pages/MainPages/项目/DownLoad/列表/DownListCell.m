//
//  DownListCell.m
//  Kinds
//
//  Created by hibor on 2018/8/18.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "DownListCell.h"

@interface DownListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@property (weak, nonatomic) IBOutlet UIButton *downButton;

@end

@implementation DownListCell

+(instancetype)createTableView:(UITableView *)tableView{
    static NSString *DownIden = @"downIden";
    DownListCell *cell = [tableView dequeueReusableCellWithIdentifier:DownIden];
    if (!cell) {
        cell = [[DownListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DownIden];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DownListCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}
- (IBAction)downButtonAction:(UIButton *)sender {
    NSLog(@"%ld",sender.tag);
    if (self.downLoadCallBackBlock) {
        self.downLoadCallBackBlock();
    }
}

-(void)setModel:(VideoModel *)model{
    _model = model;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    _downButton.tag = _indexPath.row;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof (self) weakSelf = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.coverImageView setImage:[UIImage thumbnailImageForVideo:[NSURL URLWithString:weakSelf.model.video] atTime:10]];
        weakSelf.titleLabel.text = weakSelf.model.title;
        weakSelf.sizeLabel.text = weakSelf.model.size;
//        NSDictionary *videoDic = [weakSelf getVideoInfoWithSourcePath:weakSelf.model.video];
//        weakSelf.sizeLabel.text = [weakSelf formatterWithByte:[videoDic[@"size"] floatValue]];
//    });
    
}

-(NSString *)formatterWithByte:(float)byte{
    if(byte >= 1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",byte/1024/1024];
    }
    else if(byte >= 1024 && byte < 1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",byte/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",byte];
    }
    return @"";
}

- (NSDictionary *)getVideoInfoWithSourcePath:(NSString *)path{
    AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    CMTime   time = [asset duration];
    int seconds = ceil(time.value/time.timescale);
    
    NSInteger   fileSize = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil].fileSize;
    
    return @{@"size" : @(fileSize),
             @"duration" : @(seconds)};
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
