//
//  ZHGGTViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHGGTViewController.h"
#import "HBStockInfoViewController.h"
#import "OCTableModel.h"
#import "OCTableViewHeaderView.h"
#import "HBGGTViewController2.h"

#import "HBHSListCell.h"
#import "HBGGTCell.h"
#import "HBMarketItemView.h"


@interface ZHGGTViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *zsArray;
@property(nonatomic,strong)NSMutableArray *totalArray;
@property(nonatomic,strong)NSArray *sectionTitleArray;
@property(nonatomic,strong)NSDictionary *limitDict;

@property(nonatomic,strong)NSMutableArray *O_CArray;

@end

@implementation ZHGGTViewController



-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    
    if (@available(iOS 11.0, *)) {
        if (IS_IPHONEX) {
            UIEdgeInsets  safeArea  =  self.view.safeAreaInsets;
            NSLog(@"safeArea:%@",NSStringFromUIEdgeInsets(safeArea));
            self.tableview_LeftLayout.constant = safeArea.left;
            self.tableview_RightLayout.constant =safeArea.right;
        }
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
//    if (IS_IPHONEX) {
//        if (SCREEN_WIDTH > SCREEN_HEIGHT) {
//            self.tableview_BottomLayout.constant = SafeAreaBottomMargin-10;
//        }else{
//            self.tableview_BottomLayout.constant = SafeAreaBottomMargin;
//        }
//    }else{
//        self.tableview_BottomLayout.constant = TabBarHeight;
//    }
    [self tableViewHeaderWithArray:self.zsArray Limit:self.limitDict];
    [self.listTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.O_CArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1", nil];
    
    self.sectionTitleArray = @[@"沪股通",@"深股通",@"港股通(沪)",@"港股通(深)",@"AH股"];
    self.listTableView.estimatedSectionHeaderHeight = STOCK_ZDSECTION_HEIGHT;
    self.listTableView.estimatedRowHeight = STOCK_CELL_HEIGHT_2;
    self.listTableView.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    __weak typeof (self) weakSelf = self;
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    
}

-(void)goTop{
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:TABLEVIEW_SCROLLTOTOP_DURATION animations:^{
        [weakSelf.listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    } completion:^(BOOL finished) {
        if (weakSelf.listTableView.contentOffset.y > 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TABLEVIEW_SCROLLTOTOP_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
            });
        }
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.firstAppear) {
        [self loadData];
        self.firstAppear = YES;
    }
}

