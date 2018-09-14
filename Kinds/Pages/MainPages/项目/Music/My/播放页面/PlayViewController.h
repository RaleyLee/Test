//
//  PlayViewController.h
//  Kinds
//
//  Created by hibor on 2018/9/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface PlayViewController : UIViewController

@property(nonatomic,strong) SongModel *currentModel;
@property(nonatomic,strong) NSMutableArray *songListArray;

@property(nonatomic,assign) NSInteger songIndex;

@end
