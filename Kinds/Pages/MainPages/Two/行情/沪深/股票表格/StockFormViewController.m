//
//  StockFormViewController.m
//  HangQingNew
//
//  Created by hibor on 2018/5/23.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "StockFormViewController.h"
#import "HBStockInfoViewController.h"

@interface StockFormViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>{
    NSIndexPath *lastIndexPath;
}

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;


@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *sortArray;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) AroundCell *aroundCell;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic,assign) float cellLastX; //最后的cell的移动距离
@property (nonatomic,assign) float scrollLastOffsetX;
@property(nonatomic,strong)UIButton *lastButton;

@property(nonatomic,copy)NSString *URLString;

@property(nonatomic,copy)NSString *tempKey,*tempOrder;

@end

@implementation StockFormViewController

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
    self.title = @"热门榜单";

    if (REFRESH_WAY_LOADING) {
        [self setRefreshButtonAnimationWithBlock:^{
            [weakSelf.myTableView.mj_header beginRefreshing];
        }];
    }else{
        [self setRefreshButtonWithBlock:^{
            [self.myTableView.mj_header beginRefreshing];
        }];
    }
    
    self.titleArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FormTitleList" ofType:@"plist"]];

    self.sortArray = [NSMutableArray arrayWithObjects:@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0", nil];
    
    self.myTableView.separatorColor = STOCK_CELL_SEP_BGCOLOR;//STOCK_CELL_SEP_BGCOLOR;
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.myTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    self.myTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.isPullToRefresh = YES;
        [weakSelf loadData];
    }];
    
    self.URLString = [NSString stringWithFormat:HS_TABLE_URL,self.type,self.order];
    self.tempKey = self.type;
    self.tempOrder = self.order;
    
    [self.myTableView.mj_header beginRefreshing];

    // 注册一个
    extern NSString *tapCellScrollNotification;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollMove:) name:tapCellScrollNotification object:nil];
}

