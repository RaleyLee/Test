//
//  HBMoreBangViewController.m
//  HangQingNew
//
//  Created by hibor on 2018/5/23.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "HBMoreBangViewController.h"
#import "HBHSListCell.h"
#import "HBStockInfoViewController.h"
#import "HeaderSectionView.h"

@interface HBMoreBangViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSString *currentURL;
}


@property (weak, nonatomic) IBOutlet UITableView *bangTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *titlesArray;
@property(nonatomic,strong)NSMutableArray *urlStringArray;

@property(nonatomic,assign)BOOL UP_DOWN;

@end

@implementation HBMoreBangViewController

-(BOOL)prefersStatusBarHidden{
    return NO;
}
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


-(void)changeRotateBang:(NSNotification *)noti{
    [self.bangTableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeRotateBang:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    __weak typeof (self) weakSelf = self;

    self.title = self.tableTitle;
    
    
    if (REFRESH_WAY_LOADING) {
        [self setRefreshButtonAnimationWithBlock:^{
            [weakSelf.bangTableView.mj_header beginRefreshing];
        }];
    }else{
        [self setRefreshButtonWithBlock:^{
            [weakSelf.bangTableView.mj_header beginRefreshing];
        }];
    }

    
    self.urlStringArray = [NSMutableArray arrayWithObjects:
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=main_zf&order=desc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=main_df&order=asc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=main_cje&order=desc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=gem_zf&order=desc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=gem_df&order=asc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=gem_cje&order=desc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=renzheng_cje&order=desc"],
                           [HB_HEADER_URL stringByAppendingString:@"hangqingHK/rankmore?type=niuxiong_cje&order=desc"], nil];
    _UP_DOWN = [self.urlStringArray[self.urlIndex] rangeOfString:@"desc"].length ? YES : NO;
    self.titlesArray = [NSMutableArray arrayWithObjects:@"板块名称",@"最新价",self.otherTitle, nil];
    
    currentURL = self.urlStringArray[self.urlIndex];
    
    self.bangTableView.tableFooterView = [UIView new];
    self.bangTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.bangTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.bangTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.bangTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.bangTableView.mj_header beginRefreshing];
}


-(void)loadData{
    
    __weak typeof (self) weakSelf = self;
    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];
    
    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:currentURL isHaveNetWork:^{
        [weakSelf.bangTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];

        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.bangTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];

    } failuare:^(NSError *error){
        [weakSelf.bangTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];

        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [weakSelf.bangTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        
    } success:^(id jsonData) {
        self.dataSourceArray = [NSMutableArray array];
        
        NSArray *tempArray = [jsonData objectForKey:@"data"];
        for (NSDictionary *dict in tempArray) {
            BangModel *model = [BangModel mj_objectWithKeyValues:dict];
            [self.dataSourceArray addObject:model];
        }
        
        [weakSelf.bangTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        
        [weakSelf.bangTableView reloadData];
        [weakSelf.bangTableView.mj_header endRefreshing];
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
    HBHSListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[HBHSListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    if (self.urlIndex == 2 || self.urlIndex == 5 || self.urlIndex == 6 || self.urlIndex == 7) {
        cell.showCJE = YES;
    }
    cell.showIcon = YES;
    BangModel *model = self.dataSourceArray[indexPath.row];
    cell.bangModel = model;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    HeaderSectionView *header = [[HeaderSectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STOCK_SECTION_HEADER_HEIGHT) withTitleArray:self.titlesArray canTouchIndex:2 isUPDown:self.UP_DOWN withBlock:^(BOOL hasNetWork){
        [self sortCurrent];
    }];
    return header;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return STOCK_SECTION_HEADER_HEIGHT;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STOCK_CELL_HEIGHT_2;
}

-(void)sortCurrent{
    self.UP_DOWN = !self.UP_DOWN;
    if ([currentURL rangeOfString:@"order=desc"].length) {
        currentURL = [currentURL stringByReplacingOccurrencesOfString:@"order=desc" withString:@"order=asc"];
    }else if ([currentURL rangeOfString:@"order=asc"].length) {
        currentURL = [currentURL stringByReplacingOccurrencesOfString:@"order=asc" withString:@"order=desc"];
    }
    [self loadData];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BangModel *model = self.dataSourceArray[indexPath.row];
    NSLog(@"Hot Select model =%@",model);
    HBStockInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    infoVC.code = model.code;
    infoVC.stockName = model.name;
    [self.navigationController pushViewController:infoVC animated:YES];

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
