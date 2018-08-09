//
//  HBGGTViewController2.m
//  WBAPP
//
//  Created by hibor on 2018/5/4.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBGGTViewController2.h"
#import "HeaderSectionView.h"

@interface HBGGTViewController2 ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *headTitleArray;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,assign)BOOL is_UP_DOWN;

@end

@implementation HBGGTViewController2

-(void)viewSafeAreaInsetsDidChange{
    [super viewSafeAreaInsetsDidChange];
    if (@available(iOS 11.0,*)) {
        if (IS_IPHONEX) {
            UIEdgeInsets edge = self.view.safeAreaInsets;
            self.tableview_LeftLayout.constant = edge.left;
            self.tableview_RightLayout.constant = edge.right;
        }
    }
}



-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.listTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof (self) weakSelf = self;

    self.title = self.title1;
    
    if (REFRESH_WAY_LOADING) {
        [self setRefreshButtonAnimationWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }else{
        [self setRefreshButtonWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }
    
    
    self.is_UP_DOWN = YES;
    self.urlString = [NSString stringWithFormat:self.urlString,self.is_UP_DOWN?@"desc":@"asc"];
    
    if (self.IS_AHStock) {
        self.headTitleArray = [NSMutableArray arrayWithObjects:@"股票名称",@"H股(延)",@"A股",@"溢价(H/A)", nil];//↓
    }else{
        self.headTitleArray = [NSMutableArray arrayWithObjects:@"名称代码",@"最新价",@"跌幅", nil];//↓
    }
    

//    self.listTableView.backgroundColor = TABLEVIE_BACKGROUNDCOLOR;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.listTableView.mj_header beginRefreshing];
//    [self loadData];
}

-(void)loadData{
    

    __weak typeof (self) weakSelf = self;
    [[HUDHelper sharedHUDHelper] showLoadingHudWithMessage:nil withView:self.view];

    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:self.urlString isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];

        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
    } failuare:^(NSError *error){
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];

        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
    } success:^(id jsonData) {
        self.dataSourceArray = [NSMutableArray array];
        if (self.IS_AHStock) {
            NSArray *array = jsonData[@"data"][@"data"];
            for (NSDictionary *dict in array) {
                HBGGTModel *model = [HBGGTModel mj_objectWithKeyValues:dict];
                [self.dataSourceArray addObject:model];
            }
        }else{
            NSArray *array = jsonData[@"data"];
            for (NSDictionary *dict in array) {
                HBGGTModel2 *model = [HBGGTModel2 mj_objectWithKeyValues:dict];
//                HBHQModel *model = [HBHQModel mj_objectWithKeyValues:dict];
                [self.dataSourceArray addObject:model];
            }
        }
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];

        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.IS_AHStock) {
        static NSString *iden = @"cell-ah";
        HBGGTCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[HBGGTCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        HBGGTModel *gmodel = self.dataSourceArray[indexPath.row];
        cell.model = gmodel;
        return cell;
    }
    static NSString *iden = @"cell_ggt";
    HBGGTCell2 *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[HBGGTCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.isShowFlag = self.isShowFlag;
    HBGGTModel2 *model = self.dataSourceArray[indexPath.row];
    cell.model2 = model;
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STOCK_CELL_HEIGHT_2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HBStockInfoViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    if (self.IS_AHStock) {
        HBGGTModel *gmodel = self.dataSourceArray[indexPath.row];
        detailVC.code = gmodel.acode;
        detailVC.stockName = gmodel.hname;
    }else{
        HBGGTModel2 *model = self.dataSourceArray[indexPath.row];
        detailVC.code = model.code;
        detailVC.stockName = model.name;
    }
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderSectionView *header = [[HeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STOCK_SECTION_HEADER_HEIGHT) withTitleArray:self.headTitleArray canTouchIndex:self.headTitleArray.count -1 isUPDown:self.is_UP_DOWN withBlock:^(BOOL hasNetWork){
        [self sortCurrent];
    }];
    header.isAhStock = self.IS_AHStock;
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STOCK_SECTION_HEADER_HEIGHT;
}
-(void)sortCurrent{
    self.is_UP_DOWN = !self.is_UP_DOWN;
    if (!self.is_UP_DOWN) {
        if ([self.urlString rangeOfString:@"order=desc"].length) {
            self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@"order=desc" withString:@"order=asc"];
        }
    }else{
        if ([self.urlString rangeOfString:@"order=asc"].length) {
            self.urlString = [self.urlString stringByReplacingOccurrencesOfString:@"order=asc" withString:@"order=desc"];
        }
    }
    [self loadData];
    
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
