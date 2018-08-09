//
//  ZHHSViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHHSViewController.h"

#import "OCTableModel.h"
#import "OCTableViewHeaderView.h"
#import "OCTableViewSectionView.h"

#import "HBMarketItemView.h"

#import "StockFormViewController.h"
#import "ZHDetailViewController.h"
#import "ZHMoreBlankViewController.h"
#import "HBStockInfoViewController.h"


@interface ZHHSViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;


@property(nonatomic,strong)NSMutableArray *totalArray;
@property(nonatomic,copy)NSString *requestURLString;

@property(nonatomic,strong)NSMutableArray *zsArray;
@property(nonatomic,strong)NSMutableArray *O_CArray;

@property(nonatomic,strong)NSArray *scrollTitleArray;
@property(nonatomic,strong)NSMutableArray *detailTitleArray;
@property(nonatomic,strong)UIScrollView *detailScrollView;

@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,copy)NSString *key_display;

@property(nonatomic,assign)NSInteger tempSelectedIndex;
@property(nonatomic,copy)NSString *tempRequestURL;
@property(nonatomic,strong)NSMutableArray *tempArray;

@end

@implementation ZHHSViewController


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self tableViewHeaderWithArray:self.zsArray];
    [self.listTableView reloadData];
}
-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    
    if (@available(iOS 11.0, *)) {
        if (IS_IPHONEX) {
            UIEdgeInsets  safeArea  =  self.view.safeAreaInsets;
            self.tableview_LeftLayout.constant = safeArea.left;
            self.tableview_RightLayout.constant = safeArea.right;
        }
    }
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    self.key_display = @"zdf";
    
    self.O_CArray = [NSMutableArray arrayWithObjects:@"1",@"1", nil];
    
    self.requestURLString = HS_HOME_ZDF_URL;
    
    //暂存
    self.tempSelectedIndex = self.selectedIndex;
    self.tempRequestURL = self.requestURLString;
    
    self.scrollTitleArray = @[
                              @{@"title":@"涨幅榜",@"detailTitle":@"涨幅",@"requestURL":HS_HOME_ZDF_URL},
                              @{@"title":@"跌幅榜",@"detailTitle":@"跌幅",@"requestURL":HS_HOME_DF_URL},
                              @{@"title":@"换手榜",@"detailTitle":@"换手率",@"requestURL":HS_HOME_HSL_URL},
                              @{@"title":@"涨速榜",@"detailTitle":@"5分钟涨速",@"requestURL":HS_HOME_ZS_URL},
                              @{@"title":@"振幅榜",@"detailTitle":@"振幅",@"requestURL":HS_HOME_ZF_URL},
                              @{@"title":@"量比榜",@"detailTitle":@"量比",@"requestURL":HS_HOME_LB_URL}
                              ];
    self.detailTitleArray = [NSMutableArray arrayWithObjects:@"股票名称",@"最新价",@"涨幅", nil];
    self.tempArray = [NSMutableArray arrayWithObjects:@"股票名称",@"最新价",@"涨幅", nil];
    
    
    self.listTableView.estimatedSectionHeaderHeight = STOCK_ZDSECTION_HEIGHT;
    self.listTableView.estimatedRowHeight =STOCK_CELL_HEIGHT_2;
    self.listTableView.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    __weak typeof (self) weakSelf = self;
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadDataWithURL:weakSelf.requestURLString];
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.firstAppear) {
        [self loadDataWithURL:self.requestURLString];
        self.firstAppear = YES;
    }
}
-(void)loadDataWithURL:(NSString *)requestURL{
    
    __weak typeof (self) weakSelf = self;
    
    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:requestURL isHaveNetWork:^ {
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.totalArray.count reloadButtonBlock:^{
            [weakSelf loadDataWithURL:requestURL];
        }];
    } failuare:^(NSError *error){
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.totalArray.count reloadButtonBlock:^{
            [weakSelf loadDataWithURL:requestURL];
        }];
    } success:^(id jsonData) {
        self.requestURLString = requestURL;
        self.selectedIndex = self.tempSelectedIndex;
        self.detailTitleArray = self.tempArray;
        
        self.totalArray = [NSMutableArray array];
        self.zsArray = [NSMutableArray array];
        
        //加载头部的数据--Item
        NSArray *tempZsArray = jsonData[@"data"][@"zs"];
        for (NSDictionary *dict in tempZsArray) {
            HBListModel *model = [HBListModel mj_objectWithKeyValues:dict];
            [self.zsArray addObject:model];
        }
        [self tableViewHeaderWithArray:self.zsArray];
        
        //加载热门板块的数据--Item
        NSArray *tempAveratioArray = jsonData[@"data"][@"averatio/0"];
        NSMutableArray *averatioArray = [NSMutableArray array];
        for (NSDictionary *dict in tempAveratioArray) {
            HBItemModel *model = [HBItemModel mj_objectWithKeyValues:dict];
            [averatioArray addObject:model];
        }
        
        //加载热门榜单--List
        NSArray *tempDataArray = jsonData[@"data"][@"data"];
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in tempDataArray) {
            HBListModel *model = [HBListModel mj_objectWithKeyValues:dict];
            [dataArray addObject:model];
        }
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithObjects:
                                     @{@"headTitle":@"热门板块",@"listArray":averatioArray},
                                     @{@"headTitle":@"热门榜单",@"listArray":dataArray}, nil];
        
        for (int i = 0 ; i < tempArray.count; i++) {
            NSDictionary *dict = tempArray[i];
            OCTableModel *model = [[OCTableModel alloc] init];
            model.headTitle = dict[@"headTitle"];
            model.listArray = dict[@"listArray"];
            model.opened = [self.O_CArray[i] isEqualToString:@"1"] ? YES : NO;
            [self.totalArray addObject:model];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.totalArray.count reloadButtonBlock:^{
            [weakSelf loadDataWithURL:requestURL];
        }];
        
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSUInteger sectionNumber = [weakSelf.listTableView indexPathForCell:weakSelf.listTableView.visibleCells.firstObject].section;
            NSLog(@"sectionNumber = %zd",sectionNumber);
            if (sectionNumber == 1) {
                [weakSelf.listTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        });
        
    }];
    
}

