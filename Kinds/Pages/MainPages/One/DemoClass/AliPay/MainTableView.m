//
//  MainTableView.m
//  Kinds
//
//  Created by hibor on 2018/8/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "MainTableView.h"

@interface MainTableView ()<UITableViewDataSource,UITableViewDelegate>

@end

static NSString *cellID = @"MainTableViewCell";

@implementation MainTableView

-(NSMutableArray *)homeDataArray{
    if (_homeDataArray == nil) {
        _homeDataArray = [[NSMutableArray alloc] init];
        for (int i = 1; i <= 20; i++) {
            NSString *imageName = [NSString stringWithFormat:@"%d",i];
            [_homeDataArray addObject:imageName];
        }
    }
    return _homeDataArray;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
        self.backgroundColor = RGB_random;
        self.scrollEnabled = NO;
    }
    return self;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    _contentOffsetY = contentOffsetY;
    if (![self.mj_header isRefreshing]) {
        self.contentOffset = CGPointMake(0, contentOffsetY);
    }
}

- (void)startRefreshing {
    [self.mj_header beginRefreshing];
}
- (void)endRefreshing {
    [self.mj_header endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = self.homeDataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
