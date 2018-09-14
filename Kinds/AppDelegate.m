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
    
    //http://www.kugou.com/yy/html/search.html
    //获取酷狗搜索数据
    NSString * url = [NSString stringWithFormat:@"http://searchtip.kugou.com/getSearchTip?key=%@",@""];
    
    //http://searchtip.kugou.com/getSearchTip?MusicTipCount=5&MVTipCount=2&albumcount=2&keyword=%E8%87%B4%E5%A7%97%E5%A7%97%E6%9D%A5%E8%BF%9F%E7%9A%84%E4%BD%A0&callback=jQuery19107783217523367846_1536656223581&_=1536656223594
    NSString *key = @"%E8%87%B4%E5%A7%97%E5%A7%97%E6%9D%A5%E8%BF%9F%E7%9A%84%E4%BD%A0";
    NSString *re = [key stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"re = %@",re);
    
    //http://songsearch.kugou.com/song_search_v2?callback=jQuery112408872643457020563_1536656367754&keyword=%E8%87%B4%E5%A7%97%E5%A7%97%E6%9D%A5%E8%BF%9F%E7%9A%84%E4%BD%A0&page=1&pagesize=30&userid=-1&clientver=&platform=WebFilter&tag=em&filter=2&iscorrection=1&privilege_filter=0&_=1536656367756
    
//    UIImage *image = [[UIImage imageNamed:@"rightButton"] imageChangeColor:[UIColor redColor]];
//    NSData *data = UIImagePNGRepresentation(image);
//    [data writeToFile:@"/Users/hibor/Desktop/rightButton.png" atomically:YES];

    NSDictionary *dict = @{
                           @"status":@"1",
                           @"err_code":@"0",
                           @"data":@{
                               @"hash":@"76D4F3FE03CB2BBF012C662A5DC2F548",
                               @"timelength":@"198000",
                               @"filesize":@"3169846",
                               @"audio_name":@"TWICE - 거북이 (乌龟)",
                               @"have_album":@"1",
                               @"album_name":@"twicetagram",
                               @"album_id":@"4418746",
                               @"img":@"http://imge.kugou.com/stdmusic/20171030/20171030175613465016.jpg",
                               @"have_mv":@"0",
                               @"video_id":@"0",
                               @"author_name":@"TWICE",
                               @"song_name":@"거북이 (乌龟)",
                               @"lyrics":@"[00:00.50]TWICE - 乌龟(거북이) [00:00.63]词：정호현 [00:00.93]曲：정호현 [00:01.41]编曲：정호현 [00:10.66]처음엔 아무 느낌 없었는데 [00:14.42]매일 티격 대면서 우리 [00:17.83]싫지는 않았나 봐 [00:20.76]가끔 빤히 나를 바라볼 때면 [00:25.81]어색해질까 봐 [00:27.75]괜히 딴청만 부렸어 [00:30.19]네가 나를 좋아하는 거 [00:32.86]다 알아 근데 그거 알아 [00:35.48]너보다 내가 너를 좀 더 [00:38.13]좋아하는 것 같아 [00:40.49]I mean it 내 마음이 [00:43.09]너보다 앞서가 [00:45.67]Oh no oh no oh no 항상 [00:50.12]늘 이렇게 곁에 [00:52.04]내 옆에 있어 줄래 [00:54.56]조금 느리면 뭐 어때 [00:56.79]나 이렇게 기다릴게 [00:59.87]풍선처럼 커지는 맘이 [01:03.04]펑 펑 터지진 않을까 [01:06.47]내 맘이 자꾸 막 그래 [01:09.87]널 보면 막 그래 [01:14.19]토끼와 거북이처럼 [01:21.47]요즘 따라 자꾸만 더 멋져 보여 [01:25.47]한 번씩 연락 없으면 [01:28.69]괜스레 서운해져 [01:31.45]혹시 내가 너무 앞서간 걸까 [01:36.48]조급해지면 난 [01:38.56]괜한 투정을 부려 [01:40.89]네가 나를 좋아하는 거 [01:43.57]다 알아 근데 그거 알아 [01:46.19]너보다 내가 너를 좀 더 [01:48.92]좋아하는 것 같아 [01:51.28]I mean it 내 마음이 [01:53.78]너보다 앞서가 [01:56.41]Oh no oh no oh no 항상 [02:00.95]늘 이렇게 곁에 [02:02.64]내 옆에 있어 줄래 [02:05.28]조금 느리면 뭐 어때 [02:07.50]나 이렇게 기다릴게 [02:10.61]풍선처럼 커지는 맘이 [02:13.81]펑 펑 터지진 않을까 [02:17.23]내 맘이 자꾸 막 그래 [02:20.61]널 보면 막 그래 [02:22.68]I'm in love with you [02:25.43]조금만 더 서둘러줘 [02:28.10]우린 할 일이 많은데 [02:31.20]늘 이렇게 곁에 [02:33.02]내 옆에 있어 줄래 [02:35.58]조금 느리면 뭐 어때 [02:37.80]나 이렇게 기다릴게 [02:40.96]풍선처럼 커지는 맘이 [02:44.12]펑 펑 터지진 않을까 [02:47.55]내 맘이 자꾸 막 그래 [02:50.88]널 보면 막 그래 [02:55.13]항상 내 마음이 앞서 [03:05.32]토끼와 거북이처럼 ",
                               @"author_id":@"187838",
                               @"privilege":@"8",
                               @"privilege2":@"1000",
                               @"play_url":@"http://fs.w.kugou.com/201809121125/ab48f91d0108648e7f388d06bf537d4b/G110/M0B/10/17/TpQEAFn2_6eAXUzrADBeNr5b-2I567.mp3",
                               @"authors":@[
                               @{
                                   @"is_publish":@"1",
                                   @"author_id":@"187838",
                                   @"avatar":@"20180710115337808.jpg",
                                   @"author_name":@"TWICE"
                               }
                                          ],
                               @"bitrate":@"128"
                           }
                           };
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [data writeToFile:@"/Users/hibor/Desktop/json_wirte.txt" atomically:YES];
    
    
    
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
    

    self.tabbarController = [[KBTabbarController alloc] initWithControllers:@[oneVC,twoVC,threeVC,fourVC] titles:@[@"首页",@"活动",@"更多",@"项目"] normalImages:@[@"tab1-heartshow",@"tab2-doctor",@"tab4-more",@"tab5-file"] selectedImages:@[@"tab1-heart",@"tab2-doctorshow",@"tab4-moreshow",@"tab5-fileshow"] withNavigation:@[nav1,nav2,nav3,nav4] withTintColor:[UIColor purpleColor] withCenterButtonBlock:^(UIButton *centerButton) {

        ModalViewController *modalVC = [[ModalViewController alloc] init];
        modalVC.block = ^{
            [self.tabbarController centerButtonResetStateNormal];
        };
        [self.tabbarController.selectedViewController presentViewController:modalVC animated:YES completion:^{
            
        }];
    }];
    self.tabbarController.tabBar.tintColor = [UIColor redColor];
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
