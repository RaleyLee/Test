//
//  ScreenRecordViewController.m
//  Kinds
//
//  Created by hibor on 2018/8/24.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "ScreenRecordViewController.h"
#import <ReplayKit/ReplayKit.h>

@implementation SModel

@synthesize string;

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:string forKey:@"string"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.string = [aDecoder decodeObjectForKey:@"string"];
    }
    return self;
}

#pragma mark NSCoping
- (id)copyWithZone:(NSZone *)zone {
    SModel *copy = [[[self class] allocWithZone:zone] init];
    copy.string = self.string;
    return copy;
}

@end

@interface ScreenRecordViewController ()<RPPreviewViewControllerDelegate>

@property(nonatomic,strong)UIButton *startButton;
@property(nonatomic,strong)UIButton *stopButton;

@property(nonatomic,strong)NSMutableArray *viewArray;

@end

@implementation ScreenRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0 ; i < 10; i++) {
        SModel *model = [[SModel alloc] init];
        model.string = [NSString stringWithFormat:@"%d",i];
        [tempArray addObject:model];
    }
    //存储
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tempArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"temp"];
    
    //取值
    NSData *getData = [[NSUserDefaults standardUserDefaults] objectForKey:@"temp"];
    NSMutableArray *getArray = [NSKeyedUnarchiver unarchiveObjectWithData:getData];
    NSLog(@"getArray = %@",getArray);
    
    self.viewArray = [NSMutableArray array];
    [self.view addSubview:self.startButton];
    [self.viewArray addObject:self.startButton];
    
    [self.view addSubview:self.stopButton];
    [self.viewArray addObject:self.stopButton];

    
    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(44);
        make.right.equalTo(self.stopButton.mas_left).offset(-10);
    }];
    
    [self.stopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.equalTo(self.startButton.mas_right).offset(10);
        make.height.mas_equalTo(44);
        make.width.equalTo(self.startButton.mas_width);
        make.right.mas_equalTo(-10);
    }];
}

-(UIButton *)startButton{
    if (!_startButton) {
        _startButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setTitle:@"开始录制" forState:UIControlStateNormal];
        _startButton.backgroundColor = [UIColor greenColor];
        _startButton.layer.borderColor = RGB_color(200).CGColor;
        _startButton.layer.borderWidth = 0.5f;
        [_startButton addTarget:self action:@selector(startRecordingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

-(UIButton *)stopButton{
    if (!_stopButton) {
        _stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_stopButton setTitle:@"停止录制" forState:UIControlStateNormal];
        _stopButton.backgroundColor = [UIColor redColor];
        _stopButton.layer.borderColor = RGB_color(200).CGColor;
        _stopButton.layer.borderWidth = 0.5f;
        [_stopButton addTarget:self action:@selector(stopRecordingAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopButton;
}


-(void)startRecordingAction:(UIButton *)sender{
    //因为屏幕录制需要系统版本限制
    if ([RPScreenRecorder sharedRecorder].available) {
        NSLog(@"可以开始进行屏幕录制");
        if (@available(iOS 10.0, *)) {
            [[RPScreenRecorder sharedRecorder] startRecordingWithHandler:^(NSError * _Nullable error) {
                
            }];
        } else {
            // Fallback on earlier versions
            NSLog(@"不支持的屏幕录制功能");
        }
    }else{
        NSLog(@"屏幕录制功能不可用");
    }
}

-(void)stopRecordingAction:(UIButton *)sender{
    [[RPScreenRecorder sharedRecorder] stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        if (error) {
            NSLog(@"%@",error);
        }
        if (previewViewController) {
            previewViewController.previewControllerDelegate = self;
            [self presentViewController:previewViewController animated:YES completion:nil];
        }
    }];
}

-(void)previewControllerDidFinish:(RPPreviewViewController *)previewController{
    [previewController dismissViewControllerAnimated:YES completion:nil];
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
