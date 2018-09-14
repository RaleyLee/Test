//
//  DownCell.m
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "DownCell.h"

@interface DownCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIView *coverView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downProgress;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@end

@implementation DownCell

+(instancetype)createCellWithTableView:(UITableView *)tableView{
    DownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"loading"];
    if (!cell) {
        cell = [[DownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"loading"];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DownCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

-(void)setCellType:(DownCellType)cellType{
    _cellType = cellType;
    
    self.downProgress.hidden = cellType;
    self.stateLabel.hidden = cellType;
}

- (void)setFileInfo:(DownFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.titleLabel.text = fileInfo.disFileName;//fileInfo.fileName;
    // 服务器可能响应的慢，拿不到视频总长度 && 不是下载状态
    if ([fileInfo.fileSize longLongValue] == 0 && !(fileInfo.downloadState == DownLoadStateLoading)) {
        self.sizeLabel.text = @"";
        if (fileInfo.downloadState == DownLoadStateStop) {
            self.stateLabel.text = @"已暂停";
        } else if (fileInfo.downloadState == DownLoadStateWaiting) {
            self.stateLabel.text = @"等待下载";
        }
        self.downProgress.progress = 0.0;
        return;
    }
    NSString *currentSize = [DownLoadHelper getFileSizeString:fileInfo.fileReceivedSize];
    NSString *totalSize = [DownLoadHelper getFileSizeString:fileInfo.fileSize];
    // 下载进度
    float progress = (float)[fileInfo.fileReceivedSize longLongValue] / [fileInfo.fileSize longLongValue];
    
    self.sizeLabel.text = [NSString stringWithFormat:@"%@ / %@ (%.2f%%)",currentSize, totalSize, progress*100];
    
    self.downProgress.progress = progress;
    
    // NSString *spped = [NSString stringWithFormat:@"%@/S",[ZFCommonHelper getFileSizeString:[NSString stringWithFormat:@"%lu",[ASIHTTPRequest averageBandwidthUsedPerSecond]]]];
    if (fileInfo.speed) {
        NSString *speed = [NSString stringWithFormat:@"%@ 剩余%@",fileInfo.speed,fileInfo.remainingTime];
        self.stateLabel.text = speed;
    } else {
        self.stateLabel.text = @"正在获取";
    }
    
    if (fileInfo.downloadState == DownLoadStateLoading) { //文件正在下载
//        self.downloadBtn.selected = NO;
    } else if (fileInfo.downloadState == DownLoadStateStop && !fileInfo.error) {
//        self.downloadBtn.selected = YES;
        self.stateLabel.text = @"已暂停";
    }else if (fileInfo.downloadState == DownLoadStateWaiting && !fileInfo.error) {
//        self.downloadBtn.selected = YES;
        self.stateLabel.text = @"等待下载";
    } else if (fileInfo.error) {
//        self.downloadBtn.selected = YES;
        self.stateLabel.text = @"错误";
    }
    
    self.coverImageView.image = [UIImage thumbnailImageForVideo:[NSURL URLWithString:fileInfo.fileURL] atTime:10];
    
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
