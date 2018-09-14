//
//  BDLayerView.m
//  Kinds
//
//  Created by hibor on 2018/8/14.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "BDLayerView.h"
#import "BDManager.h"
@class BDLayerCell;

@interface BDLayerView ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *layerTableView;
@property(nonatomic,strong)NSArray *contentArray;
@property(nonatomic,strong)NSMutableDictionary *laDictionary;

@end

@implementation BDLayerView


+(BDLayerView *)popLayerView{
    BDLayerView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"BDLayerView" owner:nil options:nil].firstObject;
    return chooseView;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.laDictionary = [BDManager getLayerContent];
        
        self.contentArray = @[
                              @[
                                  @{@"image":@"road-event",@"title":@"路况事件"},
                                  @{@"image":@"hot-diagram",@"title":@"热力图"},
                                  @{@"image":@"collection-point",@"title":@"收藏的点"}
                                  ],
                              @[
                                  @{@"image":@"electric-map",@"title":@"充电桩地图"},
                                  @{@"image":@"phone-store-map",@"title":@"手机门店地图"},
                                  @{@"image":@"medical-map",@"title":@"异地医保地图"},
                                  @{@"image":@"haze-map",@"title":@"雾霾地图"}
                                  ],
                              @[
                                  @{@"image":@"classic-map",@"title":@"经典地图"},
                                  @{@"image":@"tourist-map",@"title":@"旅游地图"},
                                  @{@"image":@"antique-map",@"title":@"古风地图"},
                                  @{@"image":@"bua-subway-map",@"title":@"公交地铁"}
                                  ]
                              ];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.layerTableView.tableFooterView = [UIView new];
    self.layerTableView.separatorColor = [UIColor clearColor];
    
    NSArray *laArray = @[@"layer_4D",@"layer_2D",@"layer_3D"];
    NSArray *latArray = @[@"卫星图",@"2D平面图",@"3D俯视图"];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 140)];
    headView.backgroundColor = [UIColor whiteColor];
    self.layerTableView.tableHeaderView = headView;
    
    CGFloat space = 15;
    CGFloat width = 60,height = 43;
    
    for (int i = 0; i < laArray.count; i++) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake((space*(i+1))+(width*i), 50, width, height+30)];
        view.tag = 101+i;
        if (i == 2) {
            view.alpha = 0.3f;
            view.userInteractionEnabled = NO;
        }
        [headView addSubview:view];
        
        
        UIImageView *mapImageView = [[UIImageView alloc] init];
        mapImageView.image = [UIImage imageNamed:laArray[i]];
        mapImageView.frame = CGRectMake(0, 0, width, height);
        mapImageView.tag = 201+i;
        if ([self.laDictionary[@"mapKind"] intValue] == i+1) {
            mapImageView.layer.borderColor = RGB(79, 134, 243).CGColor;
        }else{
            mapImageView.layer.borderColor = RGB_color(204).CGColor;
        }
        mapImageView.layer.cornerRadius = 3;
        mapImageView.layer.borderWidth = 0.5;
        mapImageView.layer.masksToBounds = YES;
        [view addSubview:mapImageView];
        // 79  134  243
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, mapImageView.bottom, width, 30)];
        label.text = latArray[i];
        label.textColor = RGB_color(51);
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = 301+i;
        if ([self.laDictionary[@"mapKind"] intValue] == i+1) {
            label.textColor = RGB(79, 134, 243);
        }
        [view addSubview:label];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMapKindAction:)];
        [view addGestureRecognizer:tap];

    }
}
-(void)tapMapKindAction:(UITapGestureRecognizer *)gesture{
    for (int i = 1; i <= 3; i++) {
        UIImageView *mapImageView = (UIImageView *)[self.layerTableView.tableHeaderView viewWithTag:200+i];
        mapImageView.layer.borderColor = RGB(204, 204, 204).CGColor;
        
        UILabel *label = (UILabel *)[self.layerTableView.tableHeaderView viewWithTag:300+i];
        label.textColor =  RGB_color(51);
    }
    NSArray *array = [self.layerTableView.tableHeaderView subviews];
    
    for (UIView *view in array) {
        if (view.tag == gesture.view.tag) {
            UIImageView *mapImageView = (UIImageView *)[view viewWithTag:view.tag + 100];
            mapImageView.layer.borderColor = RGB(79, 134, 243).CGColor;
            
            UILabel *label = (UILabel *)[view viewWithTag:view.tag + 200];
            label.textColor = RGB(79, 134, 243);
        }
    }
    [self.laDictionary setObject:[NSString stringWithFormat:@"%ld",gesture.view.tag-100] forKey:@"mapKind"];
    [BDManager writeLayerContentWithDictionary:self.laDictionary];
    if (self.mapkindBlock) {
        self.mapkindBlock(gesture.view.tag-100);
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contentArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BDLayerCell *cell = [BDLayerCell cellWithTableView:tableView];
    
    NSDictionary *dict = self.contentArray[indexPath.section][indexPath.row];
    cell.iconImageView.image  = [UIImage imageNamed:dict[@"image"]];
    cell.titleLabel.text = dict[@"title"];
    
    if (indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 0){
        //switch
        for (UIView *swi in [cell.contentView subviews]) {
            if ([swi isKindOfClass:[UISwitch class]]) {
                [swi removeFromSuperview];
            }
        }
        UISwitch *changeSwitch = [[UISwitch alloc] init];
        if (indexPath.row == 0) {
            changeSwitch.on = [self.laDictionary[@"road-event"] isEqualToString:@"1"];
        }else if (indexPath.row == 1) {
            changeSwitch.on = [self.laDictionary[@"hot-diagram"] isEqualToString:@"1"];
        }else if (indexPath.row == 2) {
            changeSwitch.on = [self.laDictionary[@"collection-point"] isEqualToString:@"1"];
        }
        changeSwitch.tag = 500+indexPath.row;
        [changeSwitch addTarget:self action:@selector(changeSwitchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:changeSwitch];
        [changeSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.mas_equalTo(-20);
        }];
    }else if (indexPath.section == 2){
        //单选
    }
    return cell;
}

-(void)changeSwitchAction:(UISwitch *)swi{
    BOOL on = !swi.isOn;
    [swi setOn:on];
    
    NSString *value = on ? @"1" : @"0";
    if (swi.tag == 500) {
        [self.laDictionary setObject:value forKey:@"road-event"];
    }else if (swi.tag == 501) {
        [self.laDictionary setObject:value forKey:@"hot-diagram"];
    }else if (swi.tag == 502) {
        [self.laDictionary setObject:value forKey:@"collection-point"];
    }
    [BDManager writeLayerContentWithDictionary:self.laDictionary];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        return;
    }else if (indexPath.section == 1) {
        
    }else if (indexPath.section == 2) {
        
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 50)];
    bgView.backgroundColor = RGB_color(247);
    UILabel *label = [UILabel new];
    if (section == 1) {
        label.text = @"生活便民地图";
    }
    if (section == 2) {
        label.text = @"主题地图";
    }
    label.textColor = RGB_color(102);
    label.font = [UIFont systemFontOfSize:12];
    label.frame = CGRectMake(15, 0, 100, 50);
    [bgView addSubview:label];
    return bgView;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismiss];
}
-(void)show{
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self];
    [self animatedIn];
}

-(void)dismiss{
    [self animatedOut];
}

#pragma mark - Animated Mthod
- (void)animatedIn{
    CGRect frame = self.layerTableView.frame;
    frame.origin.x = SCREEN_WIDTH;
    self.layerTableView.frame = frame;
    [UIView animateWithDuration:.35 animations:^{
        CGRect frame = self.layerTableView.frame;
        frame.origin.x = SCREEN_WIDTH-240;
        self.layerTableView.frame = frame;
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        CGRect frame = self.layerTableView.frame;
        frame.origin.x = SCREEN_WIDTH;
        self.layerTableView.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.alpha = 0;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end






@implementation BDLayerCell


+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellIden = @"layerCell";
    BDLayerCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIden];
    if (!cell) {
        cell = [[BDLayerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIden];
    }
    
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(35, 35));
        }];
        
        [self.contentView addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return self;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = RGB_color(94);
    }
    return _titleLabel;
}
@end