#pragma mark - 显示指数的Item

-(void)tableViewHeaderWithArray:(NSArray *)model{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.bounds.size.width, 179)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat width = (headerView.bounds.size.width-(MARKET_SPACING*2))/3;
    for (int i = 0; i < model.count; i++) {
        int row = i / 3;
        int col = i % 3;
        HBListModel *tempModel = model[i];
        
        
        HBMarketItemView *marketView = [[HBMarketItemView alloc] initWithFrame:CGRectMake(MARKET_SPACING+width*col, 85*row, width, 85) withItemType:MarketItemTypeTop];
        marketView.listModel = tempModel;
        marketView.clickItemBlock = ^(id model) {
            //响应点击事件 跳转到股票详情页面
            HBStockInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
            infoVC.code = tempModel.code;
            infoVC.stockName = tempModel.name;
            [infoVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:infoVC animated:YES];
        };
        if (i > 2) {
            [UIView setBorderWithView:marketView top:YES left:NO bottom:NO right:NO borderColor:SECTION_UNDERLINE_COLOR borderWidth:marketView.frame.size.width borderHeight:0.5];
        }
        if (i == 1 || i == 4) {
            [UIView setBorderWithView:marketView top:NO left:YES bottom:NO right:YES borderColor:SECTION_UNDERLINE_COLOR borderWidth:0.5 borderHeight:50];
        }
        [headerView addSubview:marketView];
        
        
    }
    UIView *setView = [[UIView alloc] initWithFrame:CGRectMake(0, 170, SCREEN_WIDTH, 9)];
    setView.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    [headerView addSubview:setView];
    self.listTableView.tableHeaderView = model.count ? headerView : nil;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.totalArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    OCTableModel *model = self.totalArray[section];
    if (section == 0) {
        return model.opened ? 1 : 0;
    }
    return model.opened ? [model.listArray count]+1 : 0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            static NSString *scrollID = @"scroll_ID";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:scrollID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:scrollID];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in [cell.contentView subviews]) {
                [view removeFromSuperview];
            }
            
            for (int i = 0; i < self.detailTitleArray.count; i++) {
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setTitle:self.detailTitleArray[i] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:STOCK_SECTION_HEADER_TITLEFONT];
                [button setTitleColor:STOCK_SECTION_HEADER_TITLECOLOR forState:UIControlStateNormal];
                if (i == 0) {
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [button setFrame:CGRectMake(MARKET_SPACING, 0, HBWIDTH_SIDE-MARKET_SPACING, 35)];
                }else if (i == 2){
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                    [button setFrame:CGRectMake(SCREEN_WIDTH-HBWIDTH_SIDE, 0, HBWIDTH_SIDE-MARKET_SPACING, 35)];
                }else{
                    [button setFrame:CGRectMake(HBWIDTH_SIDE, 0, HBWIDTH_MIDDLE, 35)];
                    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                }
                [button setTitleEdgeInsets:UIEdgeInsetsMake(8, 0, 0, 0)];
                button.tag = 600+i;
                [cell.contentView addSubview:button];
                if (i == 2) {
                    [button mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-15);
                        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
                        make.top.mas_equalTo(0);
                        make.height.mas_equalTo(35);
                    }];
                }
            }
            
            return cell;
        }
        static NSString *cellID = @"cell_id";
        HBHSListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HBHSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.price_textAlignment = NSTextAlignmentRight;
        
        if (self.selectedIndex == 0) {
            self.key_display = @"zdf";
        }else if (self.selectedIndex == 1) {
            self.key_display = @"df";
        }else if (self.selectedIndex == 2) {
            self.key_display = @"hsl";
        }else if (self.selectedIndex == 3) {
            self.key_display = @"zs";
        }else if (self.selectedIndex == 4) {
            self.key_display = @"zf";
        }else if (self.selectedIndex == 5) {
            self.key_display = @"lb";
        }
        
        if (self.totalArray.count) {
            
            OCTableModel *model = self.totalArray[indexPath.section];
            NSArray *aaArray = model.listArray;
            HBListModel *fmodel = aaArray[indexPath.row-1];
            cell.keyString = self.key_display;
            if (self.selectedIndex > 1) {
                cell.zxj_colorful = YES;
            }else{
                cell.zxj_colorful = NO;
            }
            cell.model = fmodel;
        }
        
        return cell;
        
    }else{
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        if (self.totalArray.count) {
            
            OCTableModel *model = self.totalArray[indexPath.section];
            NSArray *aaArray = model.listArray;
            CGFloat space = 15;
            CGFloat width = (tableView.bounds.size.width-30)/3;
            
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int i = 0; i < aaArray.count; i++) {
                int row = i / 3;
                int col = i % 3;
                HBItemModel *tempModel = aaArray[i];
                
                HBMarketItemView *marketView = [[HBMarketItemView alloc] initWithFrame:CGRectMake(space+width*col, 85*row, width, 85) withItemType:MarketItemTypeMiddle];
                marketView.itemModel = tempModel;
                __weak typeof (self) weakSelf = self;
                marketView.clickItemBlock = ^(id model) {
                    HBItemModel *mode1 = (HBItemModel *)model;
                    [weakSelf pushAction:mode1];
                };
                [cell.contentView addSubview:marketView];
                [itemArray addObject:marketView];
                
            }
            [UIView setBorderWithViews:itemArray columuns:3 borderColor:SECTION_UNDERLINE_COLOR];
        }
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        }else{
            cell.separatorInset = UIEdgeInsetsZero;
        }
    }
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
        }else{
            cell.separatorInset = UIEdgeInsetsZero;
        }
    }
}