-(void)loadData{
    
    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:GGT_HOME_URL isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.totalArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
    } failuare:^(NSError *error){
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.totalArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
    } success:^(id jsonData) {
        //        NSLog(@"jsonData = %@",jsonData);
        self.totalArray = [NSMutableArray array];
        
        NSArray *tempZsArray = jsonData[@"data"][@"hgtZs"];
        self.zsArray = [NSMutableArray array];
        for (NSDictionary *dict in tempZsArray) {
            HBListModel *model = [HBListModel mj_objectWithKeyValues:dict];
            [self.zsArray addObject:model];
        }
        self.limitDict = jsonData[@"data"][@"limit"];
        [self tableViewHeaderWithArray:self.zsArray Limit:self.limitDict];
        
        
        NSArray *ggtArray = jsonData[@"data"][@"ggt"];
        NSMutableArray *ggt = [NSMutableArray array];
        for (NSDictionary *dict in ggtArray) {
            HBHQModel *model = [HBHQModel mj_objectWithKeyValues:dict];
            [ggt addObject:model];
        }
        
        NSArray *ggtszArray = jsonData[@"data"][@"ggtsz"];
        NSMutableArray *ggtsz = [NSMutableArray array];
        for (NSDictionary *dict in ggtszArray) {
            HBHQModel *model = [HBHQModel mj_objectWithKeyValues:dict];
            [ggtsz addObject:model];
        }
        
        NSArray *hgtArray = jsonData[@"data"][@"hgt"];
        NSMutableArray *hgt = [NSMutableArray array];
        for (NSDictionary *dict in hgtArray) {
            HBHQModel *model = [HBHQModel mj_objectWithKeyValues:dict];
            [hgt addObject:model];
        }
        
        NSArray *sgtArray = jsonData[@"data"][@"sgt"];
        NSMutableArray *sgt = [NSMutableArray array];
        for (NSDictionary *dict in sgtArray) {
            HBHQModel *model = [HBHQModel mj_objectWithKeyValues:dict];
            [sgt addObject:model];
        }
        
        NSArray *aphArray = jsonData[@"data"][@"aph"][@"data"];
        NSMutableArray *aph = [NSMutableArray array];
        for (NSDictionary *dict in aphArray) {
            HBGGTModel *model = [HBGGTModel mj_objectWithKeyValues:dict];
            [aph addObject:model];
        }
        
        NSArray *tempArray = @[
                               @{@"headTitle":@"沪股通",@"listArray":hgt},
                               @{@"headTitle":@"深股通",@"listArray":sgt},
                               @{@"headTitle":@"港股通(沪)",@"listArray":ggt},
                               @{@"headTitle":@"港股通(深)",@"listArray":ggtsz},
                               @{@"headTitle":@"AH股",@"listArray":aph}
                               ];
        for (int i = 0 ; i < tempArray.count; i++) {
            NSDictionary *dict = tempArray[i];
            OCTableModel *model = [[OCTableModel alloc] init];
            model.headTitle = dict[@"headTitle"];
            model.listArray = dict[@"listArray"];
            model.opened =  [self.O_CArray[i] isEqualToString:@"1"] ? YES : NO;
            [self.totalArray addObject:model];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.totalArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        [weakSelf.listTableView reloadData];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];
        [weakSelf.listTableView.mj_header endRefreshing];
    }];
}
#pragma mark - 显示指数的Item

