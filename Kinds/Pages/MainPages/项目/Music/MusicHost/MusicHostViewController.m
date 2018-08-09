//
//  MusicHostViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MusicHostViewController.h"
#import "MusicToolCell2.h"
#import "MusicCell.h"
#import "MusicHeaderSectionView.h"

#import "MusicHostModel.h"
#import "MusicHostContentModel.h"

@interface MusicHostViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *listCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_LeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionView_RightLayout;
@property(nonatomic,strong)UICollectionViewFlowLayout *flowLayout;

@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UIView *toolView;
@property(nonatomic,strong)UIImageView *iconImageView;
@property(nonatomic,strong)UIView *backView1,*backView2;

@property(nonatomic,strong)NSMutableArray *dataSourceArray;

@end

@implementation MusicHostViewController


-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MusicHost" ofType:@"plist"];
        NSArray *tempArray = [NSArray arrayWithContentsOfFile:path];
        _dataSourceArray = [NSMutableArray array];
        for (NSDictionary *dict in tempArray) {
            MusicHostModel *hotModel = [MusicHostModel mj_objectWithKeyValues:dict];
            NSArray *tempContentArray = dict[@"content"];
            NSMutableArray *temp = [NSMutableArray array];
            for (NSDictionary *dict in tempContentArray) {
                MusicHostContentModel *model = [MusicHostContentModel mj_objectWithKeyValues:dict];
                [temp addObject:model];
            }
            hotModel.contentArray = temp;
            [_dataSourceArray addObject:hotModel];
        }
    }
    return _dataSourceArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RGB(49, 65, 80);
    
    NSLog(@"dataSource = %@",self.dataSourceArray); 
    
    self.flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.listCollectionView.collectionViewLayout = self.flowLayout;
    self.listCollectionView.backgroundColor = RGB(49, 65, 80);
    
    [self.listCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"host0"];
    [self.listCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"host1"];



    [self.listCollectionView registerClass:[MusicToolCell2 class] forCellWithReuseIdentifier:@"MusicToolCell2"];
    [self.listCollectionView registerClass:[MusicCell class] forCellWithReuseIdentifier:@"music_cell"];
    
    [self.listCollectionView registerClass:[MusicHeaderSectionView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
//    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) delegate:self placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:CGSizeMake(SCREEN_WIDTH, 150)]];
//    cycleScrollView.imageURLStringsGroup = @[@"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//                                             @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//                                             @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//                                             ];
    
    
    
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3 + self.dataSourceArray.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 1;
    }
    if (section == 2) {
        return 1;
    }
    MusicHostModel *hostModel = self.dataSourceArray[section-3];
    
    return hostModel.contentArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        static NSString *iden = @"host0";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
        
        [cell.contentView addSubview:self.cycleScrollView];
        return cell;
    }else if (indexPath.section == 1) {
        
        static NSString *iden = @"host1";
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
        [cell.contentView addSubview:self.toolView];
        return cell;
    }else if (indexPath.section == 2){
        
        MusicToolCell2 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MusicToolCell2" forIndexPath:indexPath];
        return cell;

    }
    MusicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"music_cell" forIndexPath:indexPath];
    cell.iconImageView.backgroundColor = [UIColor redColor];

    MusicHostModel *hostModel = self.dataSourceArray[indexPath.section-3];
    [cell setTuiJianCollectionCellWithModel:hostModel.contentArray[indexPath.item]];
    return cell;
    
    
}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return (CGSize){SCREEN_WIDTH,150};
    }
    if (indexPath.section == 1) {
        return (CGSize){SCREEN_WIDTH-10,85};
    }
    if (indexPath.section == 2) {
        return (CGSize){SCREEN_WIDTH-10,125};
    }
    return (CGSize){(SCREEN_WIDTH-20)/3,150};
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section == 0) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (section == 2) {
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{

    return 5.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld分item",(long)indexPath.row);
}

#pragma mark ————————— Header的大小 size —————————————
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(self.view.frame.size.width, section > 2 ? 50 : 0);
}
#pragma mark ————————— 自定义分区头  —————————————
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        MusicHeaderSectionView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        MusicHostModel *hostModel = self.dataSourceArray[indexPath.section-3];
        headerView.titleString = hostModel.sectionTitle;
        reusableview = headerView;
    }
    return reusableview;
    
}

-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, 85)];
        _toolView.backgroundColor = RGB(49, 65, 80);
        NSArray *tempArray = @[@"歌手",@"排行",@"分类歌单",@"电台",@"视频"];
        CGFloat sapcing = 10;
        CGFloat width = (_toolView.frame.size.width-(sapcing*(tempArray.count+1)))/tempArray.count;
        for (int i = 0; i < tempArray.count; i++) {
            TButton *button = [TButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageWithColor:RGB(3, 167, 238) size:CGSizeMake(30, 30)] forState:UIControlStateNormal];
            [button setTitle:tempArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = FONT_9_REGULAR(14);
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.frame = CGRectMake((width+sapcing)*i+sapcing, 0, width, 85);
            button.imageRect = CGRectMake((width-30)/2, 15, 30, 30);
            button.titleRect = CGRectMake(0, 45, width, 30);
            [_toolView addSubview:button];
        }
        
        
    }
    return _toolView;
}

-(SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        NSMutableArray *bannerArray = [NSMutableArray array];
        for (int i = 0; i < 10; i++) {
            [bannerArray addObject:[NSString stringWithFormat:@"banner%d.jpg",i]];
        }
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150) imageNamesGroup:bannerArray];
    }
    return _cycleScrollView;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [UIImageView new];
        _iconImageView.image = [UIImage imageWithColor:[UIColor orangeColor] size:CGSizeMake(125, 125)];
    }
    return _iconImageView;
}
-(UIView *)backView1{
    if (!_backView1) {
        _backView1 = [UIView new];
        _backView1.backgroundColor = [UIColor purpleColor];
    }
    return _backView1;
}
-(UIView *)backView2{
    if (!_backView2) {
        _backView2 = [UIView new];
        _backView2.backgroundColor = [UIColor magentaColor];
    }
    return _backView1;
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
