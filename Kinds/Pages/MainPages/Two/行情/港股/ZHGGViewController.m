//
//  ZHGGViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHGGViewController.h"

#import "HBHSListCell.h"
#import "OCTableModel.h"
#import "OCTableViewHeaderView.h"

#import "HBStockInfoViewController.h"
#import "ZHDetailViewController.h"

#import "HBMoreHYViewController.h"
#import "HBMoreBangViewController.h"

#import "HBMarketItemView.h"

@interface ZHGGViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;


@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSArray *keysArray;
@property(nonatomic,strong)NSArray *titlesArray;
@property(nonatomic,strong)NSMutableArray *gzsArray;
@property(nonatomic,strong)NSMutableArray *O_CArray;

@end

@implementation ZHGGViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self tableViewHeaderWithArray:self.gzsArray];
    
    [self.listTableView reloadData];
}

-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    
    if (@available(iOS 11.0, *)) {
        if (IS_IPHONEX) {
            UIEdgeInsets  safeArea  =  self.view.safeAreaInsets;
            NSLog(@"safeArea:%@",NSStringFromUIEdgeInsets(safeArea));
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
    // Do any additional setup after loading the view.
    
    self.O_CArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    self.dataSourceArray = [NSMutableArray array];
    
    self.keysArray = @[@"hk_industry_list",@"main_all_desc",@"main_all_asc",@"main_all_amount_desc",@"gem_all_desc",@"gem_all_asc",@"gem_all_amount_desc",@"warrant_all_desc",@"niuxiong_all_desc"];
    self.titlesArray = @[@"热门行业",@"主板涨幅榜",@"主板跌幅榜",@"主板成交额榜",@"创业板涨幅榜",@"创业板跌幅榜",@"创业板成交额榜",@"认股证成交额榜",@"牛股证成交额榜",@"牛熊证成交额榜"];
    
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
        [weakSelf loadData];
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.firstAppear) {
        [self loadData];
        self.firstAppear = YES;
    }
}

-(void)tableViewHeaderWithArray:(NSArray *)model{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.bounds.size.width, 94)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat width = (headerView.bounds.size.width-MARKET_SPACING*2)/3;
    for (int i = 0; i < model.count; i++) {
        int row = i / 3;
        int col = i % 3;
        
        HBMarketItemView *marketView = [[HBMarketItemView alloc] initWithFrame:CGRectMake(MARKET_SPACING+width*col, 85*row, width, 85) withItemType:MarketItemTypeTop];
        marketView.listModel = model[i];
        marketView.clickItemBlock = ^(id model) {
            HBStockInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
            HBListModel *m = (HBListModel *)model;
            infoVC.code = m.code;
            infoVC.stockName = m.name;
            [infoVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:infoVC animated:YES];
        };
        if (i == 1) {
            [UIView setBorderWithView:marketView top:NO left:YES bottom:NO right:YES borderColor:SECTION_UNDERLINE_COLOR borderWidth:0.5 borderHeight:50];
        }
        [headerView addSubview:marketView];
        
    }
    UIView *setView = [[UIView alloc] initWithFrame:CGRectMake(0, 85, SCREEN_WIDTH, 9)];
    setView.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    [headerView addSubview:setView];
    self.listTableView.tableHeaderView = model.count ? headerView : nil;
}

