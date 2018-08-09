//
//  MyMusicViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/11.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MyMusicViewController.h"

#import "MyMusicHeaderView.h"
#import "MyMusicItemView.h"
#import "SongListCell.h"

#import "MusicBottomView.h"

#import "AppDelegate.h"

@interface MyMusicViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_RightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableview_LeftLayout;

@property(nonatomic,strong)UIView *toolView;

@property(nonatomic,strong)NSMutableDictionary *pageDiction;
@property(nonatomic,assign)NSInteger selectedIndex;

@property(nonatomic,strong)MusicBottomView *bottomView;

@end

@implementation MyMusicViewController

-(NSMutableDictionary *)pageDiction{
    if (!_pageDiction) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"MyPageDis" ofType:@"plist"];
        _pageDiction = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    }
    return _pageDiction;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeBottomView) name:@"REMOVEBOTTOMVIEW" object:nil];
    
    self.view.backgroundColor = RGB(36, 43, 56);
    
    self.listTableView.backgroundColor = [UIColor clearColor];
    
    MyMusicHeaderView *headerView = [[MyMusicHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 140)];
    self.listTableView.tableHeaderView = headerView;
    self.listTableView.tableFooterView = [UIView new];
    self.listTableView.separatorColor = [UIColor clearColor];
   
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(50);
    }];
}

-(void)removeBottomView{
    [_bottomView removeFromSuperview];
    _bottomView = nil;
}
-(MusicBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[MusicBottomView alloc] init];
    }
    return _bottomView;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    NSInteger numbers = 0;
    if (_selectedIndex == 0) {
        numbers = [self.pageDiction[@"songList_self"] count];
    }else if (_selectedIndex == 1){
        numbers = [self.pageDiction[@"songList_collect"] count];
    }
    return 2+numbers+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *iden = @"iden";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *view in [cell.contentView subviews]) {
            [view removeFromSuperview];
        }
        for (int i = 0; i < [self.pageDiction[@"myTool"] count]; i++) {
            int row = i / 3;
            int col = i % 3;
            
            MyMusicItemView *itemView = [[MyMusicItemView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*col, 100*row, SCREEN_WIDTH/3, 100)];
            itemView.diction = self.pageDiction[@"myTool"][i];
            itemView.itemTag = i;
            itemView.clickItemBlock = ^(NSInteger tag) {
                NSLog(@"%ld",tag);
            };
            [cell.contentView addSubview:itemView];
            
        }
        
        return cell;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            static NSString *iden = @"iden1";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
                cell.backgroundColor = RGB(49, 65, 80);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in [cell.contentView subviews]) {
                [view removeFromSuperview];
            }
            
            [cell.contentView addSubview:self.toolView];
            [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(200, 40));
            }];
            return cell;
        }else if (indexPath.row == 1) {
            static NSString *iden = @"iden2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
                cell.backgroundColor = RGB(49, 65, 80);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in [cell.contentView subviews]) {
                [view removeFromSuperview];
            }
            
            UILabel *numberLabel = [UILabel new];
            numberLabel.font = FONT_9_REGULAR(15);
            numberLabel.textColor = [UIColor whiteColor];
            NSInteger numbers = 0;
            if (_selectedIndex == 0) {
                numbers = [self.pageDiction[@"songList_self"] count];
            }else if (_selectedIndex == 1){
                numbers = [self.pageDiction[@"songList_collect"] count];
            }
            numberLabel.text = [NSString stringWithFormat:@"%ld个歌单",numbers];
            [numberLabel sizeToFit];
            [cell.contentView addSubview:numberLabel];
            [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(10);
                make.centerY.equalTo(cell.contentView);
            }];
            
            UIButton *manageButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [manageButton setBackgroundColor:[UIColor greenColor]];
            [manageButton addTarget:self action:@selector(manageSongListAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:manageButton];
            [manageButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(-15);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
            
            UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [addButton setBackgroundColor:[UIColor greenColor]];
            addButton.hidden = _selectedIndex;
            [addButton addTarget:self action:@selector(addSongListAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:addButton];
            [addButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(manageButton.mas_left).offset(-15);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_equalTo(CGSizeMake(30, 30));
            }];
            return cell;
        }else{
            static NSString *iden = @"iden3";
            SongListCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[SongListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
                cell.backgroundColor = RGB(49, 65, 80);
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            NSInteger numbers = 0;
            if (_selectedIndex == 0) {
                numbers = [self.pageDiction[@"songList_self"] count];
            }else if (_selectedIndex == 1){
                numbers = [self.pageDiction[@"songList_collect"] count];
            }
            if (indexPath.row == 2+numbers) {
                cell.listType = 1;
            }else{
                cell.listType = 0;
            }
            return cell;
        }
        
        
    }
    
    return nil;
}

#pragma mark - 添加歌单
-(void)addSongListAction{
    
    NSLog(@"添加歌单");
    
    
}

#pragma mark - 管理歌单
-(void)manageSongListAction{
    
    NSLog(@"管理歌单");
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.row < 2) {
        return;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        return 200;
    }
    if (indexPath.row < 2) {
        return 40;
    }
    return 60;
}

-(UIView *)toolView{
    if (!_toolView) {
        _toolView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        NSArray *titleArray = @[@"自建歌单",@"收藏歌单"];
        for (int i = 0 ; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            button.titleLabel.font = FONT_9_REGULAR(15);
            button.frame = CGRectMake(100*i, 0, 100, 40);
            if (i == _selectedIndex) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:RGB(149, 157, 163) forState:UIControlStateNormal];
            }
            button.tag = 200+i;
            [button addTarget:self action:@selector(changeSongListAction:) forControlEvents:UIControlEventTouchUpInside];
            [_toolView addSubview:button];
        }
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 10, 1, 20)];
        view.backgroundColor = [UIColor whiteColor];
        [_toolView addSubview:view];
    }
    return _toolView;
}

-(void)changeSongListAction:(UIButton *)sender{
    _selectedIndex = sender.tag - 200;
    [self.listTableView reloadData];
    NSArray *viewArray = [_toolView subviews];
    for (int i = 0; i < viewArray.count; i++) {
        if ([viewArray[i] isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)viewArray[i];
            if (i == _selectedIndex) {
                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else{
                [button setTitleColor:RGB(149, 157, 163) forState:UIControlStateNormal];
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
