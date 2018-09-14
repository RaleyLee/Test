//
//  DownLoadedSongListViewController.m
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "DownLoadedSongListViewController.h"
#import "SongLoadedListCell.h"
#import "SongModel.h"

#import "PlayViewController.h"

#import "LRCManager.h"

@interface DownLoadedSongListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *downListTableView;
@property(nonatomic,strong)NSMutableArray *downArray;

@end

@implementation DownLoadedSongListViewController


-(NSMutableArray *)downArray{
    if (!_downArray) {
        _downArray = [SongModel mj_objectArrayWithFilename:@"SongList.plist"];
    }
    return _downArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"下载音乐";
    
    self.downListTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.downListTableView.dataSource = self;
    self.downListTableView.delegate = self;
    [self.downListTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.downListTableView];
    [self.downListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.downArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SongLoadedListCell *cell = [SongLoadedListCell createSongListCell:tableView];
    cell.sModel = self.downArray[indexPath.row];
    cell.indexPath = indexPath;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SongModel *sModel = self.downArray[indexPath.row];
//    NSString *fileName = [NSString stringWithFormat:@"%@ - %@.lrc",sModel.singer,sModel.song];
//    NSMutableArray *lrcArray = [[LRCManager sharedManager] getCurrentSongLrcList:fileName];
//    NSLog(@"lrc = %@",lrcArray);
//    return;
    PlayViewController *playVC = [[PlayViewController alloc] init];
    playVC.currentModel = sModel;
    playVC.songIndex = indexPath.row;
    playVC.songListArray = self.downArray;
    [self.navigationController pushViewController:playVC animated:YES];
    
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