-(void)tableViewHeaderWithArray:(NSArray *)model Limit:(NSDictionary *)limit{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.bounds.size.width, 193)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = (headerView.bounds.size.width-MARKET_SPACING*2)/3;
    for (int i = 0; i < model.count; i++) {
        int row = i / 3;
        int col = i % 3;
        HBListModel *tempModel = model[i];
        
        
        HBMarketItemView *marketView = [[HBMarketItemView alloc] initWithFrame:CGRectMake(MARKET_SPACING+width*col, 85*row, width, 85) withItemType:MarketItemTypeTop];
        marketView.clickItemBlock = ^(id model) {
            //响应点击事件 跳转到股票详情页面
            HBStockInfoViewController *bdDetailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
            bdDetailVC.code = tempModel.code;
            bdDetailVC.stockName = tempModel.name;
            [bdDetailVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:bdDetailVC animated:YES];
        };
        marketView.listModel = tempModel;
        if (i > 2) {
            [UIView setBorderWithView:marketView top:YES left:NO bottom:NO right:NO borderColor:SECTION_UNDERLINE_COLOR borderWidth:marketView.frame.size.width borderHeight:0.5];
        }
        if (i == 1 || i == 4) {
            [UIView setBorderWithView:marketView top:NO left:YES bottom:NO right:YES borderColor:SECTION_UNDERLINE_COLOR borderWidth:0.5 borderHeight:50];
        }
        [headerView addSubview:marketView];
        
    }
    UIView *setView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 9)];
    setView.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    [headerView addSubview:setView];
    
    
    LLabel *signLabel = [[LLabel alloc] init];
    signLabel.text = @"当日可用额度";
    signLabel.font = FONT_9_MEDIUM(13);
    signLabel.textColor = RGB_color(51);
    signLabel.edgInsets = UIEdgeInsetsMake(MARKET_SPACING, 0, 0, 0);
    [headerView addSubview:signLabel];
    [signLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MARKET_SPACING);
        make.top.mas_equalTo(94);
        make.size.mas_equalTo(CGSizeMake(100, 28));
    }];
    
    
    
    UIView *bgView = [UIView new];
    //    bgView.backgroundColor = [UIColor cyanColor];
    [headerView addSubview:bgView];
    [bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(MARKET_SPACING);
        make.top.equalTo(signLabel.mas_bottom);
        make.right.mas_equalTo(-MARKET_SPACING);
        make.height.mas_equalTo(62);
    }];
    
    CGFloat itemWidth = (headerView.bounds.size.width-30)/4;
    NSMutableArray *itemArray = [NSMutableArray array];
    NSArray *titleArray = @[@"沪股通",@"港股通(沪)",@"深股通",@"港股通(深)"];
    for (int i = 0; i < 4; i++) {
        UIView *itemView = [[UIView alloc] init];
        itemView.frame = CGRectMake(itemWidth*i, 0, itemWidth, 62);
        [bgView addSubview:itemView];
        
        [itemArray addObject:itemView];
        
        LLabel *titleLabel = [[LLabel alloc] initWithFrame:CGRectMake(0, 0, itemWidth, 26)];
        titleLabel.text = titleArray[i];
        titleLabel.textColor = RGB_color(153);
        titleLabel.font = FONT_9_REGULAR(15);
        titleLabel.edgInsets = UIEdgeInsetsMake(11, 0, 0, 0);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [itemView addSubview:titleLabel];
        
        LLabel *contentLabel = [[LLabel alloc] initWithFrame:CGRectMake(0, 26, itemWidth, 36)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.font = FONT_9_BOLD(15);
        contentLabel.edgInsets = UIEdgeInsetsMake(6, 0, 15, 0);
        contentLabel.textColor = RGB_color(51);
        if (i == 0) {
            contentLabel.text = [self formatterWithContent:limit[@"bxdredsy"]];
        }else if (i == 1){
            contentLabel.text = [self formatterWithContent:limit[@"nxdredsy"]];
        }else if (i == 2){
            contentLabel.text = [self formatterWithContent:limit[@"sgtdredsy"]];
        }else if (i == 3){
            contentLabel.text = [self formatterWithContent:limit[@"ggtszdredsy"]];
        }
        [itemView addSubview:contentLabel];
        if (i == 2) {//i == 1 || i == 3 ||
            [UIView setBorderWithView:itemView top:NO left:YES bottom:NO right:NO borderColor:SECTION_UNDERLINE_COLOR borderWidth:0.5 borderHeight:30];
        }
    }
    
    
    UIView *setView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 184, SCREEN_WIDTH, 9)];
    setView1.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    [headerView addSubview:setView1];
    self.listTableView.tableHeaderView = model.count ? headerView :nil;
    
}

