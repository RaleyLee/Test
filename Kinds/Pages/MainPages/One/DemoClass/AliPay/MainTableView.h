//
//  MainTableView.h
//  Kinds
//
//  Created by hibor on 2018/8/16.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableView : UITableView

@property (nonatomic, strong) NSMutableArray *homeDataArray;
@property(nonatomic, assign) CGFloat contentOffsetY;

-(void)startRefreshing;
-(void)endRefreshing;

@end
