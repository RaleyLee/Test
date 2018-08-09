//
//  ModalViewController.m
//  Kinds
//
//  Created by hibor on 2018/6/21.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ModalViewController.h"
#import "XYMenuAnimateView.h"

@interface ModalViewController ()<XYMenuAnimateViewDelegate>

@property(nonatomic,strong)XYMenuAnimateView *buttonView;

@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self addBlurEffect];
//    [self initSubViews];
}

- (void)initSubViews{
    self.buttonView = [[XYMenuAnimateView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200)];
    self.buttonView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:self.buttonView];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, 200));
    }];
    NSArray *textArr = @[NSLocalizedString(@"文字",nil),NSLocalizedString(@"图片",nil),NSLocalizedString(@"视频",nil),NSLocalizedString(@"语音",nil),NSLocalizedString(@"投票",nil),NSLocalizedString(@"签到",nil),];
    NSMutableArray *imgArr = [NSMutableArray array];
    for (int i = 0; i<textArr.count; i++) {
        NSString *imageName = [NSString stringWithFormat:@"publish_%d",i];
        [imgArr addObject:imageName];
    }
    self.buttonView.textArray = textArr;
    self.buttonView.imageNameArray = imgArr;
    self.buttonView.delegate = self;
    [self.buttonView show];
}

- (void)addBlurEffect {
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.view.bounds;
    //     effectView.alpha = 0.8;
    [self.view addSubview:effectView];
    [self.view sendSubviewToBack:effectView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.block) {
            self.block();
        }
    }];
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
