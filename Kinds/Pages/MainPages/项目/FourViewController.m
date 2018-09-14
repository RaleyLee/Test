//
//  FourViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "FourViewController.h"
#import "KBTabbarController.h"
#import "BaseNavigationViewController.h"

#import "ProjectCell.h"
#import "ProjectModel.h"
#import "MusicViewController.h"


#import "WeChatMessageViewController.h"
#import "WeContactViewController.h"
#import "WeFindViewController.h"
#import "WeMeViewController.h"


#import "DownLoadViewController.h"
#import "DownListViewController.h"
#import "DownViewController.h"


@interface FourViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *proTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;

@property(nonatomic,strong)NSMutableArray *proArray;


@end

@implementation FourViewController

-(NSMutableArray *)proArray{
    if (!_proArray) {
        _proArray = [NSMutableArray array];
        NSString *proPath = [[NSBundle mainBundle] pathForResource:@"Project" ofType:@"plist"];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:proPath];
        for (NSDictionary *dict in tempArray) {
            ProjectModel *model = [ProjectModel mj_objectWithKeyValues:dict];
            [_proArray addObject:model];
        }
    }
    return _proArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSLog(@"array = %@",self.proArray);
    [self.proTableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.proArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"project";
    ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[ProjectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    ProjectModel *model = self.proArray[indexPath.row];
//    Class pushClass = NSClassFromString(model.proUrl);
    if (!model.canPush) { //!pushClass
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.pModel = self.proArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        //[UIImage navBGImageWithColor:RGB(49, 65, 80)]
        WeChatMessageViewController *chatVC = [[WeChatMessageViewController alloc] init];
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:chatVC];
        [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        [nav1.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
        
        WeContactViewController *contactVC = [[WeContactViewController alloc] init];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:contactVC];
        [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        [nav2.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
        
        WeFindViewController *findVC = [[WeFindViewController alloc] init];
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:findVC];
        [nav3.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        [nav3.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
        
        WeMeViewController *meVC = [[WeMeViewController alloc] init];
        BaseNavigationViewController *nav4 = [[BaseNavigationViewController alloc] initWithRootViewController:meVC];
        [nav4.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        [nav4.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
        
        KBTabbarController *weTabbar = [[KBTabbarController alloc] initWithControllers:@[chatVC,contactVC,findVC,meVC] titles:@[@"微信",@"通讯录",@"发现",@"我"] normalImages:@[@"tabbar_mainframe",@"tabbar_contacts",@"tabbar_discover",@"tabbar_me"] selectedImages:@[@"tabbar_mainframeHL",@"tabbar_contactsHL",@"tabbar_discoverHL",@"tabbar_meHL"] withNavigation:@[nav1,nav2,nav3,nav4] withTintColor:[UIColor greenColor] withCenterButtonBlock:nil];
        [self presentViewController:weTabbar animated:YES completion:nil];
        
    }else if (indexPath.row == 4) {
        DownListViewController *listVC = [[DownListViewController alloc] init];
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:listVC];
        [nav1.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        [nav1.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
        
        DownViewController *downVC = [[DownViewController alloc] init];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:downVC];
        [nav2.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigaitonbar"] forBarMetrics:UIBarMetricsDefault];
        [nav2.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
        
        KBTabbarController *weTabbar = [[KBTabbarController alloc] initWithControllers:@[listVC,downVC] titles:@[@"视频列表",@"下载"] normalImages:@[@"tabbar_mainframe",@"tabbar_contacts"] selectedImages:@[@"tabbar_mainframeHL",@"tabbar_contactsHL"] withNavigation:@[nav1,nav2] withTintColor:[UIColor greenColor] withCenterButtonBlock:nil];
        [self presentViewController:weTabbar animated:YES completion:nil];
    }
    else{
        ProjectModel *model = self.proArray[indexPath.row];
        Class pushClass = NSClassFromString(model.proUrl);
        if (!pushClass) {
            return;
        }
        UIViewController *controller = [[pushClass alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
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
