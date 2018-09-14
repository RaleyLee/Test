//
//  LLDownLoadView.m
//  Kinds
//
//  Created by hibor on 2018/8/17.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "LLDownLoadView.h"

@interface LLDownLoadView()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;   //封面图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *downPross;
@property (weak, nonatomic) IBOutlet UILabel *proLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;


//AFNetWorking断点下载（支持离线）用到的属性
//文件的总长度
@property(nonatomic,assign) NSInteger fileLength;
//当前下载长度
@property(nonatomic,assign) NSInteger currentLength;
//文件句柄对象
@property(nonatomic,strong) NSFileHandle *fileHandle;

//下载任务
@property(nonatomic,strong) NSURLSessionDataTask *downLoadTask;
@property(nonatomic,strong) AFURLSessionManager *manager;

@end

@implementation LLDownLoadView

+(LLDownLoadView *)createDownLoadView{
    LLDownLoadView *downView = [[NSBundle mainBundle] loadNibNamed:@"LLDownLoadView" owner:nil options:nil].firstObject;
    return downView;
}


-(AFURLSessionManager *)manager{
    if (!_manager) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        //创建会话管理者
        _manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    }
    return _manager;
}

-(NSURLSessionDataTask *)downLoadTask{
    if (!_downLoadTask) {
        //创建下载URL
        NSURL *downURL = [NSURL URLWithString:_downModel.video];
        //创建request请求
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:downURL];
        //设置HTTP请求头中的Range
        NSString *range = [NSString stringWithFormat:@"bytes=%zd-",self.currentLength];
        [request setValue:range forHTTPHeaderField:@"Range"];
        
        __weak typeof (self) weakSelf = self;

        _downLoadTask = [self.manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {

        } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"loading");
        } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            NSLog(@"dataTaskWithRequest");
            //清空长度
            weakSelf.currentLength = 0;
            weakSelf.fileLength = 0;
            
            //关闭fileHandle
            [weakSelf.fileHandle closeFile];
            weakSelf.fileHandle = nil;
        }];
        
        [self.manager setDataTaskDidReceiveResponseBlock:^NSURLSessionResponseDisposition(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSURLResponse * _Nonnull response) {
            NSLog(@"NSURLSessionResponseDisposition %@",[weakSelf formatterWithByte:response.expectedContentLength]);
            //获得下载文件的总长度：请求下载的文件长度+当前已经下载的文件长度
            weakSelf.fileLength = response.expectedContentLength + self.currentLength;
            NSLog(@"%@",[weakSelf formatterWithByte:weakSelf.fileLength]);
            //沙盒文件路径
            NSArray *urlArray = [weakSelf.downModel.video componentsSeparatedByString:@"/"];
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[urlArray lastObject]];
            NSLog(@"File downLoaded to : %@",path); //下载路径
            
            //创建一个空的文件到沙盒中
            NSFileManager *manager = [NSFileManager defaultManager];
            if (![manager fileExistsAtPath:path]) {
                //如果没有下载文件的话，就创建一个文件
                //如果有下载文件的话，则不用重新创建（不然会覆盖掉之前的文件）
                [manager createFileAtPath:path contents:nil attributes:nil];
            }
            
            //创建文件句柄
            weakSelf.fileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
            
            //允许处理服务器的响应，才能继续接受服务器返回的数据
            return NSURLSessionResponseAllow;
            
        }];
        
        [self.manager setDataTaskDidReceiveDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDataTask * _Nonnull dataTask, NSData * _Nonnull data) {
            NSLog(@"setDataTaskDidReceiveDataBlcok %@",[weakSelf formatterWithByte:data.length]);
            
            //指定数据的写入位置 - 文件内容的最后面
            [weakSelf.fileHandle seekToEndOfFile];
            //向沙盒中写入数据
            [weakSelf.fileHandle writeData:data];
            //拼接文件总长度
            weakSelf.currentLength += data.length;
            
            //获取主线程，不然无法正确显示进度
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [mainQueue addOperationWithBlock:^{
                //下载进度
                if (weakSelf.fileLength == 0) {
                    weakSelf.downPross.progress = 0.0;
                    weakSelf.proLabel.text = [NSString stringWithFormat:@"0.00%%"];
                }else {
                    weakSelf.downPross.progress = 1.0 * weakSelf.currentLength / weakSelf.fileLength;
                    weakSelf.proLabel.text = [NSString stringWithFormat:@"%.2f%%",100.0 * weakSelf.currentLength / weakSelf.fileLength];
                }
                weakSelf.sizeLabel.text = [NSString stringWithFormat:@"%@/%@",[weakSelf formatterWithByte:weakSelf.currentLength],[weakSelf formatterWithByte:weakSelf.fileLength]];
            }];
        }];
    }
    return _downLoadTask;
}

-(NSString *)formatterWithByte:(float)byte{
    if(byte >= 1024*1024)//大于1M，则转化成M单位的字符串
    {
        return [NSString stringWithFormat:@"%1.2fM",byte/1024/1024];
    }
    else if(byte >= 1024 && byte < 1024*1024) //不到1M,但是超过了1KB，则转化成KB单位
    {
        return [NSString stringWithFormat:@"%1.2fK",byte/1024];
    }
    else//剩下的都是小于1K的，则转化成B单位
    {
        return [NSString stringWithFormat:@"%1.2fB",byte];
    }
    return @"";
}
-(void)offLineResumeDownLoadAction{
    // 沙盒文件路径
    NSArray *urlArray = [_downModel.video componentsSeparatedByString:@"/"];
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[urlArray lastObject]];
    
    NSInteger currentLength = [self fileLengthForPath:path];
    if (currentLength > 0) {  // [继续下载]
        self.currentLength = currentLength;
    }
    
    [self.downLoadTask resume];
    
//} else {
//    [self.downloadTask suspend];
//    self.downloadTask = nil;
//}

}

/**
 * 获取已下载的文件大小
 */
- (NSInteger)fileLengthForPath:(NSString *)path {
    NSInteger fileLength = 0;
    NSFileManager *fileManager = [[NSFileManager alloc] init]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileLength = [fileDict fileSize];
        }
    }
    return fileLength;
}

-(void)setDownModel:(LLDownLoadModel *)downModel{
    _downModel = downModel;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    __weak typeof (self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.coverImageView setImage:[UIImage thumbnailImageForVideo:[NSURL URLWithString:weakSelf.downModel.video] atTime:10]];
        weakSelf.titleLabel.text = weakSelf.downModel.title;
    });
    
}












@end