-(void)loadData{
    //拼接 排序字段  排序方式  排序时间戳
    
    __weak typeof (self) weakSelf = self;
    
    [[HUDHelper sharedHUDHelper] showLoadingHudWithMessage:nil withView:self.view];

    
    if (REFRESH_WAY_LOADING) {
        [self.VRefreshButton refreshStatusStart];
    }else{
        [self.refreshButton setEnabled:NO];
    }
    
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:self.URLString isHaveNetWork:^{
        [weakSelf.myTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDNOTNETWORKINGMESSAGE withView:self.view];

        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [self.refreshButton setEnabled:YES];
        }
        
        [weakSelf.myTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNotNetWork ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];

        
    } failuare:^(NSError *error){
    
        [weakSelf.myTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:HUDFAILMESSAGE withView:self.view];

       
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [self.refreshButton setEnabled:YES];
        }
        
        [weakSelf.myTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeGetDataFailure ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];

    } success:^(id jsonData) {
        
        self.dataSourceArray = [NSMutableArray array];
        
        NSArray *array = jsonData[@"data"];
        if (array) {
            for (NSDictionary *dict in array) {
                AroundModel *model = [AroundModel mj_objectWithKeyValues:dict];
                [self.dataSourceArray addObject:model];
            }
            [self.myTableView reloadData];
        }
        
        [weakSelf.myTableView tableViewDisplayWithImage:nil withMessage:nil withType:DisplayTypeNoData ifNecessaryForRowCount:weakSelf.dataSourceArray.count reloadButtonBlock:^{
            [weakSelf loadData];
        }];
        
        [weakSelf.myTableView.mj_header endRefreshing];
        [[HUDHelper sharedHUDHelper] stopLoadingHud];
        [[HUDHelper sharedHUDHelper] showHudWithMessage:jsonData[@"msg"] withView:self.view];

        
        if (REFRESH_WAY_LOADING) {
            [weakSelf.VRefreshButton refreshStatusEnd];
        }else{
            [self.refreshButton setEnabled:YES];
        }
    }];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    
    _aroundCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (!_aroundCell) {
        _aroundCell = [[AroundCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    _aroundCell.selected = (indexPath == lastIndexPath) ? YES : NO;
    
    
    _aroundCell.model = self.dataSourceArray[indexPath.row];
    _aroundCell.tableView = self.myTableView;
    __weak typeof(self) weakSelf = self;
    _aroundCell.tapCellClick = ^(NSIndexPath *indexPath) {
        [weakSelf tableView:tableView didSelectRowAtIndexPath:indexPath];
    };
//    if (indexPath.row % 2 == 0) {
//        _aroundCell.backgroundColor = [UIColor colorFromHexRGB:@"e9e9e9"];
//    }else{
//        _aroundCell.backgroundColor = [UIColor whiteColor];
//    }
    return _aroundCell;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.selected = (indexPath == lastIndexPath) ? YES : NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (lastIndexPath) {
        _aroundCell = [tableView cellForRowAtIndexPath:lastIndexPath];
        _aroundCell.selected = NO;
    }
    _aroundCell = [tableView cellForRowAtIndexPath:indexPath];
    _aroundCell.selected = YES;
    lastIndexPath = indexPath;
    
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"选中 %ld",indexPath.row);
    HBStockInfoViewController *infoVC = [[UIStoryboard storyboardWithName:@"Market" bundle:nil] instantiateViewControllerWithIdentifier:@"HBStockInfoViewController"];
    AroundModel *model = self.dataSourceArray[indexPath.row];
    infoVC.code = model.code;
    infoVC.stockName = model.name;
    [self.navigationController pushViewController:infoVC animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return STOCK_CELL_HEIGHT_2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return STOCK_TABLE_HEADER_HEIGHT;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    headerView.backgroundColor = STOCK_ZDSECTION_BGCOLOR;
    
    CGFloat lblW = 90;
    
    LLabel *titleLbl = [LLabel new];
    titleLbl.text = @"股票名称";
    titleLbl.textColor = STOCK_TABLE_TOP_LEFT_COLOR;
    titleLbl.font = FONT_9_MEDIUM(14);
    titleLbl.textAlignment = NSTextAlignmentLeft;
    titleLbl.edgInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [headerView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(lblW);
    }];
    
    self.topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(lblW, 0, self.view.bounds.size.width-lblW, STOCK_TABLE_HEADER_HEIGHT)];
    self.topScrollView.showsVerticalScrollIndicator = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat labelW = 90;
    [self.titleArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TButton *button = [TButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(labelW * idx, 0, labelW, STOCK_TABLE_HEADER_HEIGHT);
        [button setTitle:obj.allValues[0] forState:UIControlStateNormal];//self.titleArray[idx]
        //        NSLog(@"key = %@,type = %@",[obj allKeys][0],self.type);
        if ([[obj allKeys][0] isEqualToString:self.type]) {
            if ([self.order isEqualToString:@"top"]) {
                [button setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
            }else if ([self.order isEqualToString:@"bottom"]){
                [button setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
            }
        }else{
            [button setImage:[UIImage imageNamed:SORT_DEFAULT] forState:UIControlStateNormal];
        }
        button.titleLabel.font = FONT_9_MEDIUM(14);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [button setTitleColor:STOCK_CONTENT_REDCOLOR forState:UIControlStateNormal];
        button.tag = 600+idx;
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 12);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 80, 0, 0);
        button.imageRect = CGRectMake(80, (STOCK_TABLE_HEADER_HEIGHT-12)/2, 8, 12);
        [button addTarget:self action:@selector(titleClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.topScrollView addSubview:button];
    }];
    self.topScrollView.contentSize = CGSizeMake(lblW * self.titleArray.count+15, 0);
    self.topScrollView.delegate = self;
    [self.topScrollView setContentOffset:CGPointMake(self.scrollLastOffsetX, 0) animated:NO];//刷新位置（看不出移动的效果）
    
    [headerView addSubview:self.topScrollView];
    
    //[UIView setBorderWithView:headerView top:NO left:NO bottom:YES right:NO borderColor:SECTION_UNDERLINE_COLOR borderWidth:SCREEN_WIDTH borderHeight:0.5];
    
    [self.topScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLbl.mas_right);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    return headerView;
}

-(void)titleClickAction:(UIButton *)sender{
    
    NSString *key;
    for (NSDictionary *dict in self.titleArray) {
        if ([[dict allValues][0] isEqualToString:sender.titleLabel.text]) {
            key = [dict allKeys][0];
            NSLog(@"key = %@",key);
            break;
        }
    }
    
    if ([key isEqualToString:self.type]) {
        if ([self.order isEqualToString:@"top"]) {
            self.order = @"bottom";
        }else if ([self.order isEqualToString:@"bottom"]){
            self.order = @"top";
        }
    }else{
        self.type = key;
        self.order = @"top";
    }
    
    self.URLString = [NSString stringWithFormat:HS_TABLE_URL,self.type,self.order];
    
//    [self.titleArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        TButton *button = (TButton *)[self.view viewWithTag:600+idx];
//        if ([[obj allKeys][0] isEqualToString:key]) {
//            if ([self.order isEqualToString:@"top"]) {
//                [button setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
//            }else if ([self.order isEqualToString:@"bottom"]){
//                [button setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
//            }
//        }else{
//            [button setImage:[UIImage imageNamed:SORT_DEFAULT] forState:UIControlStateNormal];
//        }
//    }];
    [self loadData];
//    __weak typeof (self) weakSelf = self;
//    self.loadBlock = ^(BOOL isSuccess) {
//        if (isSuccess) {
//            [weakSelf.titleArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                TButton *button = (TButton *)[weakSelf.view viewWithTag:600+idx];
//                if ([[obj allKeys][0] isEqualToString:key]) {
//                    if ([weakSelf.order isEqualToString:@"top"]) {
//                        [button setImage:[UIImage imageNamed:SORT_DOWN] forState:UIControlStateNormal];
//                    }else if ([weakSelf.order isEqualToString:@"bottom"]){
//                        [button setImage:[UIImage imageNamed:SORT_UP] forState:UIControlStateNormal];
//                    }
//                }else{
//                    [button setImage:[UIImage imageNamed:SORT_DEFAULT] forState:UIControlStateNormal];
//                }
//            }];
//        }
//    };
    
    
}

-(NSString *)returnValueFromKey:(NSString *)key aroundModel:(AroundModel *)model{
    if ([key isEqualToString:@"zxj"]) {
        return  model.zxj;
    }
    if ([key isEqualToString:@"zdf"]) {
        return  model.zdf;
    }
    if ([key isEqualToString:@"hsl"]) {
        return  model.hsl;
    }
    if ([key isEqualToString:@"cjl"]) {
        return  model.cjl;
    }
    if ([key isEqualToString:@"cje"]) {
        return  model.cje;
    }
    if ([key isEqualToString:@"lb"]) {
        return  model.lb;
    }
    if ([key isEqualToString:@"zf"]) {
        return  model.zf;
    }
    if ([key isEqualToString:@"syl"]) {
        return  model.syl;
    }
    if ([key isEqualToString:@"ltsz"]) {
        return  model.ltsz;
    }
    if ([key isEqualToString:@"zsz"]) {
        return  model.zsz;
    }
    if ([key isEqualToString:@"zde"]) {
        return  model.zde;
    }
    if ([key isEqualToString:@"zs"]) {
        return  model.zs;
    }
    return nil;
}
#pragma mark-- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //    NSLog(@"%@ -- %lf",scrollView,scrollView.contentOffset.x);
    
    if ([scrollView isEqual:self.topScrollView]) {
        CGPoint offSet = _aroundCell.rightScrollView.contentOffset;
        offSet.x = scrollView.contentOffset.x;
        _aroundCell.rightScrollView.contentOffset = offSet;
        self.scrollLastOffsetX = scrollView.contentOffset.x;
        
    }
    if ([scrollView isEqual:self.myTableView]) {
        // 发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:tapCellScrollNotification object:self userInfo:@{@"cellOffX":@(self.cellLastX)}];
    }
    
}

-(void)scrollMove:(NSNotification*)notification{
    NSDictionary *noticeInfo = notification.userInfo;
    float x = [noticeInfo[@"cellOffX"] floatValue];
    self.cellLastX = x;
    CGPoint offSet = self.topScrollView.contentOffset;
    offSet.x = x;
    self.topScrollView.contentOffset = offSet;
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
