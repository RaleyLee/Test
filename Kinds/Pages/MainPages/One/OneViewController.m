//
//  OneViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "OneViewController.h"
#import "OneCollectionViewCell.h"
#import <UserNotifications/UserNotifications.h>

#import "PopChooseView.h"
#import "ChangeColorView.h"
#import "DNPayAlertView.h"

#import <LocalAuthentication/LocalAuthentication.h> //指纹识别

@interface DemoModel()

@end

@implementation DemoModel

@end

@interface OneViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property(nonatomic,strong)NSMutableArray *demoArray;
@property(nonatomic,strong)NSMutableArray *canPushArray;

@end

@implementation OneViewController

static NSString *const cellId = @"cellId";

-(NSMutableArray *)demoArray{
    if (!_demoArray) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Demo" ofType:@"plist"];
        _demoArray = [DemoModel mj_objectArrayWithKeyValuesArray:[NSMutableArray arrayWithContentsOfFile:filePath]];
        _canPushArray = [NSMutableArray array];
        for (DemoModel *model in _demoArray) {
            if (model.canPush) {
                [_canPushArray addObject:model];
            }
        }
    }
    return _demoArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //  https://s3.bytecdn.cn/aweme/resource/web/static/image/index/new-tvc_889b57b.mp4 抖音官网视频
   
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.listCollectionView.collectionViewLayout = self.flowLayout;
    
    [self.listCollectionView registerClass:[OneCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    self.listCollectionView.backgroundColor = RGB(240, 240, 240);

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.demoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OneCollectionViewCell *cell = (OneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];

    cell.backgroundColor = [UIColor orangeColor];
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = YES;
    DemoModel *model = self.demoArray[indexPath.item];
    cell.nameLabel.text = model.title;
    cell.canPushImageView.hidden = !model.canPush;
    
    return cell;
}
#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return (CGSize){(SCREEN_WIDTH-30)/5,70};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DemoModel *model = self.demoArray[indexPath.item];
    if (model.canPush) {
        Class c = NSClassFromString(model.page);
        UIViewController *controller = [[c alloc] init];
        [controller setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        if (indexPath.item == 0) {
            PopChooseView *chooseVC = [PopChooseView popChooseView];
            [chooseVC setListDataArray:@[@"默认组",@"分组1",@"分组2",@"分组3",@"分组4",@"分组5",@"分组6"] cancelClick:^{
                
            } addClick:^(NSMutableArray *addArray) {
                NSLog(@"addArray = %@",addArray);
            }];
            chooseVC.popChooseViewStyle = PopChooseViewStyleAdd;
            chooseVC.showNoDataSign = YES;
            chooseVC.showAddCount = YES;
            [chooseVC show];
        }
        if (indexPath.item == 2) {
            ChangeColorView *changeView = [ChangeColorView popChangeView];
            [changeView show];
        }
        if (indexPath.item == 7) {
            DNPayAlertView *payAlert = [[DNPayAlertView alloc]init];
            payAlert.titleStr = @"请输入支付密码";
            payAlert.detail = @"提现";
            payAlert.amount= 10;
            [payAlert show];
            payAlert.completeHandle = ^(NSString *inputPwd) {
                //something
                NSLog(@"pwd = %@",inputPwd);
            };
        }
        if (indexPath.item == 13) {
            LAContext *context = [[LAContext alloc] init];
            context.localizedFallbackTitle = @"输入密码";
            if (@available(iOS 10.0, *)) {
                context.localizedCancelTitle = @"取消";
            } else {
                // Fallback on earlier versions
            }
            NSError *error = nil;
            NSString *result = @"需要验证您的Touch ID";
            if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:result reply:^(BOOL success, NSError * _Nullable error) {
                    if (success) {
                        NSLog(@"验证成功");
                    }else{
                        switch (error.code) {
                            case LAErrorSystemCancel:
                                NSLog(@"切换到其他APP,系统取消验证Touch ID");
                                break;
                            case LAErrorUserCancel:
                                NSLog(@"用户取消验证Touch ID");
                                break;
                            case LAErrorUserFallback:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    //用户选择其他验证，切换到主线程处理
                                    NSLog(@"用户选择其他验证，切换到主线程处理");
                                }];
                            }
                                break;
                            default:
                            {
                                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                    //其他情况，切换到主线程处理
                                    NSLog(@"其他情况，切换到主线程处理");
                                }];
                            }
                                break;
                        }
                    }
                }];
            }else{
                //不支持指纹识别，LOG出错误详情
                switch (error.code) {
                    case LAErrorTouchIDNotEnrolled:
                    {
                        NSLog(@"TouchID is not enrolled");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"A passcode has not been set");
                        break;
                    }
                    default:
                    {
                        NSLog(@"TouchID not available");
                        break;
                    }
                }
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
