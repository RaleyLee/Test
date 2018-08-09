//
//  VRefreshPopView.m
//  PopupViewExample
//
//  Created by Vols on 2017/6/30.
//  Copyright © 2017年 vols. All rights reserved.
//

#import "VRefreshPopView.h"


#define kRefreshCellIdentifier     @"kRefreshCellIdentifier"

@interface VRefreshCell : UITableViewCell

@property(nonatomic,strong) UIImageView * selectIView;
@property(nonatomic,strong) UILabel     * titleLabel;

@end

@implementation VRefreshCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //        self.contentView.backgroundColor = kRGB(250, 251, 252);
        [self.contentView addSubview:self.selectIView];
        [self.contentView addSubview:self.titleLabel];
        
        [_selectIView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(20);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(16, 16));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_selectIView.mas_right).offset(10);
            make.top.bottom.right.equalTo(self.contentView);
        }];
    }
    
//    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    return self;
}

#pragma mark - getter

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:12];
        _titleLabel.textColor = [UIColor grayColor];
    }
    return _titleLabel;
}

- (UIImageView *)selectIView {
    if (_selectIView == nil) {
        _selectIView = [[UIImageView alloc] init];
        _selectIView.backgroundColor = [UIColor clearColor];
        _selectIView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _selectIView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end


@interface VRefreshPopView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView        * superView;
@property (nonatomic, strong) UIButton      * olayMaskView;

@property (nonatomic, strong) UILabel       * titleLabel;

@property (nonatomic, strong) UITableView   * tableView;
@property (nonatomic, strong) NSArray       * menuTitles;

@end



@implementation VRefreshPopView

#pragma mark - Public

+ (VRefreshPopView *)showWithView:(UIView *)view {
    VRefreshPopView *popupMenu = [[VRefreshPopView alloc] init];
    popupMenu.backgroundColor = [UIColor orangeColor];
    [popupMenu showWithView:view];
    
    return popupMenu;
}


- (void)showWithView:(UIView *)superView {
    [superView addSubview:self.olayMaskView];
    [superView addSubview:self];

    [_olayMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.superview);
        make.centerY.equalTo(self.superview);
        make.size.mas_equalTo(CGSizeMake(180, 260));
    }];
}

- (void)dismiss {
    [_olayMaskView removeFromSuperview];
    [self removeFromSuperview];             //移除控件
}


#pragma mark - Lifecycle

- (id)init{
    self = [super init];
    if (self) {
        
        [self configureViews];
    }
    return self;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    
    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
    NSIndexPath * curIndex = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
    
    _selectedIndex = selectedIndex;
    
    if (lastIndex.row == curIndex.row) {
        return;
    }
    
    [self.tableView reloadRowsAtIndexPaths:@[lastIndex, curIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    //    [_tableView reloadData];
}

- (void)configureViews{
    //    self.isHideOverLay = YES;
    self.layer.masksToBounds = YES;
    
    _menuTitles = @[@"15秒自动刷新", @"30秒自动刷新", @"60秒自动刷新", @"120秒自动刷新", @"不自动刷新"];
    
    [self addSubview:self.titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self);
        make.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.top.equalTo(_titleLabel.mas_bottom);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}


- (void)event_touchMask:(UIButton *)sender {
    [self dismiss];
}

#pragma mark - Properties

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[VRefreshCell class] forCellReuseIdentifier:kRefreshCellIdentifier];
        _tableView.estimatedRowHeight = 44;      //预估行高 可以提高性能
        _tableView.bounces = NO;
        _tableView.clipsToBounds = YES;
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
    }
    return _tableView;
}


- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:20];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"刷新设置";
        _titleLabel.backgroundColor = [UIColor colorWithRed:217/255.0 green:21/255.0 blue:59/255.0 alpha:10];
        _titleLabel.clipsToBounds=YES;
    }
    return _titleLabel;
}


- (UIButton *)olayMaskView{
    if (_olayMaskView == nil) {
        _olayMaskView = [UIButton buttonWithType:UIButtonTypeCustom];
        _olayMaskView.backgroundColor = [UIColor grayColor];
        _olayMaskView.alpha = 0.4;
        [_olayMaskView addTarget:self action:@selector(event_touchMask:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _olayMaskView;
}


#pragma mark - UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _menuTitles.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    VRefreshCell * cell = [tableView dequeueReusableCellWithIdentifier:kRefreshCellIdentifier];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.titleLabel.textColor = [UIColor colorWithWhite:0.293 alpha:1.000];
    cell.titleLabel.font = [UIFont systemFontOfSize:15];
    cell.titleLabel.text = _menuTitles[indexPath.row];
    cell.selectIView.image = (indexPath.row != _selectedIndex ? nil : [UIImage imageNamed:@"refresh_select"]);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    
    if (self.clickHandler) {
        self.clickHandler(indexPath.row);
    }
    
    [self dismiss];
}


@end
