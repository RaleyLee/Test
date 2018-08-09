//
//  ZHStockViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/22.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ZHStockViewController.h"
#import "ZHStockModel.h"
#import "ZHStockView.h"

@interface ZHStockViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_BottomLayout;

@property(nonatomic,strong)NSMutableArray *ZSDataSourceArray;

@end

@implementation ZHStockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    
    
    __weak typeof (self) weakSelf = self;
    self.listTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadData];
    }];
    [self.listTableView.mj_header beginRefreshing];
    
}

-(void)loadData{
    self.ZSDataSourceArray = [NSMutableArray array];
    NSDictionary *paramert = @{@"btype":@"15",@"username":@"sY1UgXjYxUjVfYqRmQ",@"action":@"stock_price",@"groupname":@"默认组",@"stockcode":@"000006,000002,000001,08002.HK"};
    __weak typeof(self) weakSelf = self;
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:@"http://mp.hibor.com.cn/MobilePhone/GetJsonHandler.ashx" WithParamert:paramert isHaveNetWork:^{
        
    } failuare:^{
        
    } success:^(id jsonData) {
        NSLog(@"jsonData = %@",jsonData);
        NSArray *tempArray = jsonData[@"data"][@"list"];
        for (NSDictionary *dict in tempArray) {
            ZHStockModel *model = [ZHStockModel mj_objectWithKeyValues:dict];
            [self.ZSDataSourceArray addObject:model];
        }
        [self createTableViewHeaderView:self.ZSDataSourceArray];
        [weakSelf.listTableView reloadData];
        [weakSelf.listTableView.mj_header endRefreshing];
    }];
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self createTableViewHeaderView:self.ZSDataSourceArray];
    [self.listTableView reloadData];
}

-(void)createTableViewHeaderView:(NSArray *)array{
    if (array.count == 0 || !array) {
        return;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.listTableView.bounds.size.width, 85)];
    headerView.backgroundColor = [UIColor cyanColor];
    
    CGFloat itemWidth = (self.listTableView.bounds.size.width-(MARKET_SPACING*2)) / array.count;
    for (int i = 0; i < array.count; i++) {
        ZHStockView *itemView = [[ZHStockView alloc] initWithFrame:CGRectMake(MARKET_SPACING+itemWidth*i, 0, itemWidth, 85)];
        itemView.backgroundColor = RGB_random;
        itemView.model = array[i];
        [headerView addSubview:itemView];
    }
    
    
    
    self.listTableView.tableHeaderView = headerView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.textLabel.text = @"123";
    return cell;
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
