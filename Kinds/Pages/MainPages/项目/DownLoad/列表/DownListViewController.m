
//
//  DownListViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/18.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "DownListViewController.h"
#import "VideoModel.h"
#import "DownListCell.h"
#import "DownLoadManager.h"

@interface DownListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *listTableView;
@property(nonatomic,strong)NSMutableArray *listArray;

@end

@implementation DownListViewController

-(void)dismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"diss" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    NSArray *tempArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DownList" ofType:@"plist"]];
    self.listArray = [VideoModel mj_objectArrayWithKeyValuesArray:tempArray];
    
    self.listTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.listTableView.dataSource = self;
    self.listTableView.delegate = self;
    [self.listTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.listTableView];
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownListCell *cell = [DownListCell createTableView:tableView];
    VideoModel *model = self.listArray[indexPath.row];
    cell.model = model;
    cell.indexPath = indexPath;
    
    __block NSString *videoURL = model.video;
    cell.downLoadCallBackBlock = ^{
        //点击下载按钮 获取下载文件路径
        NSString *name = [[videoURL componentsSeparatedByString:@"/"] lastObject];
        NSLog(@"downName = %@",name);
        
        [[DownLoadManager sharedDownLoadManager] downFileURL:videoURL fileName:model.title fileImage:nil];
        [DownLoadManager sharedDownLoadManager].maxCount = 2;
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

