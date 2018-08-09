//
//  WeMenuView.m
//  Kinds
//
//  Created by hibor on 2018/8/2.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "WeMenuView.h"


// 操作按钮的宽度
#define kOperateBtnWidth    30
// 操作视图的高度
#define kOperateHeight      38
// 操作视图的高度
#define kOperateWidth       200

@interface WeMenuView()

@property(nonatomic,strong)UIView *menuView;
@property(nonatomic,strong)UIButton *menuButon;

@end

@implementation WeMenuView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.show = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenMenu) name:@"HIDDENMENU" object:nil];
        
        UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(kOperateWidth-kOperateBtnWidth, 0, kOperateWidth-kOperateBtnWidth, kOperateHeight)];
        containView.backgroundColor = RGB(70, 74, 75);
        containView.layer.cornerRadius = 4.0;
        containView.layer.masksToBounds = YES;
        
        //赞
        UUButton *zanButton = [UUButton buttonWithType:UIButtonTypeCustom];
        zanButton.frame = CGRectMake(0, 0, containView.width/2, kOperateHeight);
        zanButton.spacing = 3;
        zanButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [zanButton setTitle:@"赞" forState:UIControlStateNormal];
        [zanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [zanButton setImage:[UIImage imageNamed:@"moment_like"] forState:UIControlStateNormal];
        [zanButton addTarget:self action:@selector(likeClick) forControlEvents:UIControlEventTouchUpInside];
        [containView addSubview:zanButton];
        
        // 分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(zanButton.right, 8, 0.5, kOperateHeight-16)];
        line.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
        [containView addSubview:line];
        
        //评论
        UUButton *commentButton = [UUButton buttonWithType:UIButtonTypeCustom];
        commentButton.frame = CGRectMake(line.right, 0, zanButton.width, kOperateHeight);
        commentButton.spacing = 3;
        commentButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [commentButton setTitle:@"评论" forState:UIControlStateNormal];
        [commentButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commentButton setImage:[UIImage imageNamed:@"moment_comment"] forState:UIControlStateNormal];
        [commentButton addTarget:self action:@selector(commentClick) forControlEvents:UIControlEventTouchUpInside];
        [containView addSubview:commentButton];
        
        self.menuView = containView;
        [self addSubview:self.menuView];
        
        
        UIButton *toolButton = [UIButton buttonWithType:UIButtonTypeCustom];
        toolButton.frame = CGRectMake(kOperateWidth-kOperateBtnWidth, 0, kOperateBtnWidth, kOperateHeight);
        [toolButton setImage:[UIImage imageNamed:@"moment_operate"] forState:UIControlStateNormal];
        [toolButton setImage:[UIImage imageNamed:@"moment_operate_hl"] forState:UIControlStateHighlighted];
        [toolButton addTarget:self action:@selector(menuClick) forControlEvents:UIControlEventTouchUpInside];
        self.menuButon = toolButton;
        [self addSubview:self.menuButon];
        
    }
    return self;
}

-(void)hiddenMenu{
    self.show = NO;
}

-(void)setShow:(BOOL)show{
    _show = show;
    CGFloat menu_left = kOperateWidth-kOperateBtnWidth;
    CGFloat menu_width = 0;
    if (_show) {
        menu_left = 0;
        menu_width = kOperateWidth-kOperateBtnWidth;
    }
    self.menuView.width = menu_width;
    self.menuView.left = menu_left;
}


#pragma mark - 事件
- (void)menuClick
{
    _show = !_show;
    CGFloat menu_left = kOperateWidth-kOperateBtnWidth;
    CGFloat menu_width = 0;
    if (_show) {
        menu_left = 0;
        menu_width = kOperateWidth-kOperateBtnWidth;
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.menuView.width = menu_width;
        self.menuView.left = menu_left;
    }];
}

- (void)likeClick
{
    if (self.likeMoment) {
        self.likeMoment();
    }
    [self menuClick];
}

- (void)commentClick
{
    if (self.commentMoment) {
        self.commentMoment();
    }
    [self menuClick];
}


@end
