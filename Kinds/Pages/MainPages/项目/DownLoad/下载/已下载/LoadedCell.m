//
//  LoadedCell.m
//  Kinds
//
//  Created by hibor on 2018/8/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LoadedCell.h"

@interface LoadedCell()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;


@end

@implementation LoadedCell

+(instancetype)createCellWithTableView:(UITableView *)tableView{
    static NSString *IDEN = @"loadedCell";
    LoadedCell *cell = [tableView dequeueReusableCellWithIdentifier:IDEN];
    if (!cell) {
        cell = [[LoadedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDEN];
        cell = [[[NSBundle mainBundle] loadNibNamed:@"LoadedCell" owner:nil options:nil] firstObject];
    }
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}


- (void)setFileInfo:(DownFileModel *)fileInfo
{
    _fileInfo = fileInfo;
    self.titleLabel.text = fileInfo.disFileName;
    self.sizeLabel.text = [NSString stringWithFormat:@"%@",[DownLoadHelper getFileSizeString:fileInfo.fileSize]];
    
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
