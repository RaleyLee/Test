//
//  AroundCell.m
//  AroundVC
//
//  Created by apple on 17/2/8.
//  Copyright © 2017年 ZXL. All rights reserved.
//

#import "AroundCell.h"
@interface AroundCell(){
    NSArray *keys;
}
@end
@implementation AroundCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = [UIColor whiteColor];
        
        keys = @[@"zxj",@"zdf",@"zde",@"hsl",@"zs",@"lb",@"zf",@"cjl",@"cje",@"syl",@"ltsz",@"zsz"];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:UIDeviceOrientationDidChangeNotification object:nil];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    CGFloat labelW = 90;
    __weak typeof(self) weakSelf = self;

    self.nameLabel = [LLabel new];
    self.nameLabel.font = FONT_9_MEDIUM(STOCK_CONTENT_NAME_FONT);
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.textColor = STOCK_CONTENT_NAME_COLOR;
    self.nameLabel.edgInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    self.nameLabel.adjustsFontSizeToFitWidth = YES;
    self.nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    self.nameLabel.minimumScaleFactor = STOCK_CONTENT_NAME_MINPERCENT;
//    self.nameLabel.minimumFontSize = STOCK_CONTENT_NAME_MINFONT;
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(MARKET_SPACING);
        make.size.mas_equalTo(CGSizeMake(labelW-MARKET_SPACING, 25));
    }];
    
    self.codeLabel = [LLabel new];
    self.codeLabel.font = FONT_9_REGULAR(STOCK_CONTENT_CODE_FONT);
    self.codeLabel.textAlignment = NSTextAlignmentLeft;
    self.codeLabel.textColor = STOCK_CONTENT_CODE_COLOR;
    self.codeLabel.edgInsets = UIEdgeInsetsMake(6, 0, 10, 0);
    [self.contentView addSubview:self.codeLabel];
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.nameLabel.mas_bottom);
        make.left.mas_equalTo(MARKET_SPACING);
        make.width.mas_equalTo(labelW-MARKET_SPACING);
        make.bottom.mas_equalTo(0);
