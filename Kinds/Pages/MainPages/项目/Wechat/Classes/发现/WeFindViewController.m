//
//  WeFindViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "WeFindViewController.h"

@interface WeFindViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *toolTableView;
@property(nonatomic,strong)NSArray *itemArray;

@end

@implementation WeFindViewController

-(NSArray *)itemArray{
    if (!_itemArray) {
        _itemArray = @[
                       @[@{@"image":@"moment_refresh",@"title":@"朋友圈"}]
                       ];
    }
    return _itemArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.toolTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.toolTableView.dataSource = self;
    self.toolTableView.delegate = self;
    [self.view addSubview:self.toolTableView];
    __weak typeof (self) weakSelf = self;
    [self.toolTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.itemArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.itemArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"iden"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"iden"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary *dict = self.itemArray[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text = dict[@"title"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CircleFriendViewController *friendVC = [[CircleFriendViewController alloc] init];
    [friendVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:friendVC animated:YES];
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
