//
//  ThreeViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ThreeViewController.h"
#import "KindModel.h"
#import "LLTableViewHeaderView.h"

@interface ThreeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;

@property(nonatomic,strong)NSDictionary *dataSourceDiction;

@property(nonatomic,strong)NSMutableArray *totalDataArray;

@end

@implementation ThreeViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSourceDiction = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AllKinds" ofType:@"plist"]];
    self.totalDataArray = [NSMutableArray array];
    for (int i = 0; i < [[self.dataSourceDiction allKeys] count]; i++) {
        NSString *key = [self.dataSourceDiction allKeys][i];
        NSMutableArray *tempArray = [NSMutableArray array];
        if ([self.dataSourceDiction[key] count] == 0 || !self.dataSourceDiction[key]) { //如果当前分类下没有值 手动赋值空
        }else{
            tempArray = [KindModel mj_objectArrayWithKeyValuesArray:self.dataSourceDiction[key]];
        }
        NSDictionary *tempDict = @{key:tempArray};
        [self.totalDataArray addObject:tempDict];
    }
    NSLog(@"totalDataArray = %@",self.totalDataArray);
    
    self.listTableView.tableFooterView = [UIView new];
    if ([self.listTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.listTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.totalDataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString *key = [self.totalDataArray[section] allKeys][0];
    NSInteger count = [self.totalDataArray[section][key] count];
    return count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"iden";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    NSString *key = [self.totalDataArray[indexPath.section] allKeys][0];
    KindModel *model = self.totalDataArray[indexPath.section][key][indexPath.row];
    if (model.canPush) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = model.title;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *key = [self.totalDataArray[indexPath.section] allKeys][0];
    KindModel *model = self.totalDataArray[indexPath.section][key][indexPath.row];
    if (model.canPush) {
        Class pushClass = NSClassFromString(model.openPage);
        UIViewController *controller = [[pushClass alloc] init];
        controller.title = key;
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    LLTableViewHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    if (!headerView) {
        headerView = [[LLTableViewHeaderView alloc] initWithReuseIdentifier:@"header"];
    }
    NSString *key = [self.totalDataArray[section] allKeys][0];
    headerView.kindLabel.text = key;
    
    NSArray *array = self.totalDataArray[section][key];
    headerView.countLabel.text = [NSString stringWithFormat:@"共 %ld 个",array.count];
    
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
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
