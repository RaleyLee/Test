//
//  WeContactViewController.m
//  Kinds
//
//  Created by hibor on 2018/7/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "WeContactViewController.h"

@interface WeContactViewController ()<UISearchResultsUpdating,UISearchBarDelegate>

@property(nonatomic,strong)UISearchController *searchController;
@property(nonatomic,strong)NSMutableArray *dataSourceArray;
@property(nonatomic,strong)NSMutableArray *searchArray;

@end

@implementation WeContactViewController

-(NSMutableArray *)searchArray{
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

-(NSMutableArray *)dataSourceArray{
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            [_dataSourceArray addObject:[NSString stringWithFormat:@"测试 - %d",i]];
        }
    }
    return _dataSourceArray;
}

-(UISearchController *)searchController{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = YES;
        _searchController.searchBar.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        _searchController.searchBar.placeholder = @"搜索";
        _searchController.searchBar.delegate = self;
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.definesPresentationContext = YES;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.tableView.contentInset = UIEdgeInsetsMake(-12, 0, 0, 0);
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchArray.count;
    }
    return self.dataSourceArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    if (self.searchController.active) {
        cell.textLabel.text = self.searchArray[indexPath.row];
    }else{
        cell.textLabel.text = self.dataSourceArray[indexPath.row];
    }
    return cell;
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    searchController.searchBar.showsCancelButton = YES;
    
    for(id cc in [searchController.searchBar.subviews[0] subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [btn setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    
    NSString *inputStr = searchController.searchBar.text ;
    if (self.searchArray.count > 0) {
        [self.searchArray removeAllObjects];
    }
    for (NSString *str in self.dataSourceArray) {
        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString].location != NSNotFound) {
            [self.searchArray addObject:str];
        }
    }
    [self.tableView reloadData];
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
