//
//  WeMenuView.h
//  Kinds
//
//  Created by hibor on 2018/8/2.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeMenuView : UIView

@property (nonatomic, assign) BOOL show;

// 赞
@property (nonatomic, copy) void (^likeMoment)(void);
// 评论
@property (nonatomic, copy) void (^commentMoment)(void);

- (void)menuClick;


@end
