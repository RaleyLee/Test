//
//  QQMusicWarnViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/6.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "QQMusicWarnViewController.h"

@interface QQMusicWarnViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *warnTableView;
@property(nonatomic,strong)NSArray *titleArray;

@end

@implementation QQMusicWarnViewController

-(NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@[@"成功",@"失败",@"预警信息",@"网络状况"],@[@"延迟消失",@"立即消失"]];
    }
    return _titleArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"QQ音乐提示";
    
    self.warnTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    self.warnTableView.dataSource = self;
    self.warnTableView.delegate = self;
    [self.view addSubview:self.warnTableView];
    [self.warnTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titleArray[section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"warn"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"warn"];
    }
    cell.textLabel.text = self.titleArray[indexPath.section][indexPath.row];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return section == 0? @"点击提示窗。" : @"点击下面表格使提示窗消失";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        NSArray *tips = [NSArray arrayWithObjects:@"请求成功!",@"请求失败!",@"xxoo楼发生入侵事件!",@"网络状态已发生改变!", nil];
        [[ZAlertViewManager shareManager] showWithType:indexPath.row title:tips[indexPath.row]];
        [[ZAlertViewManager shareManager] didSelectedAlertViewWithBlock:^{
            NSLog(@"%@",tips[indexPath.row]);
        }];
    }
    else
    {
        if (indexPath.row == 0)
        {
            [[ZAlertViewManager shareManager] dismissAlertWithTime:10];
        }
        else
        {
            [[ZAlertViewManager shareManager] dismissAlertImmediately];
        }
    }
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
