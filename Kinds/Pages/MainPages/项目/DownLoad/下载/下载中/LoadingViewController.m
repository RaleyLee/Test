//
//  LoadingViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LoadingViewController.h"
#import "DownLoadManager.h"
#import "DownCell.h"

@interface LoadingViewController ()<UITableViewDataSource,UITableViewDelegate,DownLoadDelegate>

@property(nonatomic,strong)UITableView *loadTableView;
@property(nonatomic,strong)NSMutableArray *downLoadObjectArray;

@end

@implementation LoadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    self.loadTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.loadTableView.dataSource = self;
    self.loadTableView.delegate = self;
    [self.loadTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.loadTableView];
    [self.loadTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [DownLoadManager sharedDownLoadManager].downloadDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initWithData];
}

-(void)initWithData{
    [[DownLoadManager sharedDownLoadManager] startDownLoadTask];
    self.downLoadObjectArray = [DownLoadManager sharedDownLoadManager].downLoadingList;
    [self.loadTableView reloadData];
    
    [self.loadTableView tableViewDisplayWithMessage:@"暂无下载任务" ifNecessaryForRowCount:self.downLoadObjectArray.count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.downLoadObjectArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DownCell *cell = [DownCell createCellWithTableView:tableView];
    DownHttpRequest *request = [self.downLoadObjectArray objectAtIndex:indexPath.row];
    if (request == nil) {
        return nil;
    }
    DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    cell.fileInfo = fileInfo;
    cell.request = request;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(void)startDownload:(DownHttpRequest *)request{
    NSLog(@"开始下载");
}
-(void)updateCellProgress:(DownHttpRequest *)request{
    DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    [self performSelectorOnMainThread:@selector(updateCellOnMainThread:) withObject:fileInfo waitUntilDone:YES];
}
// 下载完成
- (void)finishedDownLoad:(DownHttpRequest *)request
{
    [self initWithData];
    [[NSNotificationCenter defaultCenter] postNotificationName:DOWNLOADFINISHEDNOTIFICATION object:nil];
}
// 更新下载进度
- (void)updateCellOnMainThread:(DownFileModel *)fileInfo
{
    NSArray *cellArr = [self.loadTableView visibleCells];
    for (id obj in cellArr) {
        if([obj isKindOfClass:[DownCell class]]) {
            DownCell *cell = (DownCell *)obj;
            if([cell.fileInfo.fileURL isEqualToString:fileInfo.fileURL]) {
                cell.fileInfo = fileInfo;
            }
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
