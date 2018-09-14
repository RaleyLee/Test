//
//  PuzzleViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/30.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "PuzzleViewController.h"
#import "BlockAlertView.h"
#import <Photos/Photos.h>
#import "CCPhotLibraryViewController.h"
#import <TOCropViewController.h>

@interface PuzzleViewController ()<CCPhotLibraryViewControllerDelegate,TOCropViewControllerDelegate,CAAnimationDelegate>

@property(nonatomic,strong)CCPhotLibraryViewController *photoVC;
@property(nonatomic,strong)UIButton *chooseImageButton;
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *resultImageView;
@property(nonatomic,strong)NSMutableArray *valueArray;
@property(nonatomic,strong)NSMutableArray *newsViewArray;

@property(nonatomic,assign)NSInteger stepCount;
@property(nonatomic,strong)UILabel *stepLabel;

@property(nonatomic,strong) CADisplayLink *link;
@property(nonatomic,strong) CAShapeLayer *animationLayer;

@end

@implementation PuzzleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"拼图游戏";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    __weak typeof (self) weakSelf = self;
    
    self.chooseImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.chooseImageButton setTitle:@"选择图片" forState:UIControlStateNormal];
    [self.chooseImageButton setTitleColor:RGB_color(118) forState:UIControlStateNormal];
    self.chooseImageButton.layer.borderColor = RGB_color(118).CGColor;
    self.chooseImageButton.layer.borderWidth = 0.5f;
    self.chooseImageButton.layer.cornerRadius = 3;
    self.chooseImageButton.layer.masksToBounds = YES;
    [self.chooseImageButton addTarget:self action:@selector(chooseImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.chooseImageButton];
    [self.chooseImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    self.stepLabel = [UILabel new];
    self.stepLabel.font = [UIFont systemFontOfSize:15];
    self.stepLabel.text = @"0 步";
    self.stepLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:self.stepLabel];
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.chooseImageButton.mas_top);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    self.bgView = [UIView new];
    self.bgView.layer.borderColor = RGB_color(118).CGColor;
    self.bgView.layer.borderWidth = 0.5f;
    self.bgView.layer.cornerRadius = 3;
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.top.equalTo(weakSelf.chooseImageButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    
    self.resultImageView = [UIImageView new];
    self.resultImageView.layer.borderColor = RGB_color(118).CGColor;
    self.resultImageView.layer.borderWidth = 0.5f;
    self.resultImageView.layer.cornerRadius = 3;
    self.resultImageView.layer.masksToBounds = YES;
    [self.view addSubview:self.resultImageView];
    [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [self drawSepatorLine];
}


-(void)drawSepatorLine{
    
        self.animationLayer = [CAShapeLayer layer];
        self.animationLayer.bounds = self.bgView.bounds;
        self.animationLayer.fillColor = [UIColor blueColor].CGColor;
        self.animationLayer.lineWidth = 2;
        self.animationLayer.lineCap = kCALineCapRound;
        [self.bgView.layer addSublayer:self.animationLayer];
        

        UIBezierPath *path = [UIBezierPath bezierPath];

        [path moveToPoint:CGPointMake(0, 100)];
        [path addLineToPoint:CGPointMake(300, 100)];
        
        [path moveToPoint:CGPointMake(0, 200)];
        [path addLineToPoint:CGPointMake(300, 200)];
        
        [path moveToPoint:CGPointMake(100, 0)];
        [path addLineToPoint:CGPointMake(100, 300)];
        
        [path moveToPoint:CGPointMake(200, 0)];
        [path addLineToPoint:CGPointMake(200, 300)];

        CAShapeLayer *checkLayer = [CAShapeLayer layer];
        checkLayer.path = path.CGPath;
        checkLayer.fillColor = [UIColor blueColor].CGColor;
        checkLayer.strokeColor = [UIColor blueColor].CGColor;
        checkLayer.lineWidth = 2;
        checkLayer.lineCap = kCALineCapRound;
        checkLayer.lineJoin = kCALineJoinRound;
        [self.animationLayer addSublayer:checkLayer];
        
        CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        checkAnimation.duration = 2;
        checkAnimation.fromValue = @(0.0f);
        checkAnimation.toValue = @(1.0f);
        checkAnimation.delegate = self;
        [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
        [checkLayer addAnimation:checkAnimation forKey:nil];

}
- (void)viewWillLayoutSubviews
{
    [self _shouldRotateToOrientation:(UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation];
}

-(void)_shouldRotateToOrientation:(UIDeviceOrientation)orientation {
    if (orientation == UIDeviceOrientationPortrait ||orientation ==
        UIDeviceOrientationPortraitUpsideDown) { // 竖屏
        [self shuPing];
    } else { // 横屏
        [self hengPing];
    }
}

-(void)hengPing{
    [self.resultImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    [self.stepLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseImageButton.mas_bottom).offset(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view);
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    [self.chooseImageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}
-(void)shuPing{
    [self.resultImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [self.stepLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseImageButton.mas_top);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(40);
    }];
    
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.chooseImageButton.mas_bottom).offset(20);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
    
    [self.chooseImageButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
}

-(void)spliteImage:(UIImage *)image{
    NSArray *viewArray = [self.bgView subviews];
    for (UIView *v in viewArray) {
        [v removeFromSuperview];
    }
    NSMutableArray *spliteArray = [UIImage splitPictureWithRow:3 withColumn:3 withImage:image];
    self.valueArray = [NSMutableArray array];
    for (int i = 0; i < spliteArray.count; i++) {
        if (i == spliteArray.count -1) {
            [self.valueArray addObject:@"0"];
        }else{
            [self.valueArray addObject:@"1"];
        }
    }
    
    self.newsViewArray = [NSMutableArray array];
    CGFloat imageW = 100,imageH = 100;
    for (int i = 0 ; i < spliteArray.count; i++) {
        UIImageView *spliImageView = [UIImageView new];
        spliImageView.frame = CGRectMake(imageW*(i%3), imageH*(i/3), imageW, imageH);
        spliImageView.tag = 100+i;
        if (i < spliteArray.count -1) {
            spliImageView.image = spliteArray[i];
        }
        spliImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(spliImageClick:)];
        [spliImageView addGestureRecognizer:tap];
        [self.bgView addSubview:spliImageView];
        [self.newsViewArray addObject:spliImageView];
    }
    
    self.stepCount = 0;
    self.stepLabel.text = [NSString stringWithFormat:@"%ld 步",self.stepCount];
}

-(void)spliImageClick:(UIGestureRecognizer *)gesture{
    NSInteger tag = gesture.view.tag;
    NSLog(@"tag = %ld",tag);
    
    //获取当前点击的Image
    UIImageView *tapImage = (UIImageView *)gesture.view;
    //获取当前点击的Image的Index
    NSInteger tapIndex = tapImage.tag - 100;
    //获取附近空白的Image
    UIImageView *blankImage;
    //获取附近空白Image的index
    NSInteger blankIndex = 0;
    
    for (int i = 0; i < self.valueArray.count; i++) {
        if ([self.valueArray[i] isEqualToString:@"0"]) {
            blankImage = (UIImageView *)[self.bgView viewWithTag:100+i];
            blankIndex = i;
            break;
        }
    }
    //判断当前点击的是不是空白Image
    if (tapIndex == blankIndex) {
        NSLog(@"点击的空白");
        return;
    }
    
    //判断是不是可交换的
    if (![self canExchangeImagesWithTap:tapIndex blank:blankIndex]) {
        return;
    }

    self.stepCount ++;
    self.stepLabel.text = [NSString stringWithFormat:@"%ld 步",self.stepCount];
    AudioServicesPlaySystemSound(1519);
    
    for (int i = 0; i < self.valueArray.count; i++) {
        if ([self.valueArray[i] isEqualToString:@"0"]) {
            blankImage = (UIImageView *)[self.bgView viewWithTag:100+i];
            [self.valueArray exchangeObjectAtIndex:tapImage.tag-100 withObjectAtIndex:i];
            [self.newsViewArray exchangeObjectAtIndex:tapImage.tag-100 withObjectAtIndex:i];
            break;
        }
    }
    
    UIImage *tempImage;
    tempImage = tapImage.image;
    tapImage.image = blankImage.image;
    blankImage.image = tempImage;
}

-(BOOL)canExchangeImagesWithTap:(NSInteger)tapIndex blank:(NSInteger)blankIndex{
    BOOL canExchange = NO;
    if (tapIndex == 0) {
        if (blankIndex == 1 || blankIndex == 3) {
            canExchange =  YES;
        }
    }else if (tapIndex == 1) {
        if (blankIndex == 0 || blankIndex == 2 || blankIndex == 4) {
            canExchange =  YES;
        }
    }else if (tapIndex == 2) {
        if (blankIndex == 1 || blankIndex == 5) {
            canExchange =  YES;
        }
    }else if (tapIndex == 3) {
        if (blankIndex == 0 || blankIndex == 4 || blankIndex == 6) {
            canExchange =  YES;
        }
    }else if (tapIndex == 4) {
        if (blankIndex == 1 || blankIndex == 3 || blankIndex == 5 || blankIndex == 7) {
            canExchange =  YES;
        }
    }else if (tapIndex == 5) {
        if (blankIndex == 2 || blankIndex == 4 || blankIndex == 8) {
            canExchange =  YES;
        }
    }else if (tapIndex == 6) {
        if (blankIndex == 3 || blankIndex == 7) {
            canExchange =  YES;
        }
    }else if (tapIndex == 7) {
        if (blankIndex == 6 || blankIndex == 4 || blankIndex == 8) {
            canExchange =  YES;
        }
    }else if (tapIndex == 8) {
        if (blankIndex == 5 || blankIndex == 7) {
            canExchange =  YES;
        }
    }
    return canExchange;
}

-(void)chooseImageAction:(UIButton *)sender{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (TARGET_IPHONE_SIMULATOR) {
            [self.view makeToast:@"该设备不支持拍照"];
            return ;
        }
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
            BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@"提示" message:@"暂无相机权限,是否开启" clickedBlock:^(BlockAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }else if (authStatus == AVAuthorizationStatusAuthorized) {
            [self openCamera];
        }else if (authStatus == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    [self openCamera];
                }else{
                    NSLog(@"拒绝了");
                }
            }];

        }
    }];
    UIAlertAction *alburmAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusDenied) {
            BlockAlertView *alertView = [[BlockAlertView alloc] initWithTitle:@"提示" message:@"暂无相册权限,是否开启" clickedBlock:^(BlockAlertView *alertView, BOOL cancelled, NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
            return;
        }else if (status == PHAuthorizationStatusAuthorized) {
            [self openAlburm];
        }else if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusRestricted) {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                if (status == PHAuthorizationStatusAuthorized) {
                    NSLog(@"允许");
                    [self openAlburm];
                }else{
                    NSLog(@"不允许");
                }
            }];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cameraAction];
    [alert addAction:alburmAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openCamera{
    PureCamera *home = [[PureCamera alloc] init];
    __weak typeof (self) weakSelf = self;
    home.fininshcapture = ^(UIImage *image) {
        if (image) {
            weakSelf.resultImageView.image = image;
            [weakSelf spliteImage:image];
        }
    };
    [self presentViewController:home animated:YES completion:nil];
}

-(void)openAlburm{
    _photoVC =[[CCPhotLibraryViewController alloc]initWithNibName:@"CCPhotLibraryViewController" bundle:nil] ;
    _photoVC.delegate = self;
    [_photoVC setupImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
    _photoVC.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:_photoVC.imagePickerController animated:YES completion:^{
        
    }];
}

- (void)popController{
    [_photoVC.imagePickerController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle {

    self.resultImageView.image = image;
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
    [self spliteImage:image];
    
}

- (void)getImage:(UIImage *)img{
    NSLog(@"___%@",img);

    TOCropViewController *cropController = [[TOCropViewController alloc] initWithImage:img];
    cropController.delegate = self;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]<8.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            /**
             不跳转 原因是在presnet的时候viewDidLoad还没有执行完成，只有viewDidLoad执行完成之后，正常使用。
             在控制器加载的时候，不能使用这个去调用，这样就必须向办法延时才行。
             */
            [self presentViewController:cropController animated:YES completion:^{
                [cropController manageCurrentImage:TOCropViewControllerAspectRatioSquare];
            }];
        });
    }else{
        [self presentViewController:cropController animated:YES completion:^{
            [cropController manageCurrentImage:TOCropViewControllerAspectRatioSquare];
        }];
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
