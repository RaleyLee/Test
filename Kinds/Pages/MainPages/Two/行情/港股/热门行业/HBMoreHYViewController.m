//
//  HBMoreHYViewController.m
//  HangQingNew
//
//  Created by hibor on 2018/5/23.
//  Copyright © 2018年 hibor. All rights reserved.
//



#import "HBMoreHYViewController.h"
#import "MHYCell.h"
#import "ZHDetailViewController.h"
#import "HeaderSectionView.h"


@interface HBMoreHYViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *currentURL;
}


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@property(nonatomic,strong)NSMutableArray *titlesArray;
@property(nonatomic,assign)BOOL UP_DOWN;

@end

@implementation HBMoreHYViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak typeof (self) weakSelf = self;

    self.title = @"热门行业";

    if (REFRESH_WAY_LOADING) {
        [self setRefreshButtonAnimationWithBlock:^{
            [weakSelf.listTableView.mj_header beginRefreshing];
        }];
        
    }else{
        [self setRefreshButtonWithBlock:^{
           [weakSelf.listTableView.mj_header beginRefreshing];
        }];
    }

    
    self.dataSourceArray = [NSMutableArray array];

    self.titlesArray = [NSMutableArray arrayWithObjects:@"板块名称",@"涨跌幅",@"领涨股", nil];//↓
    _UP_DOWN = YES;
    currentURL = [NSString stringWithFormat:GG_MORE_HY_URL,_UP_DOWN?@"desc":@"asc"];
    
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

    __weak typeof (self) weakSelf = self;
    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }

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
        
        NSArray *tempArray = [jsonData objectForKey:@"data"];
        for (NSDictionary *dict in tempArray) {
            MHYModel *model = [MHYModel mj_objectWithKeyValues:dict];
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
    MHYCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[MHYCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    MHYModel *model = self.dataSourceArray[indexPath.row];
    cell.model = model;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderSectionView *header = [[HeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STOCK_SECTION_HEADER_HEIGHT) withTitleArray:self.titlesArray canTouchIndex:1 isUPDown:self.UP_DOWN withBlock:^(BOOL hasNetWork){
        [self sortCurrent];
    }];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STOCK_SECTION_HEADER_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STOCK_CELL_HEIGHT_1;
}

-(void)sortCurrent{
    self.UP_DOWN = !self.UP_DOWN;
    
    if ([currentURL rangeOfString:@"s=desc"].length) {
        currentURL = [currentURL stringByReplacingOccurrencesOfString:@"s=desc" withString:@"s=asc"];
    }else if ([currentURL rangeOfString:@"s=asc"].length){
        currentURL = [currentURL stringByReplacingOccurrencesOfString:@"s=asc" withString:@"s=desc"];
    }
    
    [self loadData];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MHYModel *model = self.dataSourceArray[indexPath.row];
    NSLog(@"Hot Select model =%@",model);
    ZHDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHDetailViewController"];
    detailVC.code = model.bd_code;
    detailVC.titleName = model.bd_name;
    detailVC.itemType = StockItemTypeGG;
    [self.navigationController pushViewController:detailVC animated:YES];
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
