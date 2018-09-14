//
//  AVPlayerViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/15.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "AVPlayerViewController.h"

@interface AVPlayerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *playTableView;

@property(nonatomic,strong)NSArray *titles,*viewControllers;

@end

@implementation AVPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"视频播放";
    
    self.playTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.playTableView.dataSource = self;
    self.playTableView.delegate = self;
    self.playTableView.tableFooterView = [UIView new];
    [self.view addSubview:self.playTableView];
    [self.playTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titles.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Iden = @"playerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Iden];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Iden];
    }
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
