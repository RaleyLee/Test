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
   
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    self.listCollectionView.collectionViewLayout = self.flowLayout;
    
    [self.listCollectionView registerClass:[OneCollectionViewCell class] forCellWithReuseIdentifier:cellId];
    

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
        if (indexPath.item == 3) {
            
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
