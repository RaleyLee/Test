//
//  AFNetworkViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/17.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "AFNetworkViewController.h"
#import "LLDownLoadView.h"
#import "LLDownLoadModel.h"

@interface AFNetworkViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UIImageView *downImageView;
@property(nonatomic,strong) UIProgressView *progress;
@property(nonatomic,strong) UIButton *downButton;
@property(nonatomic,strong) UILabel *proLabel;

//---------------------------------------------------

@property(nonatomic,strong) UIProgressView *progress_control;
@property(nonatomic,strong) UIButton *downButton_control;
@property(nonatomic,strong) UIButton *pauseButton_control;
@property(nonatomic,strong) UILabel *proLabel_control;

@property(nonatomic,strong) UIView *rotaView;



@property(nonatomic,strong)UITableView *downTableView;
@property(nonatomic,strong)NSMutableArray *sourceArray;

@end


#define WEAK()

@implementation AFNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"AFNetWorking使用";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    NSArray *videoArray = @[
                         @{@"video":@"https://s3.bytecdn.cn/aweme/resource/web/static/image/index/new-tvc_889b57b.mp4",@"title":@"抖音官网视频"},
                         @{@"video":@"http://video.699pic.com/videos/31/42/31/b5pEmA9ujS1I1534314231.mp4",@"title":@"传统文化"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/19/5b4b8228-e693-4280-9c21-49cba178ae44.mov",@"title":@"超慢运动的雨滴"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/02/893d03a3-c7b1-4c62-adce-a5a4fdb4aac1.mp4",@"title":@"香港回归"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/18/aa475bde-a707-48d9-b9b5-c0c64cd0a86b.mov",@"title":@"秋天的落叶"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/19/9c499ca2-1bd9-4561-b404-c58099af03e8.mp4",@"title":@"时间流逝:白天到夜晚的城市"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/18/85ca00dc-7e57-422c-841a-5a1606ef2271.mp4",@"title":@"云尕UHD"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/18/9e1d06a6-2e0a-4e29-bafc-027e808dbdbc.mp4",@"title":@"步行穿过大麦田"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/19/f2330cfe-df2a-44c4-abcd-6ed13da9ab78.mov",@"title":@"交通从焦点的背景虚化背景"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/02/ca9ec254-9999-405b-b5b2-7694342a9d62.mp4",@"title":@"工作空间"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/19/6f20f381-07f9-4b6e-9155-1fd782a1eab2.mov",@"title":@"阳光和树叶"},
                         @{@"video":@"http://img95.699pic.com/videos/2016/09/05/14c2e3e9-9594-4638-862d-d5b313922b42.mp4",@"title":@"香港回归"}
                         ];
    self.sourceArray = [NSMutableArray array];
    self.sourceArray = [LLDownLoadModel mj_objectArrayWithKeyValuesArray:videoArray];
    
    self.downTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.downTableView.dataSource = self;
    self.downTableView.delegate = self;
    [self.downTableView setTableFooterView:[UIView new]];
    [self.view addSubview:self.downTableView];
    [self.downTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
//    [self createDownCannotToControl];
    
//    [self createDownCanControl];
    
    
//    self.rotaView = [UIView new];
//    self.rotaView .backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.rotaView ];
//    [self.rotaView  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(50, 50));
//    }];
//
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self rotaViewfromValue:0.0f toValue:M_PI / 2];
//    });
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"downCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    for (UIView *view in [cell.contentView subviews]) {
        [view removeFromSuperview];
    }
    LLDownLoadView *downLoadView = [LLDownLoadView createDownLoadView];
    downLoadView.downModel = self.sourceArray[indexPath.row];
    [cell.contentView addSubview:downLoadView];
    [downLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView);
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    for (UIView *view in [cell.contentView subviews]) {
        if ([view isKindOfClass:[LLDownLoadView class]]) {
            LLDownLoadView *view1 = (LLDownLoadView *)view;
            [view1 offLineResumeDownLoadAction];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(void)rotaViewfromValue:(CGFloat)from toValue:(CGFloat)to{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    animation.fromValue = [NSNumber numberWithFloat:from];
    animation.toValue = [NSNumber numberWithFloat: to];
    animation.duration = 1;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 1; //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.rotaView.layer addAnimation:animation forKey:nil];
}

#pragma mark- 创建可控下载

-(void)createDownCanControl{
    __weak typeof (self) weakSelf = self;
    
    self.progress_control = [[UIProgressView alloc] init];
    self.progress_control.progressViewStyle = UIProgressViewStyleBar;
    self.progress_control.tintColor = RGB(5, 119, 251);
    self.progress_control.trackTintColor = [UIColor lightGrayColor];
    [self.view addSubview:self.progress_control];
    [self.progress_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(3);
    }];
    
    self.downButton_control = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton_control setTitle:@"开始下载" forState:UIControlStateNormal];
    [self.downButton_control setTitleColor:RGB(5, 119, 251) forState:UIControlStateNormal];
    self.downButton_control.titleLabel.font = [UIFont systemFontOfSize:15];
    self.downButton_control.layer.borderColor = RGB_color(200).CGColor;
    self.downButton_control.layer.borderWidth = 0.5f;
    self.downButton_control.layer.cornerRadius = 3;
    self.downButton_control.layer.masksToBounds = YES;
    [self.downButton_control addTarget:self action:@selector(downLoadControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downButton_control];
    [self.downButton_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.progress_control.mas_left);
        make.top.equalTo(weakSelf.progress_control.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.pauseButton_control = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.pauseButton_control setTitle:@"暂停下载" forState:UIControlStateNormal];
    [self.pauseButton_control setTitleColor:RGB(5, 119, 251) forState:UIControlStateNormal];
    self.pauseButton_control.titleLabel.font = [UIFont systemFontOfSize:15];
    self.pauseButton_control.layer.borderColor = RGB_color(200).CGColor;
    self.pauseButton_control.layer.borderWidth = 0.5f;
    self.pauseButton_control.layer.cornerRadius = 3;
    self.pauseButton_control.layer.masksToBounds = YES;
    [self.pauseButton_control addTarget:self action:@selector(downLoadControlAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pauseButton_control];
    [self.pauseButton_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.downButton_control.mas_right).offset(10);
        make.top.equalTo(weakSelf.downButton_control.mas_top);
        make.height.mas_equalTo(30);
    }];
    
    self.proLabel_control = [[UILabel alloc] init];
    self.proLabel_control.font = [UIFont systemFontOfSize:15];
    self.proLabel_control.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.proLabel_control];
    [self.proLabel_control mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.progress_control.mas_right);
        make.top.equalTo(weakSelf.downButton_control.mas_top);
        make.height.equalTo(weakSelf.downButton_control.mas_height);
    }];
}

