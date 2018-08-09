//
//  ZHMoreBlankViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHMoreBlankViewController.h"

#import "ZHMHotCell.h"
#import "ZHDetailViewController.h"
#import "TButton.h"
#import "HeaderSectionView.h"

@interface ZHMoreBlankViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)UIView *titleBGView;
@property(nonatomic,strong)UIView *lineLeft;
@property(nonatomic,strong)UIView *lineRight;
@property(nonatomic,strong)UIButton *buttonHY;
@property(nonatomic,strong)UIButton *buttonGN;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,copy)NSString *currentURL;
@property(nonatomic,assign)BOOL UP_DOWN;
@property(nonatomic,assign)BOOL IS_CURRENT;
@property(nonatomic,assign)NSInteger current_tag;
@property(nonatomic,strong)NSMutableArray *titlesArray;

@property(nonatomic,assign)NSInteger titleViewSelectedIndex;

@end

@implementation ZHMoreBlankViewController

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

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.listTableView reloadData];
}

-(UIButton *)buttonHY{
    if (!_buttonHY) {
        _buttonHY = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonHY.frame = CGRectMake(0, 0, 50, 30);
        _buttonHY.tag = 501;
        [_buttonHY setTitle:@"行业" forState:UIControlStateNormal];
        [_buttonHY setTitleColor:[UIColor colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
        _buttonHY.titleLabel.font = FONT_9_MEDIUM(16);
        [_buttonHY addTarget:self action:@selector(changeTitleValueAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonHY;
}
-(UIButton *)buttonGN{
    if (!_buttonGN) {
        _buttonGN = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonGN.frame = CGRectMake(50, 0, 50, 30);
        _buttonGN.tag = 502;
        [_buttonGN setTitle:@"概念" forState:UIControlStateNormal];
        [_buttonGN setTitleColor:[UIColor colorFromHexRGB:@"ffc5d4"] forState:UIControlStateNormal];
        _buttonGN.titleLabel.font = FONT_9_MEDIUM(16);
        [_buttonGN addTarget:self action:@selector(changeTitleValueAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonGN;
}
-(UIView *)lineLeft{
    if (!_lineLeft) {
        _lineLeft = [UIView new];
        _lineLeft.frame = CGRectMake(5, 30, 40, 2);
        _lineLeft.backgroundColor = [UIColor whiteColor];
        _lineLeft.hidden = NO;
    }
    return _lineLeft;
}
-(UIView *)lineRight{
    if (!_lineRight) {
        _lineRight = [UIView new];
        _lineRight.frame = CGRectMake(55, 30, 40, 2);
        _lineRight.backgroundColor = [UIColor whiteColor];
        _lineRight.hidden = YES;
    }
    return _lineRight;
}
-(UIView *)titleBGView{
    if (!_titleBGView) {
        _titleBGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 32)];
        _titleBGView.backgroundColor = [UIColor clearColor];
        
        [_titleBGView addSubview:self.buttonHY];
        [_titleBGView addSubview:self.lineLeft];
        
        [_titleBGView addSubview:self.buttonGN];
        [_titleBGView addSubview:self.lineRight];
    }
    return _titleBGView;
}

-(void)changeTitleValueAction:(UIButton *)sender {
    NSLog(@"%ld",sender.tag);
    NSInteger tag = sender.tag;
    switch (tag) {
        case 501:
            self.titleViewSelectedIndex = 0;
            [self.buttonHY setTitleColor:[UIColor colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
            [self.buttonGN setTitleColor:[UIColor colorFromHexRGB:@"ffc5d4"] forState:UIControlStateNormal];
            
            _lineLeft.hidden = NO;
            _lineRight.hidden = YES;
            break;
        case 502:
            self.titleViewSelectedIndex = 1;
            [self.buttonGN setTitleColor:[UIColor colorFromHexRGB:@"ffffff"] forState:UIControlStateNormal];
            [self.buttonHY setTitleColor:[UIColor colorFromHexRGB:@"ffc5d4"] forState:UIControlStateNormal];
            
            _lineLeft.hidden = YES;
            _lineRight.hidden = NO;
            break;
        default:
            break;
    }
    self.UP_DOWN = YES;
    [self.listTableView.mj_header beginRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.titleView = self.titleBGView;
    _UP_DOWN = YES;
    _IS_CURRENT = YES;
    _current_tag = 901;
    
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
    
    self.titlesArray = [NSMutableArray arrayWithObjects:@"板块名称",@"涨跌幅",@"领涨股", nil];//↓
    
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isPullToRefresh = YES;
        switch (self.titleViewSelectedIndex) {
            case 0:
                [weakSelf loadDataWithURL:HS_HOT_HY_URL];
                break;
            case 1:
                [weakSelf loadDataWithURL:HS_HOT_GN_URL];
                break;
            default:
                break;
        }
    }];
    [self.listTableView.mj_header beginRefreshing];
    
}

-(void)loadDataWithURL:(NSString *)urlString{
    
    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    [[HUDHelper sharedHUDHelper]showLoadingHudWithMessage:nil withView:self.view];
    
    if (urlString.length) {
        if (self.UP_DOWN) {
            self.currentURL = [urlString stringByReplacingOccurrencesOfString:@"o=1" withString:@"o=0"];
        }else{
            self.currentURL = [urlString stringByReplacingOccurrencesOfString:@"o=0" withString:@"o=1"];
        }
    }
    __weak typeof (self) weakSelf = self;
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:self.currentURL isHaveNetWork:^{
        [weakSelf.listTableView.mj_header endRefreshing];
        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadDataWithURL:urlString];
        }];
        
    } failuare:^(NSError *error){
        [weakSelf.listTableView.mj_header endRefreshing];
        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadDataWithURL:urlString];
        }];
        
    } success:^(id jsonData) {
        
        self.dataSourceArray = [NSMutableArray array];
        
        NSArray *tempArray = jsonData[@"data"];
        for (NSDictionary *dic in tempArray) {
            HBItemModel *model = [HBItemModel mj_objectWithKeyValues:dic];
            [self.dataSourceArray addObject:model];
        }
        
        [weakSelf.listTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadDataWithURL:urlString];
        }];
        
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [weakSelf.refreshButton setEnabled:YES];
        }
        
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];
        
    }];
    
}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    ZHMHotCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[ZHMHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    HBItemModel *model = self.dataSourceArray[indexPath.row];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HBItemModel *model = self.dataSourceArray[indexPath.row];
    NSLog(@"Hot Select model =%@",model);
    ZHDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"ZHDetailViewController"];
    detailVC.titleName = model.bd_name;
    detailVC.code = model.bd_code;
    detailVC.itemType = StockItemTypeHS;
    [self.navigationController pushViewController:detailVC animated:YES];
}


-(void)sortCurrent{
    if (_IS_CURRENT) {
        self.UP_DOWN = !self.UP_DOWN;
    }else{
        self.UP_DOWN = YES;
        _IS_CURRENT = YES;
    }
    if ([self.currentURL rangeOfString:@"o=0"].length) {
        self.currentURL = [self.currentURL stringByReplacingOccurrencesOfString:@"o=0" withString:@"o=1"];
    }else if ([self.currentURL rangeOfString:@"o=1"].length){
        self.currentURL = [self.currentURL stringByReplacingOccurrencesOfString:@"o=1" withString:@"o=0"];
    }
    
    [self loadDataWithURL:self.currentURL];//替换手动排序
    
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