-(NSString *)formatterWithContent:(NSString *)str{
    float value = [str floatValue]/10000;
    return [NSString stringWithFormat:@"%.2f亿",value];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.totalArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OCTableModel *model = self.totalArray[section];
    if (section == 4) {
        return model.opened ? [model.listArray count] + 1: 0;
    }
    return model.opened ? [model.listArray count] : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < 4) {
        static NSString *iden = @"cell-id";
        HBHSListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[HBHSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        if (indexPath.section == 2 || indexPath.section == 3) {
            cell.showIcon = YES;
        }else{
            cell.showIcon = NO;
        }
        cell.price_textAlignment = NSTextAlignmentRight;
        OCTableModel *model = self.totalArray[indexPath.section];
        NSArray *aaArray = model.listArray;
        HBHQModel *fmodel = aaArray[indexPath.row];
        cell.hqModel = fmodel;
        cell.zxj_colorful = NO;
        return cell;
    }
    
    if (indexPath.row == 0) {
        static NSString *iden = @"cell_section";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        CGFloat width = SCREEN_WIDTH/4;
        NSArray *titlesArray = @[@"股票名称",@"H股(延)",@"A股",@"溢价(H/A)"];
        for (int i = 0; i < titlesArray.count; i++) {
            LLabel *label = [[LLabel alloc] init];
            label.text = titlesArray[i];
            label.textAlignment = NSTextAlignmentRight;
            if (i == 0) {
                label.edgInsets = UIEdgeInsetsMake(0, MARKET_SPACING, 0, 0);
                label.textAlignment = NSTextAlignmentLeft;
            }else if (i == 3){
                label.edgInsets = UIEdgeInsetsMake(0, 0, 0, MARKET_SPACING);
            }
            label.frame = CGRectMake(width*i, 0, width, 35);
            label.font = FONT_9_MEDIUM(STOCK_SECTION_HEADER_TITLEFONT);
            label.textColor = STOCK_SECTION_HEADER_TITLECOLOR;
            [cell.contentView addSubview:label];
            if (i == 3) {
                [label mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(0);
                    make.right.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(width, 35));
                }];
            }
        }
        return cell;
    }
    static NSString *iden = @"cell-ah";
    HBGGTCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[HBGGTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    OCTableModel *model = self.totalArray[indexPath.section];
    NSArray *aaArray = model.listArray;
    HBGGTModel *gmodel = aaArray[indexPath.row-1];
    cell.model = gmodel;
    return cell;

}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.totalArray) {
        static NSString *headerID = @"headerID";
        OCTableViewHeaderView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
        if (!sectionView) {
            sectionView = [[OCTableViewHeaderView alloc] initWithReuseIdentifier:headerID];
        }
        sectionView.model = self.totalArray[section];
        sectionView.sectionTag = section;
        sectionView.showDetailView = NO;
        sectionView.headerMoreClick = ^(NSInteger tag) {
            NSLog(@"tag = %ld",tag);
            
            HBGGTViewController2 *ggtVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBGGTViewController2"];
            if (tag == 0) {
                ggtVC.urlString = GGT_HGT_URL;
                ggtVC.title1 = @"沪股通";
            }else if (tag == 1) {
                ggtVC.urlString = GGT_SGT_URL;
                ggtVC.title1 = @"深股通";
            }else if (tag == 2) {
                ggtVC.urlString = GGT_GGT_H_URL;
                ggtVC.title1 = @"港股通(沪)";
                ggtVC.isShowFlag = YES;
            }else if (tag == 3) {
                ggtVC.urlString = GGT_GGT_S_URL;
                ggtVC.title1 = @"港股通(深)";
                ggtVC.isShowFlag = YES;
            }else if (tag == 4) {
                ggtVC.urlString = GGT_AH_URL;
                ggtVC.title1 = @"AH股";
                ggtVC.IS_AHStock = YES;
            }
            [ggtVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:ggtVC animated:YES];
        };
        sectionView.headerSectionClick = ^{
            NSString *replaceString = [self.O_CArray[section] isEqualToString:@"1"] ? @"0" : @"1";
            [self.O_CArray replaceObjectAtIndex:section withObject:replaceString];
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
            [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            //            [self.listTableView reloadData];
        };
        return sectionView;
        
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return STOCK_ZDSECTION_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4 && indexPath.row == 0) {
        return 35;
    }
    return STOCK_CELL_HEIGHT_2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4 && indexPath.row == 0) {
        return;
    }
    HBStockInfoViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    OCTableModel *model = self.totalArray[indexPath.section];
    NSArray *aaArray = model.listArray;
    if (indexPath.section == 4) {
        HBGGTModel *gmodel = aaArray[indexPath.row-1];
        detailVC.code = gmodel.acode;
        detailVC.stockName = gmodel.hname;
    }else{
        HBHQModel *fmodel = aaArray[indexPath.row];
        detailVC.code = fmodel.code;
        detailVC.stockName = fmodel.name;
    }
    [detailVC setHidesBottomBarWhenPushed:YES];
    [[self superViewController:self].navigationController pushViewController:detailVC animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.totalArray.count - 1 ? 0.01 : 9;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
