//
//  LoadedViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LoadedViewController.h"
#import "DownLoadManager.h"
#import "LoadedCell.h"

@interface LoadedViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *loadedTableView;
@property(nonatomic,strong)NSMutableArray *loadedArray;

@end

@implementation LoadedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor redColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initWithData) name:DOWNLOADFINISHEDNOTIFICATION object:nil];
    
    self.loadedTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.loadedTableView.dataSource = self;
    self.loadedTableView.delegate = self;
    [self.loadedTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.loadedTableView];
    [self.loadedTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initWithData];
}

-(void)initWithData{
    self.loadedArray = [DownLoadManager sharedDownLoadManager].finishedList;
    [self.loadedTableView reloadData];
    
    [self.loadedTableView tableViewDisplayWithMessage:@"暂无下载" ifNecessaryForRowCount:self.loadedArray.count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.loadedArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LoadedCell *cell = [LoadedCell createCellWithTableView:tableView];
    DownFileModel *fileInfo = self.loadedArray[indexPath.row];
    cell.fileInfo = fileInfo;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DownFileModel *fileInfo = self.loadedArray[indexPath.row];
    
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
