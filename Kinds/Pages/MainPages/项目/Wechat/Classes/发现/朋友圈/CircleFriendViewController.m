//
//  CircleFriendViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/1.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "CircleFriendViewController.h"
#import "CircleCell.h"
#import "CircleModel.h"
#import <AudioToolbox/AudioToolbox.h>

@interface CircleFriendViewController ()<UITableViewDataSource,UITableViewDelegate,CellOCButtonDelegate>

@property (nonatomic, strong) UITableView *circleTableView;
@property (nonatomic, strong) NSMutableArray *momentListArray;
@property (nonatomic, strong) UIView *tableHeaderView;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIImageView *headImageView;

@property(nonatomic,assign)BOOL ready;
@end

@implementation CircleFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.title = @"朋友圈";
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [photoButton setBackgroundColor:[UIColor redColor]];
    [photoButton setImage:[UIImage imageNamed:@"moment_camera"] forState:UIControlStateNormal];
    photoButton.frame = CGRectMake(0, 0, 40, 40);
    [photoButton addTarget:self action:@selector(tapPressPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *tap1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPhotoAction:)];
    [photoButton addGestureRecognizer:tap1];
    UIBarButtonItem *photoItem = [[UIBarButtonItem alloc] initWithCustomView:photoButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -5;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:spaceItem,photoItem, nil];


    [self setUpUI];

}

-(void)tapPressPhotoAction{
    NSLog(@"123");
}
-(void)longPressPhotoAction:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"321");
    }
}


- (void)setUpUI
{
    // 封面
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, 270)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.contentScaleFactor = [[UIScreen mainScreen] scale];
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    imageView.image = [UIImage imageNamed:@"moment_cover"];
    self.coverImageView = imageView;
    // 用户头像
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-85, self.coverImageView.bottom-40, 75, 75)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    imageView.layer.borderWidth = 2;
    imageView.userInteractionEnabled = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"moment_head"];
    self.headImageView = imageView;
    // 表头
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 270)];
    view.backgroundColor = [UIColor whiteColor];
    view.userInteractionEnabled = YES;
    [view addSubview:self.coverImageView];
    [view addSubview:self.headImageView];
    self.tableHeaderView = view;
    // 表格
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.separatorColor = RGB(225, 225, 224);
    tableView.separatorInset = UIEdgeInsetsZero;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.tableFooterView = [UIView new];
    tableView.tableHeaderView = self.tableHeaderView;
    self.circleTableView = tableView;
    [self.view addSubview:self.circleTableView];
    [self.circleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [self.circleTableView reloadData];
}

-(NSMutableArray *)momentListArray{
    if (!_momentListArray) {
        _momentListArray = [NSMutableArray array];
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CircleList" ofType:@"plist"];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:filePath];
        for (NSDictionary *dict in tempArray) {
            CircleModel *model = [CircleModel mj_objectWithKeyValues:dict];
            [_momentListArray addObject:model];
        }
    }
    return _momentListArray;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.momentListArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleCell *cell = [CircleCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.momentListArray[indexPath.row];
//    cell.mediaView.model = self.momentListArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircleModel *model = self.momentListArray[indexPath.row];
    return model.rowHeight;
    return 500;
}
-(void)ocButtonClickWithIndexPath:(NSIndexPath *)indexPath{
    [self.circleTableView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
}
-(void)addMoment{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HIDDENMENU" object:nil];
    if (scrollView.contentOffset.y <= -10 && !self.ready) {
        AudioServicesPlaySystemSound(1519);
        self.ready = YES;
    }
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y == 0) {
        self.ready = NO;
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
