//
//  WeChatMessageViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "WeChatMessageViewController.h"
#import "MessageListCell.h"
#import "MessageListModel.h"

#import "MessageViewController.h"

@interface WeChatMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong)UITableView *messageTableView;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation WeChatMessageViewController

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
        for (int i = 1; i <= 30; i++) {
            MessageListModel *model = [[MessageListModel alloc] init];
            model.headImage = [NSString stringWithFormat:@"wechat-%d.jpg",i];
            model.name = [NSString stringWithFormat:@"我的昵称%d",i];
            model.content = [NSString stringWithFormat:@"发酵按揭房阿萨德飞人"];
            model.time = [NSString stringWithFormat:@"2018/%d/%d",arc4random()%12+1,arc4random()%28+1];
            model.isDis = (arc4random()%100)%2;
            [_dataSourceArray addObject:model];
        }
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    NSLog(@"data = %@",self.dataSourceArray);
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"diss" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"wechat_add"] style:UIBarButtonItemStylePlain target:self action:@selector(popMenu:)];
//    [self sort];
    
    
    self.messageTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.messageTableView.dataSource = self;
    self.messageTableView.delegate = self;
    [self.messageTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [self.view addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListCell *cell = [MessageListCell cellWithTableView:tableView];
    cell.model = self.dataSourceArray[indexPath.row];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageViewController *messageVC = [[MessageViewController alloc] init];
    [messageVC setHidesBottomBarWhenPushed:YES];
    MessageListModel *model = self.dataSourceArray[indexPath.row];
    messageVC.title = model.name;
    messageVC.iamgeName = model.headImage;
    [self.navigationController pushViewController:messageVC animated:YES];
}



-(void)popMenu:(UIBarButtonItem *)item{

    ZWPullMenuView *menuView = [ZWPullMenuView pullMenuAnchorPoint:CGPointMake(SCREEN_WIDTH, 64) titleArray:@[@"发起群聊",@"添加朋友",@"扫一扫",@"收付款"] imageArray:@[@"wechat_groupChat",@"wechat_addFriend",@"wechat_scanner",@"wechat_cash"]];
    menuView.zwPullMenuStyle = PullMenuDarkStyle;
}
-(void)sort{
    [[RequestTool sharedRequestTool] HBGETRequestDataWithPath:@"http://www.yizhaobiao.net/plus/diqu.php?act=app&xian=1&qu=1" WithParamert:nil isHaveNetWork:^{
        
    } failuare:^{
        
    } success:^(id jsonData) {
        NSLog(@"jsonData = %@",jsonData);
        NSMutableArray *getArray =  [SortModel mj_objectArrayWithKeyValuesArray:jsonData[@"list"]];
        for(NSUInteger i = 0; i < getArray.count - 1; i++) {
            for(NSUInteger j = 0; j < getArray.count - i - 1; j++) {

                NSString *pinyinFirst = [self lowercaseSpellingWithChineseCharacters:[getArray[j] name]];
                NSString *pinyinSecond = [self lowercaseSpellingWithChineseCharacters:[getArray[j+1] name]];
                //此处为升序排序，若要降序排序，把NSOrderedDescending 换为NSOrderedAscending即可。
                if(NSOrderedDescending == [pinyinFirst compare:pinyinSecond]) {
                    SortModel *temp = getArray[j];
                    getArray[j] = getArray[j + 1];
                    getArray[j + 1] = temp;
                }
            }
        }

        for (SortModel *model in getArray) {
            NSLog(@"name = %@",model.name);
        }
    }];
}

-(NSString *)lowercaseSpellingWithChineseCharacters:(NSString *)chinese {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:chinese];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    //返回小写拼音
    return [str lowercaseString];
}


-(void)dismiss{
    [self dismissViewControllerAnimated:YES completion:nil];
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

@implementation SortModel
@end
