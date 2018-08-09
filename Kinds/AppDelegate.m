//
//  AppDelegate.m
//  Kinds
//
//  Created by hibor on 2018/6/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "AppDelegate.h"
#import "KBTabbarController.h"
#import "OneViewController.h"
#import "TwoViewController.h"
#import "ThreeViewController.h"
#import "FourViewController.h"
#import "BaseNavigationViewController.h"
#import "ModalViewController.h"


@interface AppDelegate ()

@property(nonatomic,strong)KBTabbarController *tabbarController;

@end

@implementation AppDelegate


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    CGPoint touchLocation = [[[event allTouches] anyObject] locationInView:self.window];
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    
    if (CGRectContainsPoint(statusBarFrame, touchLocation))
    {
        [self statusBarTouchedAction];
    }
}

- (void)statusBarTouchedAction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kStatusBarTappedNotification object:nil];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    BOOL result = [@"xiaofanlan@aa.com" isEmail];
    
//    UIImage *image = [[UIImage imageNamed:@"rightButton"] imageChangeColor:[UIColor redColor]];
//    NSData *data = UIImagePNGRepresentation(image);
//    [data writeToFile:@"/Users/hibor/Desktop/rightButton.png" atomically:YES];

    //首页
    OneViewController *oneVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"OneViewController"];
    BaseNavigationViewController *nav1 = [[BaseNavigationViewController alloc] initWithRootViewController:oneVC];
    [nav1.navigationBar setBackgroundImage:[UIImage navBGImageWithColor:[UIColor orangeColor]] forBarMetrics:UIBarMetricsDefault];
    [nav1.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
    [nav1.navigationBar setShadowImage:[UIImage new]];
    
    //活动
    TwoViewController *twoVC = [[TwoViewController alloc] init];
    BaseNavigationViewController *nav2 = [[BaseNavigationViewController alloc] initWithRootViewController:twoVC];
    [nav2.navigationBar setBackgroundImage:[UIImage navBGImageWithColor:RGB(228, 19, 72)] forBarMetrics:UIBarMetricsDefault];
    [nav2.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
    [nav2.navigationBar setShadowImage:[UIImage new]];

    
    //更多
    ThreeViewController *threeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThreeViewController"];
    BaseNavigationViewController *nav3 = [[BaseNavigationViewController alloc] initWithRootViewController:threeVC];
    [nav3.navigationBar setBackgroundImage:[UIImage navBGImageWithColor:RGB(76, 161, 245)] forBarMetrics:UIBarMetricsDefault];
    [nav3.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
    
    //设置
    FourViewController *fourVC = [[UIStoryboard storyboardWithName:@"Project" bundle:nil] instantiateViewControllerWithIdentifier:@"FourViewController"];
    BaseNavigationViewController *nav4 = [[BaseNavigationViewController alloc] initWithRootViewController:fourVC];
    [nav4.navigationBar setBackgroundImage:[UIImage navBGImageWithColor:RGB(49, 65, 80)] forBarMetrics:UIBarMetricsDefault];
    [nav4.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:FONT_9_MEDIUM(18)}];
    

    self.tabbarController = [[KBTabbarController alloc] initWithControllers:@[oneVC,twoVC,threeVC,fourVC] titles:@[@"首页",@"活动",@"更多",@"项目"] normalImages:@[@"tab1-heartshow",@"tab2-doctor",@"tab4-more",@"tab5-file"] selectedImages:@[@"tab1-heart",@"tab2-doctorshow",@"tab4-moreshow",@"tab5-fileshow"] withNavigation:@[nav1,nav2,nav3,nav4] withTintColor:nil withCenterButtonBlock:^(UIButton *centerButton) {

        ModalViewController *modalVC = [[ModalViewController alloc] init];
        modalVC.block = ^{
            [self.tabbarController centerButtonResetStateNormal];
        };
        [self.tabbarController.selectedViewController presentViewController:modalVC animated:YES completion:^{
            
        }];
    }];
    
//    [self.tabbarController setCreateCenterButton:YES];
    self.window.rootViewController = self.tabbarController;
    
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];//电池条，白色
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskAll;
    switch (self.orientation) {
        case OritationTypeUP:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case OritationTypeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
            break;
        case OritationTypeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
            break;
        case OritationTypeALL:
            return UIInterfaceOrientationMaskAll;
            break;
        default:
            break;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
