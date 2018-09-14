//
//  AliPayHomeViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "AliPayHomeViewController.h"

#import "AliPayNavView.h"
#import "AliPayNavComView.h"
#import "AliPayHomeClassView.h"
#import "MainTableView.h"
#import "UIView+LoadNib.h"

@interface AliPayHomeViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)AliPayNavView *navView; //滑动前的nav
@property(nonatomic,strong)AliPayNavComView *comView;  //滑动后的nav

@property(nonatomic,strong)UIScrollView *mainScrollView;
@property(nonatomic,assign)CGFloat headerViewH;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)AliPayHomeClassView *functionView;
@property(nonatomic,strong)MainTableView *listTableView;

@end

const CGFloat classViewY = 64;
const CGFloat functionHeaderViewHeight = 90;

@implementation AliPayHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
-(void)setupSubView{
    self.navView = [AliPayNavView createWithXib];
    self.navView.frame = CGRectMake(0, 0, SCREEN_WIDTH, classViewY);
    [self.view addSubview:self.navView];
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(classViewY);
    }];
    
    self.comView = [AliPayNavComView createWithXib];
    self.comView.frame = CGRectMake(0, 0, SCREEN_WIDTH, classViewY);
    [self.view addSubview:self.comView];
    [self.comView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(classViewY);
    }];
    self.comView.alpha = 0;
    
    UITableView *ta = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:UITableViewStylePlain];
    ta.dataSource = self;
    ta.delegate = self;
    [self.view addSubview:ta];
    [ta mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64);
        make.left.bottom.right.mas_equalTo(0);
//        make.edges.equalTo(self.view);
    }];
    return;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, classViewY, SCREEN_WIDTH, SCREEN_HEIGHT-classViewY)];
    self.mainScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(_headerViewH, 0, 0, 0);
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
//    [self.mainScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(classViewY, 0, 0, 0));
//    }];
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _headerViewH)];
    self.headerView.backgroundColor = [UIColor redColor];
    
    self.functionView = [AliPayHomeClassView createWithXib];
    self.functionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, functionHeaderViewHeight);
    [self.headerView addSubview:self.functionView];
    
    self.listTableView = [[MainTableView alloc] init];
    CGFloat mainTableViewH = 120 + _headerViewH;
    self.listTableView.frame = CGRectMake(0, _headerViewH, SCREEN_WIDTH, mainTableViewH);
    self.listTableView.contentSize = CGSizeMake(0, mainTableViewH);
    
    [self.mainScrollView addSubview:self.listTableView];
    [self.mainScrollView addSubview:self.headerView];
}

#pragma mark scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGFloat alpha1 = (1 - y/functionHeaderViewHeight * 2.5 ) > 0 ? (1 - y/functionHeaderViewHeight * 2.5 ) : 0;
    if (alpha1 > 0.5) {
        CGFloat newAlpha = alpha1*2 - 1;
        self.navView.alpha = newAlpha;
        self.comView.alpha = 0;
    } else {
        CGFloat newAlpha = alpha1*2;
        self.navView.alpha = 0;
        self.comView.alpha = 1 - newAlpha;
    }
    return;
    if (y <= 0) {
        CGRect newFrame = self.headerView.frame;
        newFrame.origin.y = y;
        self.headerView.frame = newFrame;
        
        newFrame = self.listTableView.frame;
        newFrame.origin.y = y + _headerViewH;
        self.listTableView.frame = newFrame;
        
        //设置tableview的偏移量
        self.listTableView.contentOffsetY = y;
        
        newFrame = self.functionView.frame;
        newFrame.origin.y = 0;
        self.functionView.frame = newFrame;
    } else {
        CGRect newFrame = self.functionView.frame;
        newFrame.origin.y = y/2;
        self.functionView.frame = newFrame;
    }
    
    CGFloat alpha = (1 - y/functionHeaderViewHeight * 2.5 ) > 0 ? (1 - y/functionHeaderViewHeight * 2.5 ) : 0;
    self.functionView.alpha = alpha;
    if (alpha > 0.5) {
        CGFloat newAlpha = alpha*2 - 1;
        self.navView.alpha = newAlpha;
        self.comView.alpha = 0;
    } else {
        CGFloat newAlpha = alpha*2;
        self.navView.alpha = 0;
        self.comView.alpha = 1 - newAlpha;
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
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