-(void)loadData{
    
    __weak typeof (self) weakSelf = self;
    
    NSMutableArray *tempFArray = [NSMutableArray array];
    
    [[HUDHelper sharedHUDHelper] showLoadingHudWithMessage:nil withView:self.view];
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:GG_HOME_URL isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        
    }failuare:^(NSError *error){
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        
    } success:^(id jsonData) {
        self.dataSourceArray = [NSMutableArray array];
        self.gzsArray = [NSMutableArray array];
        ///////
        NSArray *tempZsArray = jsonData[@"data"][@"zs"];
        for (NSDictionary *dict in tempZsArray) {
            HBListModel *model = [HBListModel mj_objectWithKeyValues:dict];
            [self.gzsArray addObject:model];
        }
        [self tableViewHeaderWithArray:self.gzsArray];
        
        
        NSDictionary *tempDict = [jsonData objectForKey:@"data"];
        
        for (int i = 0; i < self.keysArray.count; i++) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dict in tempDict[self.keysArray[i]]) {
                if ([self.keysArray[i] isEqualToString:@"hk_industry_list"]) {
                    GangTModel *model = [GangTModel mj_objectWithKeyValues:dict];
                    [tempArray addObject:model];
                }else{
                    GangModel *model = [GangModel mj_objectWithKeyValues:dict];
                    [tempArray addObject:model];
                }
            }
            [tempFArray addObject:tempArray];
        }
        
        for (int i = 0; i < tempFArray.count; i++) {
            OCTableModel *model = [[OCTableModel alloc] init];
            model.headTitle = self.titlesArray[i];
            model.listArray = tempFArray[i];
            model.opened = [self.O_CArray[i] isEqualToString:@"1"] ? YES : NO;
            [self.dataSourceArray addObject:model];
            
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OCTableModel *model = self.dataSourceArray[section];
    if (section == 0) {
        return model.opened ? 1 : 0;
    }
    return model.opened ?[model.listArray count] : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        static NSString *cellID = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        if (self.dataSourceArray.count) {
            OCTableModel *model = self.dataSourceArray[indexPath.section];
            NSArray *aaArray = model.listArray;
            CGFloat width = (tableView.bounds.size.width-MARKET_SPACING*2)/3;
            NSMutableArray *itemArray = [NSMutableArray array];
            for (int i = 0; i < aaArray.count; i++) {
                int row = i / 3;
                int col = i % 3;
                
                GangTModel *tempModel = aaArray[i];
                
                HBMarketItemView *marketView = [[HBMarketItemView alloc] initWithFrame:CGRectMake(MARKET_SPACING+width*col, 85*row, width, 85) withItemType:MarketItemTypeMiddle];
                marketView.gTModel = tempModel;
                __weak typeof (self) weakSelf = self;
                marketView.clickItemBlock = ^(id model) {
                    GangTModel *mode1 = (GangTModel *)model;
                    [weakSelf pushAction:mode1];
                };
                
                [cell.contentView addSubview:marketView];
                [itemArray addObject:marketView];
                
            }
            [UIView setBorderWithViews:itemArray columuns:3 borderColor:SECTION_UNDERLINE_COLOR];
            
        }
        return cell;
    }else {
        
        static NSString *cellID = @"cell_id";
        HBHSListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[HBHSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.price_textAlignment = NSTextAlignmentRight;
        cell.showIcon = YES;
        if (self.dataSourceArray.count) {
            OCTableModel *model = self.dataSourceArray[indexPath.section];
            NSArray *aaArray = model.listArray;
            GangModel *fmodel = aaArray[indexPath.row];
            cell.gModel = fmodel;
        }
        
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.dataSourceArray.count > 0) {
        static NSString *headerID = @"headerID";
        OCTableViewHeaderView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
        if (!sectionView) {
            sectionView = [[OCTableViewHeaderView alloc] initWithReuseIdentifier:headerID];
        }
        sectionView.model = self.dataSourceArray[section];
        sectionView.sectionTag = section;
        sectionView.showDetailView = NO;
        sectionView.headerMoreClick = ^(NSInteger tag) {
            NSLog(@"tag = %ld",tag);
            if (tag == 0) {
                HBMoreHYViewController *hyVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBMoreHYViewController"];
                [hyVC setHidesBottomBarWhenPushed:YES];
                [[self superViewController:self].navigationController pushViewController:hyVC animated:YES];
            }else{
                HBMoreBangViewController *bangVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBMoreBangViewController"];
                bangVC.tableTitle = self.titlesArray[section];
                bangVC.urlIndex = section-1;
                OCTableModel *model = self.dataSourceArray[section];
                bangVC.otherTitle = [model.headTitle rangeOfString:@"涨幅"].length?@"涨幅":([model.headTitle rangeOfString:@"跌幅"].length?@"跌幅":@"成交额");
                [bangVC setHidesBottomBarWhenPushed:YES];
                [[self superViewController:self].navigationController pushViewController:bangVC animated:YES];
            }
        };
        sectionView.headerSectionClick = ^{
            NSString *replaceString = [self.O_CArray[section] isEqualToString:@"1"] ? @"0" : @"1";
            [self.O_CArray replaceObjectAtIndex:section withObject:replaceString];
            NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
            [CATransaction begin];
            [CATransaction setCompletionBlock:^{
                [self.listTableView reloadData];
            }];
            [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
            [CATransaction commit];
            NSLog(@"%lf",tableView.contentOffset.y);
            if (tableView.contentOffset.y < 0 ) {
                [tableView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
            
        };
        return sectionView;
        
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return  185;
    }
    return STOCK_CELL_HEIGHT_2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return STOCK_ZDSECTION_HEIGHT;
}

-(void)pushAction:(GangTModel *)model{
    ZHDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHDetailViewController"];
    detailVC.code = model.bd_code;
    detailVC.titleName = model.bd_name;
    detailVC.itemType = StockItemTypeGG;
    [detailVC setHidesBottomBarWhenPushed:YES];
    [[self superViewController:self].navigationController pushViewController:detailVC animated:YES];
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.dataSourceArray.count - 1 ? 0.01 : 9;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return;
    }
    HBStockInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    OCTableModel *model = self.dataSourceArray[indexPath.section];
    NSArray *aaArray = model.listArray;
    GangModel *fmodel = aaArray[indexPath.row];
    infoVC.stockName = fmodel.name;
    infoVC.code = fmodel.code;
    [infoVC setHidesBottomBarWhenPushed:YES];
    [[self superViewController:self].navigationController pushViewController:infoVC animated:YES];
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