#pragma mark - 直接点击下载 无法控制

-(void)createDownCannotToControl{
    __weak typeof (self) weakSelf = self;
    
    
    self.downImageView = [UIImageView new];
    self.downImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.downImageView];
    [self.downImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(30);
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(100, 60));
    }];
                             
                             
    self.progress = [[UIProgressView alloc] init];
    self.progress.progressViewStyle = UIProgressViewStyleBar;
    self.progress.tintColor = RGB(194, 161, 113);
    self.progress.trackTintColor = RGB_color(238);
    [self.view addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.downImageView.mas_centerY);
        make.left.equalTo(weakSelf.downImageView.mas_right).offset(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(2);
    }];
    
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.downButton setTitle:@"开始下载" forState:UIControlStateNormal];
    [self.downButton setTitleColor:RGB(5, 119, 251) forState:UIControlStateNormal];
    self.downButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.downButton.layer.borderColor = RGB_color(200).CGColor;
    self.downButton.layer.borderWidth = 0.5f;
    self.downButton.layer.cornerRadius = 3;
    self.downButton.layer.masksToBounds = YES;
    [self.downButton addTarget:self action:@selector(downLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.downButton];
    [self.downButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.progress.mas_left);
        make.top.equalTo(weakSelf.progress.mas_bottom).offset(10);
        make.height.mas_equalTo(30);
    }];
    
    self.proLabel = [[UILabel alloc] init];
    self.proLabel.font = [UIFont systemFontOfSize:10];
    self.proLabel.textAlignment = NSTextAlignmentRight;
    self.proLabel.textColor = RGB_color(153);
    [self.view addSubview:self.proLabel];
    [self.proLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.progress.mas_right);
        make.top.equalTo(weakSelf.downButton.mas_top);
        make.height.equalTo(weakSelf.downButton.mas_height);
    }];
}


-(void)downLoadAction:(UIButton *)sender{
    //  https://s3.bytecdn.cn/aweme/resource/web/static/image/index/new-tvc_889b57b.mp4
    
    
    __weak typeof (self) weakSelf = self;
    [self.progress setProgress:0.0 animated:NO];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //创建会话管理者
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    //创建下载路径和请求对象
    NSURL *url = [NSURL URLWithString:@"https://s3.bytecdn.cn/aweme/resource/web/static/image/index/new-tvc_889b57b.mp4"];
    self.downImageView.image = [UIImage thumbnailImageForVideo:url atTime:10];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //创建下载任务
    static float temp = 0.0;
    NSURLSessionDownloadTask *downLoadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.progress setProgress:1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount animated:YES];
            NSString *speed = [NSString stringWithFormat:@"%@",[self formatterWithByte:downloadProgress.completedUnitCount - temp]];
            temp = downloadProgress.completedUnitCount;
            NSString *down = [self formatterWithByte:downloadProgress.completedUnitCount];
            NSString *total = [self formatterWithByte:downloadProgress.totalUnitCount];
            weakSelf.proLabel.text = [NSString stringWithFormat:@"%@/%@   %@/s   %.2f%%",down,total,speed,100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:@"new-tvc_889b57b.mp4"];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];

    //开始下载任务
    [downLoadTask resume];
}


-(void)downLoadControlAction:(UIButton *)sender{
    
}


-(NSString *)formatterWithByte:(float)byte{
    if(byte >= 1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",byte/1024/1024];
    }
    else if(byte >= 1024 && byte < 1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",byte/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",byte];
    }
    return @"";
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
