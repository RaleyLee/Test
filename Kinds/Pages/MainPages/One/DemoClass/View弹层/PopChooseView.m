//
//  PopChooseView.m
//  Kinds
//
//  Created by hibor on 2018/7/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "PopChooseView.h"
@class PopChooseCell;
@interface PopChooseView()<UITableViewDelegate,UITableViewDataSource,chooseItemButtonDelegate,chooseAddStockGroupDelegate>

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *chooseArray;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property(nonatomic,assign)NSInteger countNumber;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation PopChooseView

+(PopChooseView *)popChooseView{
    PopChooseView *chooseView = [[NSBundle mainBundle] loadNibNamed:@"PopChooseView" owner:nil options:nil].firstObject;
    return chooseView;
}

-(void)setListDataArray:(NSArray *)dataArray cancelClick:(CancelButtonBlock)cancel addClick:(AddButtonBlock)add{
    self.cancelBlock = cancel;
    self.addBlock = add;
    self.dataArray = [NSMutableArray arrayWithArray:dataArray];
    self.chooseArray = [NSMutableArray array];
    for (int i = 0; i < dataArray.count; i++) {
        [self.chooseArray addObject:@"0"];
    }
    
}
- (IBAction)closeButtonAction:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self dismiss];
}
- (IBAction)addButtonAction:(UIButton *)sender {
    if (self.addBlock) {
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.chooseArray.count; i++) {
            if ([self.chooseArray[i] isEqualToString:@"1"]) {
                [array addObject:self.dataArray[i]];
            }
        }
        self.addBlock(array);
    }
    [self dismiss];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (_popChooseViewStyle == PopChooseViewStyleAdd) {
        self.titleLabel.text = @"选择分组添加";
    }else {
        self.titleLabel.text = @"选择分组删除";
    }
    [self.addButton setTitle:[NSString stringWithFormat:@"确定%@",_popChooseViewStyle == PopChooseViewStyleAdd ? @"添加" :@"删除" ] forState:UIControlStateNormal];
    [self.cancelButton setTitle:[NSString stringWithFormat:@"取消%@",_popChooseViewStyle == PopChooseViewStyleAdd ? @"添加" :@"删除" ] forState:UIControlStateNormal];
    
    self.closeButton.showsTouchWhenHighlighted = NO;
    UIImage *cImage = [self.closeButton.imageView.image imageChangeColor:[UIColor whiteColor]];
    [self.closeButton setImage:cImage forState:UIControlStateNormal];
    [self.closeButton setImage:cImage forState:UIControlStateHighlighted];
    
    [self.addButton setEnabled:NO];
    
    if (_showNoDataSign && self.dataArray.count == 0) {
        UILabel *label = [UILabel new];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"暂无分组";
        self.listTableView.backgroundView = label;
        
    }
    
    __weak typeof (self) weakSelf = self;
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        if (weakSelf.dataArray.count <= 4) {
            make.height.mas_equalTo(240);
        }else{
            make.height.mas_equalTo(280);
        }
    }];
    
}

-(void)setShowNoDataSign:(BOOL)showNoDataSign{
    _showNoDataSign = showNoDataSign;
}
-(void)setShowAddCount:(BOOL)showAddCount{
    _showAddCount = showAddCount;
}

-(void)setCountNumber:(NSInteger)countNumber{
    _countNumber = countNumber;
    [self changeAddButtonState];
}

