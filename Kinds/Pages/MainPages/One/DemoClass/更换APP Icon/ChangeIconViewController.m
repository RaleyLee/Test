//
//  ChangeIconViewController.m
//  Kinds
//
//  Created by hibor on 2018/9/5.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ChangeIconViewController.h"
#import <objc/runtime.h>
#import "UIDevice+Helper.h"

@interface ChangeIconViewController ()

@end

@implementation ChangeIconViewController

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method presentM = class_getInstanceMethod(self.class, @selector(presentViewController:animated:completion:));
        Method presentSwizzlingM = class_getInstanceMethod(self.class, @selector(lq_presentViewController:animated:completion:));
        
        method_exchangeImplementations(presentM, presentSwizzlingM);
    });
}

- (void)lq_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        //        NSLog(@"title : %@",((UIAlertController *)viewControllerToPresent).title);
        //        NSLog(@"message : %@",((UIAlertController *)viewControllerToPresent).message);
        
        UIAlertController *alertController = (UIAlertController *)viewControllerToPresent;
        if (alertController.title == nil && alertController.message == nil) {
            return;
        }
    }
    
    [self lq_presentViewController:viewControllerToPresent animated:flag completion:completion];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *iconArray = @[@"first",@"second",@"third"];
    CGFloat x = 10;
    for (int i = 0; i < iconArray.count; i++) {
        UIImageView *iconImageView = [UIImageView new];
        iconImageView.tag = 100 + i;
        iconImageView.backgroundColor = [UIColor redColor];
        iconImageView.image = [UIImage imageNamed:iconArray[i]];
        iconImageView.frame = CGRectMake(i*100+(x*(i+1)), 10, 100, 100);
        iconImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIconAction:)];
        [iconImageView addGestureRecognizer:tap];
        [self.view addSubview:iconImageView];
    }
    
    BOOL first = YES;
    BOOL second = NO;
    BOOL result = first ^ second;
    NSLog(@"%@",result ? @"YES" :@"NO");
    
    
    UIDevice *de = [[UIDevice alloc] init];
    
    long total = [de getTotalDiskSpace];
    long free = [de getFreeDiskSpace];
    long use = [de getUsedDiskSpace];
    
    NSLog(@"total = %ld,free = %ld,use = %ld",total,free,use);
}

-(void)changeIconAction:(UITapGestureRecognizer *)gesture{
    NSArray *iconArray = @[@"first",@"second",@"third"];
    NSInteger index = gesture.view.tag - 100;
    if (@available(iOS 10.3, *)) {
        if (![[UIApplication sharedApplication] supportsAlternateIcons]) {
            return;
        }
        [[UIApplication sharedApplication] setAlternateIconName:iconArray[index] completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"更换app图标发生错误了 ： %@",error);
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    
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