//        make.size.mas_equalTo(CGSizeMake(labelW-15, 20));
    }];
    
    self.rightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(labelW, 0, SCREEN_WIDTH-labelW, CGRectGetHeight(self.contentView.frame))];
    [keys enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = [UILabel new];
//        label.text = self.model.dict[obj];
        label.font = FONT_9_BOLD(15);
        label.tag = 500+idx;
        label.textAlignment = NSTextAlignmentRight;
        label.textColor = STOCK_CONTENT_NAME_COLOR;
        [self.rightScrollView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(@(labelW*idx));
            make.width.mas_equalTo(labelW);
            make.height.mas_equalTo(self.rightScrollView.mas_height);
//            make.size.mas_equalTo(CGSizeMake(labelW, 50));
        }];
    }];
    self.rightScrollView.showsVerticalScrollIndicator = NO;
    self.rightScrollView.showsHorizontalScrollIndicator = NO;
    self.rightScrollView.contentSize = CGSizeMake(labelW * keys.count+15, 0);
    self.rightScrollView.delegate = self;

    [self.contentView addSubview:self.rightScrollView];
    [self.rightScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.nameLabel.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.rightScrollView addGestureRecognizer:tapGes];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.nameLabel.text = self.model.name;
    self.codeLabel.text = [self.model.code substringFromIndex:2];
    
    UILabel *label500 = (UILabel *)[self.contentView viewWithTag:500];
    label500.text = self.model.zxj;

    //涨跌幅
    UILabel *label501 = (UILabel *)[self.contentView viewWithTag:501];
    NSString *string501 = self.model.zdf;//self.model.dict[keys[1]];
    if ([string501 floatValue] > 0) {
        label501.textColor = STOCK_CONTENT_REDCOLOR;
        label501.text = [NSString stringWithFormat:@"+%@%%",string501];
    }else if ([string501 floatValue] < 0){
        label501.textColor = STOCK_CONTENT_GREENCOLOR;
        label501.text = [NSString stringWithFormat:@"%@%%",string501];
    }else if ([string501 floatValue] == 0){
        label501.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        label501.text = [NSString stringWithFormat:@"%@%%",string501];
    }
    
    //涨跌额
    UILabel *label502 = (UILabel *)[self.contentView viewWithTag:502];
    NSString *string502 = self.model.zde;//self.model.dict[keys[2]];
    if ([string502 floatValue] > 0) {
        label502.textColor = STOCK_CONTENT_REDCOLOR;
        label502.text = [NSString stringWithFormat:@"+%@",string502];
    }else if ([string502 floatValue] < 0){
        label502.textColor = STOCK_CONTENT_GREENCOLOR;
        label502.text = [NSString stringWithFormat:@"%@",string502];
    }else if ([string502 floatValue] == 0){
        label502.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        label502.text = [NSString stringWithFormat:@"%@",string502];
    }
    
    //换手率
    UILabel *label503 = (UILabel *)[self.contentView viewWithTag:503];
    NSString *string503 = self.model.hsl;//self.model.dict[keys[3]];
    label503.text = [NSString stringWithFormat:@"%@%%",string503];
    
    //5分钟涨速
    UILabel *label504 = (UILabel *)[self.contentView viewWithTag:504];
    NSString *string504 = self.model.zs;//self.model.dict[keys[4]];
    if ([string504 floatValue] > 0) {
        label504.textColor = STOCK_CONTENT_REDCOLOR;
        label504.text = [NSString stringWithFormat:@"+%@%%",string504];
    }else if ([string504 floatValue] < 0){
        label504.textColor = STOCK_CONTENT_GREENCOLOR;
        label504.text = [NSString stringWithFormat:@"%@%%",string504];
    }else if ([string504 floatValue] == 0){
        label504.textColor = STOCK_CONTENT_DEFAULTCOLOR;
        label504.text = [NSString stringWithFormat:@"%@%%",string504];
    }
    
    //量比
    UILabel *label505 = (UILabel *)[self.contentView viewWithTag:505];
    NSString *string505 = self.model.lb;//self.model.dict[keys[5]];
    label505.text = string505;
    
    //振幅
    UILabel *label506 = (UILabel *)[self.contentView viewWithTag:506];
    NSString *string506 = self.model.zf;//self.model.dict[keys[6]];
    label506.text = [NSString stringWithFormat:@"%@%%",string506];

    //成交量（手）万 亿 返回的个数
    UILabel *label507 = (UILabel *)[self.contentView viewWithTag:507];
    NSString *string507 = self.model.cjl;//self.model.dict[keys[7]];
    label507.text = [self formatCJLWithString:string507];
    
    //成交额 返回的万
    UILabel *label508 = (UILabel *)[self.contentView viewWithTag:508];
    NSString *string508 = [NSString stringWithFormat:@"%lf",[self.model.cje floatValue]*10000] ;//.dict[keys[8]]
    label508.text = [self formatCJLWithString:string508];
    
    //市盈TTM
    UILabel *label509 = (UILabel *)[self.contentView viewWithTag:509];
    NSString *string509 = self.model.syl;//.dict[keys[9]]
    label509.text = string509;
    
    //流通市值   返回的亿
    UILabel *label510 = (UILabel *)[self.contentView viewWithTag:510];
    NSMutableString *ss510 = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.2f亿",[self.model.ltsz floatValue]]];//.dict[keys[10]]
    NSString *string510 =  [ss510 stringByReplacingOccurrencesOfString:@".00" withString:@""];
    label510.text = string510;
    
    //总市值  返回的亿
    UILabel *label511 = (UILabel *)[self.contentView viewWithTag:511];
    NSMutableString *ss511 = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.2f亿",[self.model.zsz floatValue]]];//.dict[keys[11]]
    NSString *string511 =  [ss511 stringByReplacingOccurrencesOfString:@".00" withString:@""];
    label511.text = string511;
}

-(NSString *)formatCJLWithString:(NSString *)string{
    float value = [string floatValue];
    if (value > 100000000) {
        NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.2f亿",value/100000000]];
        return [string stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }else if (value > 10000) {
        NSMutableString *string = [NSMutableString stringWithString:[NSString stringWithFormat:@"%.2f万",value/10000]];
        return [string stringByReplacingOccurrencesOfString:@".00" withString:@""];
    }
    return [NSString stringWithFormat:@"%.0f",value];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _isNotification = NO;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 避开自己发的通知，只有手指拨动才会是自己的滚动
    if (!_isNotification) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(scrollView.contentOffset.x)}];
    }
    _isNotification = NO;
}

-(void)scrollMove:(NSNotification*)notification
{
//    if (![notification.name isEqualToString:tapCellScrollNotification]) {
    
//        return;
//    }
    NSDictionary *noticeInfo = notification.userInfo;
    NSObject *obj = notification.object;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    if (obj!=self) {
        _isNotification = YES;
        [_rightScrollView setContentOffset:CGPointMake(x, 0) animated:NO];
    }else{
        _isNotification = NO;
    }
    obj = nil;
}

#pragma mark - 点击事件
- (void)tapAction:(UITapGestureRecognizer *)gesture
{
    __weak typeof (self) weakSelf = self;
    if (self.tapCellClick) {
        NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf];
        weakSelf.tapCellClick(indexPath);
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

@end
