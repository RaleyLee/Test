//
//  ZHDetailViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHDetailViewController.h"
#import "HBStockInfoViewController.h"
#import "HeaderSectionView.h"

@interface ZHDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSString *currentURL;
}

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,assign)BOOL UP_DOWN;

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@end

@implementation ZHDetailViewController

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

-(void)rotateChange{
    [self.listTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.titleName;
    __weak typeof (self) weakSelf = self;
    
    if (REFRESH_WAY_LOADING) {
        [self setRefreshButtonAnimationWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }else{
        [self setRefreshButtonWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }
    _UP_DOWN = YES;
    if (self.itemType == StockItemTypeGG) {
        currentURL = [NSString stringWithFormat:GG_ITEM_URL,self.code,_UP_DOWN?@"desc":@"asc"];
    }else if (self.itemType == StockItemTypeHS){
        currentURL = [NSString stringWithFormat:HS_ITEM_URL,self.code,_UP_DOWN?@"0":@"1"];
    }
    NSLog(@"url = %@",currentURL);
    self.titleArray = [NSMutableArray arrayWithObjects:@"名称代码",@"最新价",@"跌涨幅", nil];//↓
    self.dataSourceArray = [NSMutableArray array];
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadContentData];
    }];
    [self.listTableView.mj_header beginRefreshing];
}

-(void)loadContentData{
    
    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    [[HUDHelper sharedHUDHelper] showLoadingHudWithMessage:@"加载中" withView:self.view];
    
    __weak typeof (self) weakSelf = self;
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:currentURL isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadContentData];
        }];
        
    } failuare:^(NSError *error){
        [weakSelf.listTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:@"获取失败" withView:self.view];
        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadContentData];
        }];
        
    } success:^(id jsonData) {
        NSArray *tempArray = jsonData[@"data"];
        if (tempArray.count > 0) {
            self.dataSourceArray = [NSMutableArray array];
            for (NSDictionary *dic in tempArray) {
                HBListModel *model = [HBListModel mj_objectWithKeyValues:dic];
                [self.dataSourceArray addObject:model];
            }
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadContentData];
        }];
        
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];
        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell_id";
    ZHDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ZHDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    if (self.itemType == StockItemTypeGG) {
        cell.showIcon = YES;
    }
    HBListModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STOCK_CELL_HEIGHT_2;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBStockInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    HBListModel *model = self.dataSourceArray[indexPath.row];
    infoVC.code = model.code;
    infoVC.stockName = model.name;
    [self.navigationController pushViewController:infoVC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderSectionView *header = [[HeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STOCK_SECTION_HEADER_HEIGHT) withTitleArray:self.titleArray canTouchIndex:2 isUPDown:self.UP_DOWN withBlock:^(BOOL hasNetWork){
        [self sort];
    }];
    return header;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STOCK_SECTION_HEADER_HEIGHT;
}

-(void)sort{
    
    self.UP_DOWN = !self.UP_DOWN;
    
    if (self.itemType == StockItemTypeGG) {
        if ([currentURL rangeOfString:@"s=desc"].length) {
            currentURL = [currentURL stringByReplacingOccurrencesOfString:@"s=desc" withString:@"s=asc"];
        }else if ([currentURL rangeOfString:@"s=asc"].length){
            currentURL = [currentURL stringByReplacingOccurrencesOfString:@"s=asc" withString:@"s=desc"];
        }
    }else if (self.itemType == StockItemTypeHS){
        if ([currentURL rangeOfString:@"o=0"].length) {
            currentURL = [currentURL stringByReplacingOccurrencesOfString:@"o=0" withString:@"o=1"];
        }else if ([currentURL rangeOfString:@"o=1"].length){
            currentURL = [currentURL stringByReplacingOccurrencesOfString:@"o=1" withString:@"o=0"];
        }
    }
    
    [self loadContentData];
    
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
