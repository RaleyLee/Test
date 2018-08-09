//
//  FDetailViewController.m
//  WBAPP
//
//  Created by hibor on 2018/4/26.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "FDetailViewController.h"
#import "QiuCell.h"
@class QiuModel;

@interface FDetailViewController ()<UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *OC_Array;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation FDetailViewController

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
    
    self.OC_Array = [NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1", nil];
    
    __weak typeof (self) weakSelf = self;
    self.title = self.titleName;
    
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
    
    self.listTableView.estimatedRowHeight = STOCK_CELL_HEIGHT_1;
    self.listTableView.estimatedSectionHeaderHeight = 35;
    self.listTableView.backgroundColor = [UIColor whiteColor];
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

-(void)loadData{
    
    __weak typeof (self) weakSelf = self;
    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];

    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:self.requestURLString isHaveNetWork:^{
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
            model.opened = [self.OC_Array[i] isEqualToString:@"1"] ? YES : NO;
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
    return self.dataSourceArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    OCTableModel *model = self.dataSourceArray[section];
    return model.opened ?[model.listArray count] : 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"cell_id";
    QiuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[QiuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (self.dataSourceArray.count) {
        OCTableModel *model = self.dataSourceArray[indexPath.section];
        NSArray *aaArray = model.listArray;
        QiuModel *fmodel = aaArray[indexPath.row];
        cell.model = fmodel;
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STOCK_CELL_HEIGHT_1;
}

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
        sectionView.hqDetail = YES;
        sectionView.hiddenMoreButton = YES;
        sectionView.contentBGColor = RGB(244, 244, 244);
        sectionView.headerMoreClick = ^(NSInteger tag) {
            NSLog(@"tag = %ld",tag);
        };
        sectionView.headerSectionClick = ^{
            NSString *replaceString = [self.OC_Array[section] isEqualToString:@"1"] ? @"0" : @"1";
            [self.OC_Array replaceObjectAtIndex:section withObject:replaceString];
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
    return 35;
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
