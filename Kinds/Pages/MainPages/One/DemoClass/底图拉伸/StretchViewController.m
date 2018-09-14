//
//  StretchViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/10.
//  Copyright © 2018年 hibor. All rights reserved.
//

//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？


#import "StretchViewController.h"
#import "UserCardView.h"

@interface StretchViewController ()

@property(nonatomic,strong)UIImageView *screenImageView;

@end

@implementation StretchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTakeScreenshotNotification) name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
//    StretchButton *button = [StretchButton buttonWithType:UIButtonTypeCustom];
//    [button setTitle:@"我的老家" forState:UIControlStateNormal];
//    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [self.view addSubview:button];
//    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(30);
//        make.size.mas_equalTo(CGSizeMake(100, 50));
//    }];
    
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"我的老家就在这个屯" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[[UIImage imageNamed:@"buttonBGImage"] imageWithRenderingMode:UIImageRenderingModeAutomatic] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(speechVoice) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
//    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(30);
//        make.top.mas_equalTo(100);
//        make.size.mas_equalTo(CGSizeMake(200, 50));
//    }];
    
    
    
    UserCardView *car = [[UserCardView alloc] init];
    [self.view addSubview:car];
    [car mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(car.frame.size.height);
    }];
    
    
    
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"测试" forState:UIControlStateNormal];
    testButton.backgroundColor = [UIColor orangeColor];
    testButton.frame = CGRectMake(100, 300, 100, 50);

    [self.view addSubview:testButton];
    [self setViewLayer:testButton corner:5];

}

-(void)setViewLayer:(UIView *)view corner:(CGFloat)cornerRadius{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, view.width, view.height);
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, view.width, view.height);
    borderLayer.lineWidth = 1.f;
    borderLayer.strokeColor = [UIColor purpleColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, view.width, view.height) cornerRadius:cornerRadius];
    maskLayer.path = bezierPath.CGPath;
    borderLayer.path = bezierPath.CGPath;
    
    [view.layer insertSublayer:borderLayer atIndex:0];
    [view.layer setMask:maskLayer];
}

-(void)setTheCornerWithTheView:(UIView *)subView andWithTheWidth:(float)widths{
    
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:subView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(widths, widths)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer1.frame = subView.bounds;
    //设置图形样子
    maskLayer1.path = maskPath1.CGPath;
    subView.layer.mask = maskLayer1;
    
}

-(void)speechVoice{
    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"我的老家 哎 就住在这个屯 我是这个屯里 土生土长的人 别看屯子不咋大呀 有山有水有树林  邻里乡亲挺和睦 老少爷们更合群 屯子里面发生过 许多许多地事 回想起那是 特别的哏  朋友们若是有兴趣呀 我领你认识认识 认识认识我们屯里的人  我的老家 哎 就住在那个屯  我是那个屯里 土生土长的人 别看屯子不咋大呀 有山有水有树林 邻里乡亲挺和睦 老少爷们更合群"];
    utterance.rate=0.5;
    AVSpeechSynthesisVoice*voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.voice= voice;
    
    [av speakUtterance:utterance];
}


-(void)userDidTakeScreenshotNotification{
    UIImage *iamge = [self imageWithScreenshot];
    NSData *imageData = UIImagePNGRepresentation(iamge);
//    [imageData writeToFile:@"/Users/hibor/Desktop/aa.png" atomically:YES];
    self.screenImageView.image = iamge;
    [self.screenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(112.5, 170.4));
    }];
}

-(UIImageView *)screenImageView{
    if (!_screenImageView) {
        self.screenImageView = [UIImageView new];
        self.screenImageView.layer.borderColor = RGB_color(200).CGColor;
        self.screenImageView.layer.borderWidth = 0.5f;
        [self.view addSubview:self.screenImageView];
    }
    return _screenImageView;
}

// 代码截屏
- (UIImage *)imageWithScreenshot {
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        imageSize = [UIScreen mainScreen].bounds.size;
    } else {
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    }
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft) {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        } else if (orientation == UIInterfaceOrientationLandscapeRight) {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        } else {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *imageData = UIImagePNGRepresentation(image);
    UIImage *screenImage = [UIImage imageWithData:imageData];
    return screenImage;
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