-(void)pushAction:(HBItemModel *)model{
    ZHDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHDetailViewController"];
    detailVC.code = model.bd_code;
    detailVC.titleName = model.bd_name;
    detailVC.itemType = StockItemTypeHS;
    [detailVC setHidesBottomBarWhenPushed:YES];
    [[self superViewController:self].navigationController pushViewController:detailVC animated:YES];
    
}


#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.totalArray) {
        if (section == 0) {
            static NSString *headerID = @"headerID";
            OCTableViewSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
            if (!sectionView) {
                sectionView = [[OCTableViewSectionView alloc] initWithReuseIdentifier:headerID];
            }
            sectionView.model = self.totalArray[section];
            sectionView.sectionTag = section;
            sectionView.headerMoreClick = ^(NSInteger tag) {
                ZHMoreBlankViewController *hotVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHMoreBlankViewController"];
                [hotVC setHidesBottomBarWhenPushed:YES];
                [[self superViewController:self].navigationController pushViewController:hotVC animated:YES];
            };
            sectionView.headerSectionClick = ^{
                NSString *replaceString = [self.O_CArray[section] isEqualToString:@"1"] ? @"0" : @"1";
                [self.O_CArray replaceObjectAtIndex:section withObject:replaceString];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
                [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            };
            return sectionView;
        }else if (section == 1){
            static NSString *headerID = @"headerID11";
            OCTableViewHeaderView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
            if (!sectionView) {
                sectionView = [[OCTableViewHeaderView alloc] initWithReuseIdentifier:headerID];
            }
            sectionView.model = self.totalArray[section];
            sectionView.sectionTag = section;
            sectionView.showDetailView = [self.O_CArray[section] isEqualToString:@"1"];
            sectionView.selectedIndex = self.selectedIndex;
            sectionView.headerMoreClick = ^(NSInteger tag) {
                StockFormViewController *aroundVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"StockFormViewController"];
                if (self.selectedIndex == 0) {
                    (void)(aroundVC.type = @"zdf"),aroundVC.order = @"top";
                }else if (self.selectedIndex == 1){
                    (void)(aroundVC.type = @"zde"),aroundVC.order = @"bottom";
                }else if (self.selectedIndex == 2){
                    (void)(aroundVC.type = @"hsl"),aroundVC.order = @"top";
                }else if (self.selectedIndex == 3){
                    (void)(aroundVC.type = @"zs"),aroundVC.order = @"top";
                }else if (self.selectedIndex == 4){
                    (void)(aroundVC.type = @"zf"),aroundVC.order = @"top";
                }else if (self.selectedIndex == 5){
                    (void)(aroundVC.type = @"lb"),aroundVC.order = @"top";
                }
                [aroundVC setHidesBottomBarWhenPushed:YES];
                [[self superViewController:self].navigationController pushViewController:aroundVC animated:YES];
            };
            
            sectionView.headerClickDetailBangButton = ^(NSDictionary *diction,NSInteger index) {
                
                self.tempArray = [self.detailTitleArray mutableCopy];
                [self.tempArray replaceObjectAtIndex:2 withObject:diction[@"detailTitle"]];
                
                self.tempSelectedIndex = index;
                self.tempRequestURL = [NSString stringWithFormat:diction[@"requestURL"],[NSString getNowTimeTimeStamp]];
                [self loadDataWithURL:self.tempRequestURL];
            };
            sectionView.headerSectionClick = ^{
                NSString *replaceString = [self.O_CArray[section] isEqualToString:@"1"] ? @"0" : @"1";
                [self.O_CArray replaceObjectAtIndex:section withObject:replaceString];
                NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
                [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
            };
            return sectionView;
            
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return  185;
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 35;
        }
    }
    return STOCK_CELL_HEIGHT_2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if ([self.O_CArray[1] isEqualToString:@"1"]) {
            return 85;
        }
        return 45;
    }
    return STOCK_ZDSECTION_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.totalArray.count - 1 ? 0.01 : 9;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 || (indexPath.section == 1 && indexPath.section == 0)) {
        return;
    }
    OCTableModel *model = self.totalArray[indexPath.section];
    NSArray *array = model.listArray;
    HBListModel *m = array[indexPath.row-1];
    HBStockInfoViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    detailVC.code = m.code;
    detailVC.stockName = m.name;
    [detailVC setHidesBottomBarWhenPushed:YES];
    [[self superViewController:self].navigationController pushViewController:detailVC animated:YES];
    
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