-(void)changeAddButtonState{
    if (_countNumber > 0) {
        [self.addButton setEnabled:YES];
        if (_showAddCount) {
            [self.addButton setTitle:[NSString stringWithFormat:@"确定添加(%ld)",_countNumber] forState:UIControlStateNormal];
        }
    }else{
        [self.addButton setEnabled:NO];
        if (_showAddCount) {
            [self.addButton setTitle:@"确定添加" forState:UIControlStateNormal];
        }
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.frame = [UIScreen mainScreen].bounds;
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 17, 0, 17)];
    }
    if ([self.listTableView respondsToSelector:@selector(setSeparatorColor:)]) {
        [self.listTableView setSeparatorColor:RGB(211, 211, 211)];
    }
    self.listTableView.tableFooterView = [UIView new];
    
    UIBezierPath *besizer = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = besizer.CGPath;
    self.bgView.layer.mask = shapeLayer;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count + (_popChooseViewStyle == PopChooseViewStyleAdd ? 1 : 0);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count && _popChooseViewStyle == PopChooseViewStyleAdd) {
        PopViewAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addCell"];
        if (!cell) {
            cell = [[PopViewAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        return cell;
    }
    static NSString *iden = @"iden";
    PopChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[PopChooseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.groupNameLabel.text = self.dataArray[indexPath.row];
    cell.chooseButton.selected = [self.chooseArray[indexPath.row] isEqualToString:@"1"];
    cell.rowIndex = indexPath.row;
    cell.delegate = self;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(void)addStockGroupAction{
    NSLog(@"弹出添加自选股窗口");
    PopAddStockView *addStockView = [PopAddStockView popAddStockView];
    addStockView.popStyle = PopAddViewStyleAdd;
    __weak typeof (self) weakSelf = self;
    addStockView.confirmClickBlock = ^(NSString *groupName) {
        NSLog(@"groupName = %@",groupName);
        [weakSelf.dataArray addObject:groupName];
        [weakSelf.chooseArray addObject:@"0"];
        [weakSelf.listTableView reloadData];
    };
    [addStockView show];
}
-(void)chooseItemButtonDidSelected:(NSInteger)index{
    [self chooseItemActionWithTableView:self.listTableView withRowIndex:[NSIndexPath indexPathForRow:index inSection:0]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self chooseItemActionWithTableView:tableView withRowIndex:indexPath];
}

-(void)chooseItemActionWithTableView:(UITableView *)tableView withRowIndex:(NSIndexPath *)indexPath{
    if (indexPath.row == self.dataArray.count) {
        return;
    }
    PopChooseCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self.chooseArray[indexPath.row] isEqualToString:@"1"]) {
        [self.chooseArray replaceObjectAtIndex:indexPath.row withObject:@"0"];
        self.countNumber--;
    }else if ([self.chooseArray[indexPath.row] isEqualToString:@"0"]) {
        [self.chooseArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        self.countNumber++;
    }
    cell.chooseButton.selected = [self.chooseArray[indexPath.row] isEqualToString:@"1"];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == (_popChooseViewStyle == PopChooseViewStyleDelete ? self.dataArray.count-1 : self.dataArray.count)) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 17, 0, 17)];
        tableView.separatorColor = RGB(211, 211, 211);
    }
}
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == (_popChooseViewStyle == PopChooseViewStyleDelete ? self.dataArray.count-1 : self.dataArray.count )) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width)];
    }else{
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 17, 0, 17)];
        tableView.separatorColor = RGB(211, 211, 211);
    }
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
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut{
    [UIView animateWithDuration:.35 animations:^{
        self.bgView.transform = CGAffineTransformMakeScale(0.2, 0.2);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end


@interface PopChooseCell()

@end

@implementation PopChooseCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.groupNameLabel];
        [self.groupNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.mas_offset(20);
        }];
        
        [self.contentView addSubview:self.chooseButton];
        [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-20);
            make.centerY.equalTo(self.contentView);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return self;
}

- (UILabel *)groupNameLabel{
    if (!_groupNameLabel) {
        _groupNameLabel = [UILabel new];
        _groupNameLabel.font = [UIFont systemFontOfSize:15];
    }
    return _groupNameLabel;
}

-(UIButton *)chooseButton{
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseButton setImage:[UIImage imageNamed:@"checkNO"] forState:UIControlStateNormal];
        [_chooseButton setImage:[UIImage imageNamed:@"checkYes"] forState:UIControlStateSelected];
        [_chooseButton addTarget:self action:@selector(clickChooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
}

-(void)clickChooseButtonAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseItemButtonDidSelected:)]) {
        [self.delegate chooseItemButtonDidSelected:sender.tag];
    }
}
-(void)setRowIndex:(NSInteger)rowIndex{
    _chooseButton.tag = rowIndex;
}
@end


@interface PopViewAddCell()

@property(nonatomic,strong)UIButton *addButton;

@end

@implementation PopViewAddCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.addButton];
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
    }
    return self;
}

-(UIButton *)addButton{
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addButton setTitle:@"添加分组" forState:UIControlStateNormal];
        [_addButton setTitleColor:RGB(238, 23, 69) forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_addButton setImage:[[UIImage imageNamed:@"moreAdd"] imageChangeColor:RGB(238, 23, 69)] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addStockGroup) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

-(void)addStockGroup{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addStockGroupAction)]) {
        [self.delegate addStockGroupAction];
    }
}

@end
