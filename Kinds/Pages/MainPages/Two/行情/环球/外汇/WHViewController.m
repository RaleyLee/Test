//
//  WHViewController.m
//  WBAPP
//
//  Created by hibor on 2018/4/26.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "WHViewController.h"
#import "ZHDetailCell.h"
#import "HBStockInfoViewController.h"
#import "HeaderSectionView.h"
@class HBListModel;

@interface WHViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation WHViewController

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

\
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof (self) weakSelf = self;
    self.title = @"外汇市场";
    
    if (REFRESH_WAY_LOADING) {
        [self setRefreshButtonAnimationWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }else{
        [self setRefreshButtonWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }


    self.titleArray = [NSMutableArray arrayWithObjects:@"名称代码",@"最新价",@"涨跌额",nil];

    self.listTableView.estimatedSectionHeaderHeight = STOCK_SECTION_HEADER_HEIGHT;
    self.listTableView.estimatedRowHeight =STOCK_CELL_HEIGHT_2;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.listTableView.mj_header beginRefreshing];
    
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.listTableView reloadData];
}
-(void)loadData{
    

    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];

    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    __weak typeof (self) weakSelf = self;
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:self.requestURLString isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];

        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
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

        NSArray *dataArray = [jsonData objectForKey:@"data"];
        for (NSDictionary *dd in dataArray) {
            HBListModel *model = [HBListModel mj_objectWithKeyValues:dd];
            [self.dataSourceArray addObject:model];
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
    static NSString *iden = @"cell_id";
    ZHDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[ZHDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.isWaiHui = YES;
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
    infoVC.stockName = model.name;
    infoVC.code = model.code;
    [self.navigationController pushViewController:infoVC animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderSectionView *header = [[HeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STOCK_SECTION_HEADER_HEIGHT) withTitleArray:self.titleArray canTouchIndex:888 isUPDown:NO withBlock:nil];
    
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STOCK_SECTION_HEADER_HEIGHT;
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
