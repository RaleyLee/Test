//
//  KBTabbarController.m
//  KBTabbarController
//
//  Created by kangbing on 16/5/31.
//  Copyright © 2016年 kangbing. All rights reserved.
//

#import "KBTabbarController.h"
#import "OneViewController.h"
#import "ThreeViewController.h"

#import "KBTabbar.h"
#import "KBStyle.h"

#import "BaseNavigationViewController.h"
#import "AppDelegate.h"

//struct KBStyle {
//    __unsafe_unretained UIColor *KBbarTintColor;
//    __unsafe_unretained UIColor *KBtintColor;
//    __unsafe_unretained UIFont *KBtitleFont;
//};
//typedef struct KBStyle KBStyle;
//typedef struct{
//   __unsafe_unretained UIColor *KBbarTintColor;
//   __unsafe_unretained UIColor *KBtintColor;
//   __unsafe_unretained UIFont *KBtitleFont;
//}KBStyle;


@interface KBTabbarController ()<UIAlertViewDelegate,UITabBarControllerDelegate>

@property(nonatomic,strong)NSArray *contollers;
@property(nonatomic,strong)UIColor *barTintColor;

@end

@implementation KBTabbarController


-(instancetype)initWithControllers:(NSArray *)controlls titles:(NSArray *)titles normalImages:(NSArray *)normals selectedImages:(NSArray *)selecteds withNavigation:(NSArray<UINavigationController *> *)navControlls withTintColor:(UIColor *)tintColor withCenterButtonBlock:(centerButtonBlock)block{
    if (self = [super init]) {
        self.centerBlock = block;
        self.delegate = self;
        self.barTintColor = tintColor;
        for (int i = 0; i < controlls.count; i++) {

            [self addChildController:controlls[i] title:titles[i] imageName:normals[i] selectedImageName:selecteds[i] navVc:navControlls[i]];

        }
        self.contollers = controlls;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UITabBar appearance] setBackgroundImage:[self imageWithColor:[UIColor whiteColor]]];
    //  设置tabbar
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];

}


-(void)setCreateCenterButton:(BOOL)createCenterButton{
    if (createCenterButton) {
        [self setCustomtabbar];
    }
}

- (void)setCustomtabbar{
    if (self.contollers.count % 2 == 1) {
        return;
    }
    KBTabbar *tabbar = [[KBTabbar alloc]init];
    tabbar.buttonTotalCount = self.contollers.count;
    [self setValue:tabbar forKeyPath:@"tabBar"];
    [tabbar.centerBtn addTarget:self action:@selector(centerBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)centerBtnClick:(UIButton *)btn{
    if (self.centerBlock) {
        self.centerBlock(btn);
        [self centerButtonRotationDegress45:btn];
    }else{
        NSLog(@"点击了中间");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"点击了中间按钮" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)centerButtonResetStateNormal{
    KBTabbar *tabBar = (KBTabbar *)[self valueForKeyPath:@"tabBar"];
    [UIView animateWithDuration:0.2f animations:^{
        if (tabBar.centerBtn) {
            tabBar.centerBtn.transform = CGAffineTransformMakeRotation(0);;
        }
    }];
}

-(void)centerButtonRotationDegress45:(UIButton *)centerButton{
    
    if (!centerButton) {
        KBTabbar *tabBar = (KBTabbar *)[self valueForKeyPath:@"tabBar"];
        centerButton = tabBar.centerBtn;
    }
    [UIView animateWithDuration:0.2f animations:^{
        if (centerButton) {
            centerButton.transform = CGAffineTransformMakeRotation(M_PI_4);;
        }
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addChildController:(UIViewController*)childController title:(NSString*)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName navVc:(UINavigationController *)navVc;
{

    childController.title = title;
    childController.tabBarItem.image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childController.tabBarItem.selectedImage = [[[UIImage imageNamed:selectedImageName] imageWithColor:self.barTintColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置一下选中tabbar文字颜色
    
    [childController.tabBarItem setTitleTextAttributes:@{ NSForegroundColorAttributeName : self.barTintColor ? self.barTintColor :[UIColor darkGrayColor] }forState:UIControlStateSelected];
    
    if (navVc) {
        [navVc.navigationBar setShadowImage:[UIImage new]];
        [self addChildViewController:navVc];
    }else{
        [self addChildViewController:childController];
    }

}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    return;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (tabBarController.selectedIndex == 1) {
        app.orientation = OritationTypeALL;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else{
        app.orientation = OritationTypeUP;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
}


- (UIImage *)imageWithColor:(UIColor *)color{
    // 一个像素
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


@end
