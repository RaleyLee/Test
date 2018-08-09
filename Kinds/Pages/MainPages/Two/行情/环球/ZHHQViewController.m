//
//  ZHHQViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHHQViewController.h"

#import "OCTableModel.h"
#import "QiuCell.h"
#import "OCTableViewHeaderView.h"

#import "FDetailViewController.h"
#import "WHViewController.h"

@interface ZHHQViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSArray *titlesArray,*keysArray;
@property(nonatomic,strong)NSMutableArray *O_CArray;

@end

@implementation ZHHQViewController

-(void)changeRotateHS:(NSNotification *)noti{
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
    [self.listTableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotateHS:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    self.O_CArray = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1", nil];
    
    self.dataSourceArray = [NSMutableArray array];
    
    self.titlesArray = @[@"常用",@"环球股票指数",@"环球大宗商品",@"外汇",@"人民币牌价"];
    self.keysArray = @[@"common",@"index",@"future",@"exchange",@"rmbrate"];
    
    self.listTableView.estimatedSectionHeaderHeight = STOCK_ZDSECTION_HEIGHT;
    self.listTableView.estimatedRowHeight =STOCK_CELL_HEIGHT_1;
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

-(void)loadData{
    
    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];
    
    __weak typeof (self) weakSelf = self;
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:HQ_HOME_URL isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
    } failuare:^(NSError *error){
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
    } success:^(id jsonData) {
        self.dataSourceArray = [NSMutableArray array];
        
        NSDictionary *tempDict = jsonData[@"data"];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (int i = 0; i < self.keysArray.count; i++) {
            NSMutableArray *tArray = [NSMutableArray array];
            for (NSDictionary *dict in tempDict[self.keysArray[i]]) {
                QiuModel *model = [QiuModel mj_objectWithKeyValues:dict];
                [tArray addObject:model];
            }
            [tempArray addObject:tArray];
        }
        
        for (int i = 0; i < tempArray.count; i++) {
            OCTableModel *model = [[OCTableModel alloc] init];
            model.headTitle = self.titlesArray[i];
            model.listArray = tempArray[i];
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
    
    return model.opened ? ((section == 4)?[model.listArray count]+1:[model.listArray count] ): 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            static NSString *he = @"header";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:he];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:he];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in [cell.contentView subviews]) {
                [view removeFromSuperview];
            }
            NSArray *headerArray = @[@"种类",@"现汇买入价",@"现钞买入价"];
            for (int i = 0; i < headerArray.count; i++) {
                UILabel *label = [[UILabel alloc] init];
                label.text = headerArray[i];
                label.font = FONT_9_MEDIUM(STOCK_SECTION_HEADER_TITLEFONT);
                label.textColor = STOCK_SECTION_HEADER_TITLECOLOR;
                if (i == 0) {
                    label.frame = CGRectMake(MARKET_SPACING, 0, HBWIDTH_SIDE-MARKET_SPACING, 35);
                    label.textAlignment = NSTextAlignmentLeft;
                }else if (i == 2){
                    label.frame = CGRectMake(SCREEN_WIDTH-HBWIDTH_SIDE, 0, HBWIDTH_SIDE-MARKET_SPACING, 35);
                    label.textAlignment = NSTextAlignmentRight;
                }else{
                    label.frame = CGRectMake(HBWIDTH_SIDE, 0, HBWIDTH_MIDDLE, 35);
                    label.textAlignment = NSTextAlignmentRight;
                }
                label.tag = 1600+i;
                [cell.contentView addSubview:label];
                if (i == 2) {
                    [label mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.right.mas_equalTo(-MARKET_SPACING);
                        make.width.mas_equalTo(HBWIDTH_SIDE-MARKET_SPACING);
                        make.top.mas_equalTo(0);
                        make.height.mas_equalTo(35);
                    }];
                }
            }
            return cell;
        }
        
    }
    static NSString *cellID = @"cell_id";
    QiuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[QiuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    if (self.dataSourceArray.count) {
        cell.showFlagIcon = YES;
        OCTableModel *model = self.dataSourceArray[indexPath.section];
        NSArray *aaArray = model.listArray;
        if (indexPath.section == 4) {
            QiuModel *fmodel = aaArray[indexPath.row-1];
            cell.model = fmodel;
        }else{
            QiuModel *fmodel = aaArray[indexPath.row];
            cell.model = fmodel;
        }
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            return 35;
        }
    }
    return STOCK_CELL_HEIGHT_1;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    static NSString *headerID = @"headerID";
    OCTableViewHeaderView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerID];
    if (!sectionView) {
        sectionView = [[OCTableViewHeaderView alloc] initWithReuseIdentifier:headerID];
    }
    sectionView.model = self.dataSourceArray[section];
    sectionView.sectionTag = section;
    sectionView.showDetailView = NO;
    if (section == 0 || section == 4) {
        sectionView.hiddenMoreButton = YES;
    }
    sectionView.headerMoreClick = ^(NSInteger tag) {
        if (tag == 1) {
            FDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"FDetailViewController"];
            detailVC.titleName = @"环球股票指数";
            detailVC.requestURLString = HQ_STOCK_URL;
            detailVC.keysArray = @[@"america",@"europe",@"asia",@"other"];
            detailVC.titlesArray = @[@"美洲指数",@"欧洲指数",@"亚洲指数",@"其他指数"];
            [detailVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:detailVC animated:YES];
        }else if (tag == 2) {
            FDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"FDetailViewController"];
            detailVC.titleName = @"环球大宗商品";
            detailVC.requestURLString = HQ_DZ_URL;
            detailVC.keysArray = @[@"preciousMetal",@"basicMetal",@"energy",@"agriculture"];
            detailVC.titlesArray = @[@"贵金属",@"基本金属",@"能源化工",@"农产品"];
            [detailVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:detailVC animated:YES];
        }else if (tag == 3){
            WHViewController *whVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"WHViewController"];
            whVC.requestURLString = HQ_WH_URL;
            [whVC setHidesBottomBarWhenPushed:YES];
            [[self superViewController:self].navigationController pushViewController:whVC animated:YES];
        }
    };
    sectionView.headerSectionClick = ^{
        NSString *replaceString = [self.O_CArray[section] isEqualToString:@"1"] ? @"0" : @"1";
        [self.O_CArray replaceObjectAtIndex:section withObject:replaceString];
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:section];
        [self.listTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    };
    return sectionView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return STOCK_ZDSECTION_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == self.dataSourceArray.count - 1 ? 0.01 : 9;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
