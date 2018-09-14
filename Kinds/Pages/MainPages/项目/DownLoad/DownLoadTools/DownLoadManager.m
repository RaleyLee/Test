//
//  DownLoadManager.m
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "DownLoadManager.h"

static DownLoadManager *shareDownLoadManager = nil;

@interface DownLoadManager ()

//本地临时文件夹文件的个数
@property(nonatomic,assign) NSInteger count;
//已下载完成的文件列表（文件对象）
@property(strong) NSMutableArray *finishedList;
//正在下载的文件列表（ASIHttpRequest对象）
@property(strong) NSMutableArray *downLoadingList;
//未下载完成的临时文件数组（文件对象）
@property(strong)NSMutableArray *fileList;
//下载文件的模型
@property(nonatomic,strong) DownFileModel *fileInfo;

@end


@implementation DownLoadManager


+(DownLoadManager *)sharedDownLoadManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareDownLoadManager = [[self alloc] init];
    });
    return shareDownLoadManager;
}


-(instancetype)init{
    if (self = [super init]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *max = [userDefaults valueForKey:maxRequestCount];
        if (max == nil) {
            [userDefaults setObject:@"3" forKey:maxRequestCount];
            max = @"3";
        }
        [userDefaults synchronize];
        _maxCount = [max integerValue];
        _fileList = [[NSMutableArray alloc] init];
        _downLoadingList = [[NSMutableArray alloc] init];
        _finishedList = [[NSMutableArray alloc] init];
        _count = 0;
        [self loadFinishedfiles];
        [self loadTempfiles];
    }
    return self;
}

-(void)cleanLastInfo{
    for (DownHttpRequest *request in _downLoadingList) {
        if ([request isExecuting]) {
            [request cancel];
        }
    }
    [self saveFinishedFile];
    [_downLoadingList removeAllObjects];
    [_finishedList removeAllObjects];
    [_fileList removeAllObjects];
}

#pragma mark - 创建一个下载任务

-(void)downFileURL:(NSString *)url fileName:(NSString *)name fileImage:(UIImage *)image{
     // 因为是重新下载，则说明肯定该文件已经被下载完，或者有临时文件正在留着，所以检查一下这两个地方，存在则删除掉
    _fileInfo = [[DownFileModel alloc] init];
    NSString *saveName = [url lastPathComponent];
    _fileInfo.fileName = saveName;
    _fileInfo.fileURL = url;
    
    NSDate *date = [NSDate date];
    _fileInfo.time = [DownLoadHelper dateToString:date];
    _fileInfo.fileType = [saveName pathExtension];
    _fileInfo.disFileName = name;
    _fileInfo.fileimage = image;
    _fileInfo.downloadState = DownLoadStateLoading;
    _fileInfo.error = NO;
    _fileInfo.tempPath = TEMP_PATH(saveName);
    if ([DownLoadHelper isExistFile:FILE_PATH(saveName)]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已下载，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        return;
    }
    //存在于临时文件夹里
    NSString *tempFilePath = [TEMP_PATH(saveName) stringByAppendingString:@".plist"];
    if ([DownLoadHelper isExistFile:tempFilePath]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件已经在下载列表中了，是否重新下载？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        return;
    }
    //若不存在文件和临时文件，则是新的下载
    [self.fileList addObject:_fileInfo];
    //开始下载
    [self startDownLoadTask];
    if (self.vcDelegate && [self.vcDelegate respondsToSelector:@selector(allowNextRequest)]) {
        [self.vcDelegate allowNextRequest];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"该文件成功添加到下载队列" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alert show];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)( 0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alert dismissWithClickedButtonIndex:0 animated:YES];
        });
    }
    return;
}

#pragma mark - 开始下载

-(void)beginRequest:(DownFileModel *)fileInfo isBeginDown:(BOOL)isBeginDown{
    for (DownHttpRequest *tempRequest in self.downLoadingList) {
        /**
         * 注意这里判读是否是同一下载的方法，asihttprequest有三种url： url，originalurl，redirectURL
         * 经过实践，应该使用originalurl,就是最先获得到的原下载地址
         **/
        if ([[[tempRequest.url absoluteString] lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]]) {
            if ([tempRequest isExecuting] && isBeginDown) {
                return;
            }else if ([tempRequest isExecuting] && !isBeginDown){
                [tempRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];
                [tempRequest cancel];
                [self.downloadDelegate updateCellProgress:tempRequest];
                return;
            }
        }
    }
    
    [self saveDownloadFile:fileInfo];
    
    //按照获取到额文件名获取临时文件的大小  即已下载的大小
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSData *fileData = [fileManager contentsAtPath:fileInfo.tempPath];
    NSInteger receivedDataLength = [fileData length];
    fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%zd",receivedDataLength];
    
    // NSLog(@"start down:已经下载：%@",fileInfo.fileReceivedSize);
    DownHttpRequest *midRequest = [[DownHttpRequest alloc] initWithURL:[NSURL URLWithString:fileInfo.fileURL]];
    midRequest.downloadDestinationPath = FILE_PATH(fileInfo.fileName);
    midRequest.temporaryFileDownloadPath = fileInfo.tempPath;
    midRequest.delegate = self;
    [midRequest setUserInfo:[NSDictionary dictionaryWithObject:fileInfo forKey:@"File"]];//设置上下文的文件基本信息
    if (isBeginDown) {
        [midRequest startAsynchronous];
    }
    //如果文件重复下载或暂停 继续 则把队列中的请求删除重新添加
    BOOL exit = NO;
    for (DownHttpRequest *tempRequest  in self.downLoadingList) {
        if ([[[tempRequest.url absoluteString] lastPathComponent] isEqualToString:[fileInfo.fileURL lastPathComponent]]) {
            [self.downLoadingList replaceObjectAtIndex:[_downLoadingList indexOfObject:tempRequest] withObject:midRequest];
            exit = YES;
            break;
        }
    }
    if (!exit) {
        [self.downLoadingList addObject:midRequest];
    }
    
    [self.downloadDelegate updateCellProgress:midRequest];
    
}

#pragma mark - 存储下载信息到一个plist文件

- (void)saveDownloadFile:(DownFileModel *)fileinfo
{
    NSData *imagedata = UIImagePNGRepresentation(fileinfo.fileimage);

    NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys:fileinfo.fileName,@"filename",
                             fileinfo.disFileName,@"disFileName",
                             fileinfo.fileURL,@"fileurl",
                             fileinfo.time,@"time",
                             fileinfo.fileSize,@"filesize",
                             fileinfo.fileReceivedSize,@"filerecievesize",
                             imagedata,@"fileimage",nil];
    
    NSString *plistPath = [fileinfo.tempPath stringByAppendingPathExtension:@"plist"];
    if (![filedic writeToFile:plistPath atomically:YES]) {
        NSLog(@"write plist fail");
    }
}

#pragma mark - 自动处理下载状态的算法

/*下载状态的逻辑是这样的：三种状态，下载中，等待下载，停止下载
 
 当超过最大下载数时，继续添加的下载会进入等待状态，当同时下载数少于最大限制时会自动开始下载等待状态的任务。
 可以主动切换下载状态
 所有任务以添加时间排序。
 */
-(void)startDownLoadTask{
    NSInteger num = 0;
    NSInteger max = _maxCount;
    for (DownFileModel *file in _fileList) {
        if (!file.error) {
            if (file.downloadState == DownLoadStateLoading) {
                if (num >= max) {
                    file.downloadState = DownLoadStateWaiting;
                } else {
                    num++;
                }
            }
        }
    }
    if (num < max) {
        for (DownFileModel *file in _fileList) {
            if (!file.error) {
                if (file.downloadState == DownLoadStateWaiting) {
                    num++;
                    if (num>max) {
                        break;
                    }
                    file.downloadState = DownLoadStateLoading;
                }
            }
        }
        
    }
    for (DownFileModel *file in _fileList) {
        if (!file.error) {
            if (file.downloadState == DownLoadStateLoading) {
                [self beginRequest:file isBeginDown:YES];
                file.startTime = [NSDate date];
            } else {
                [self beginRequest:file isBeginDown:NO];
            }
        }
    }
    self.count = [_fileList count];
}

#pragma mark - 恢复下载

- (void)resumeRequest:(DownHttpRequest *)request
{
    NSInteger max = _maxCount;
    DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    NSInteger downingcount = 0;
    NSInteger indexmax = -1;
    for (DownFileModel *file in _fileList) {
        if (file.downloadState == DownLoadStateLoading) {
            downingcount++;
            if (downingcount==max) {
                indexmax = [_fileList indexOfObject:file];
            }
        }
    }
    // 此时下载中数目是否是最大，并获得最大时的位置Index
    if (downingcount == max) {
        DownFileModel *file  = [_fileList objectAtIndex:indexmax];
        if (file.downloadState == DownLoadStateLoading) {
            file.downloadState = DownLoadStateWaiting;
        }
    }
    // 中止一个进程使其进入等待
    for (DownFileModel *file in _fileList) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = DownLoadStateLoading;
            file.error = NO;
        }
    }
    // 重新开始此下载
    [self startDownLoadTask];
}

#pragma mark - 暂停下载

- (void)stopRequest:(DownHttpRequest *)request
{
    NSInteger max = self.maxCount;
    if([request isExecuting]) {
        [request cancel];
    }
    DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    for (DownFileModel *file in _fileList) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = DownLoadStateStop;
            break;
        }
    }
    NSInteger downingcount = 0;
    
    for (DownFileModel *file in _fileList) {
        if (file.downloadState == DownLoadStateLoading) {
            downingcount++;
        }
    }
    if (downingcount < max) {
        for (DownFileModel *file in _fileList) {
            if (file.downloadState == DownLoadStateWaiting){
                file.downloadState = DownLoadStateLoading;
                break;
            }
        }
    }
    
    [self startDownLoadTask];
}

#pragma mark - 删除下载

- (void)deleteRequest:(DownHttpRequest *)request
{
    BOOL isexecuting = NO;
    if([request isExecuting]) {
        [request cancel];
        isexecuting = YES;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    DownFileModel *fileInfo = (DownFileModel*)[request.userInfo objectForKey:@"File"];
    NSString *path = fileInfo.tempPath;
    
    NSString *configPath = [NSString stringWithFormat:@"%@.plist",path];
    [fileManager removeItemAtPath:path error:&error];
    [fileManager removeItemAtPath:configPath error:&error];
    
    if(!error){ NSLog(@"%@",[error description]);}
    
    NSInteger delindex = -1;
    for (DownFileModel *file in _fileList) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            delindex = [_fileList indexOfObject:file];
            break;
        }
    }
    if (delindex != NSNotFound)
        [_fileList removeObjectAtIndex:delindex];
    
    [_downLoadingList removeObject:request];
    
    if (isexecuting) {
        [self startDownLoadTask];
    }
    self.count = [_fileList count];
}

#pragma mark - 可能的UI操作接口

- (void)clearAllFinished
{
    [_finishedList removeAllObjects];
}

- (void)clearAllRequests
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    for (DownHttpRequest *request in _downLoadingList) {
        if([request isExecuting])
            [request cancel];
        DownFileModel *fileInfo = (DownFileModel*)[request.userInfo objectForKey:@"File"];
        NSString *path = fileInfo.tempPath;;
        NSString *configPath = [NSString stringWithFormat:@"%@.plist",path];
        [fileManager removeItemAtPath:path error:&error];
        [fileManager removeItemAtPath:configPath error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
        
    }
    [_downLoadingList removeAllObjects];
    [_fileList removeAllObjects];
}

- (void)startAllDownLoadTasks
{
    for (DownHttpRequest *request in _downLoadingList) {
        if([request isExecuting]) {
            [request cancel];
        }
        DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        fileInfo.downloadState = DownLoadStateLoading;
    }
    [self startDownLoadTask];
}

- (void)pauseAllDownLoadTasks
{
    for (DownHttpRequest *request in _downLoadingList) {
        if([request isExecuting]) {
            [request cancel];
        }
        DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
        fileInfo.downloadState = DownLoadStateStop;
    }
    [self startDownLoadTask];
}

#pragma mark - 从这里获取上次未完成下载的信息
/*
 将本地的未下载完成的临时文件加载到正在下载列表里,但是不接着开始下载
 
 */
- (void)loadTempfiles
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *filelist = [fileManager contentsOfDirectoryAtPath:TEMP_FOLDER error:&error];
    if(!error)
    {
        NSLog(@"%@",[error description]);
    }
    NSMutableArray *filearr = [[NSMutableArray alloc]init];
    for(NSString *file in filelist) {
        NSString *filetype = [file  pathExtension];
        if([filetype isEqualToString:@"plist"])
            [filearr addObject:[self getTempfile:TEMP_PATH(file)]];
    }
    
    NSArray* arr =  [self sortbyTime:(NSArray *)filearr];
    [_fileList addObjectsFromArray:arr];
    
    [self startDownLoadTask];
}

- (DownFileModel *)getTempfile:(NSString *)path
{
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:path];
    DownFileModel *file = [[DownFileModel alloc]init];
    file.disFileName = [dic objectForKey:@"disFileName"];
    file.fileName = [dic objectForKey:@"filename"];
    file.fileType = [file.fileName pathExtension ];
    file.fileURL = [dic objectForKey:@"fileurl"];
    file.fileSize = [dic objectForKey:@"filesize"];
    file.fileReceivedSize = [dic objectForKey:@"filerecievesize"];
    
    file.tempPath = TEMP_PATH(file.fileName);
    file.time = [dic objectForKey:@"time"];
    file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
    file.downloadState = DownLoadStateStop;
    file.error = NO;
    
    NSData *fileData = [[NSFileManager defaultManager ] contentsAtPath:file.tempPath];
    NSInteger receivedDataLength = [fileData length];
    file.fileReceivedSize = [NSString stringWithFormat:@"%zd",receivedDataLength];
    return file;
}

- (NSArray *)sortbyTime:(NSArray *)array
{
    NSArray *sorteArray1 = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        DownFileModel *file1 = (DownFileModel *)obj1;
        DownFileModel *file2 = (DownFileModel *)obj2;
        NSDate *date1 = [DownLoadHelper makeDate:file1.time];
        NSDate *date2 = [DownLoadHelper makeDate:file2.time];
        if ([[date1 earlierDate:date2]isEqualToDate:date2]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([[date1 earlierDate:date2]isEqualToDate:date1]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    return sorteArray1;
}

#pragma mark - 已完成的下载任务在这里处理
/*
 将本地已经下载完成的文件加载到已下载列表里
 */
- (void)loadFinishedfiles
{
    if ([[NSFileManager defaultManager] fileExistsAtPath:PLIST_PATH]) {
        NSMutableArray *finishArr = [[NSMutableArray alloc] initWithContentsOfFile:PLIST_PATH];
        for (NSDictionary *dic in finishArr) {
            DownFileModel *file = [[DownFileModel alloc]init];
            file.fileName = [dic objectForKey:@"filename"];
            file.fileType = [file.fileName pathExtension];
            file.disFileName = [dic objectForKey:@"disFileName"];
            file.fileURL = [dic objectForKey:@"fileurl"];
            file.fileSize = [dic objectForKey:@"filesize"];
            file.time = [dic objectForKey:@"time"];
            file.fileimage = [UIImage imageWithData:[dic objectForKey:@"fileimage"]];
            [_finishedList addObject:file];
        }
    }
    
}

- (void)saveFinishedFile
{
    if (_finishedList == nil) { return; }
    NSMutableArray *finishedinfo = [[NSMutableArray alloc] init];
    
    for (DownFileModel *fileinfo in _finishedList) {
        NSData *imagedata = UIImagePNGRepresentation(fileinfo.fileimage);
        NSDictionary *filedic = [NSDictionary dictionaryWithObjectsAndKeys: fileinfo.fileName,@"filename",
                                 fileinfo.time,@"time",
                                 fileinfo.fileSize,@"filesize",
                                 fileinfo.disFileName,@"disFileName",
                                 fileinfo.fileURL,@"fileurl",
                                 imagedata,@"fileimage",nil];
        [finishedinfo addObject:filedic];
    }
    
    if (![finishedinfo writeToFile:PLIST_PATH atomically:YES]) {
        NSLog(@"write plist fail");
    }
}

- (void)deleteFinishFile:(DownFileModel *)selectFile
{
    [_finishedList removeObject:selectFile];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = FILE_PATH(selectFile.fileName);
    if ([fm fileExistsAtPath:path]) {
        [fm removeItemAtPath:path error:nil];
    }
    [self saveFinishedFile];
}

#pragma mark -- ASIHttpRequest回调委托 --

// 出错了，如果是等待超时，则继续下载
- (void)requestFailed:(DownHttpRequest *)request
{
    NSError *error=[request error];
    NSLog(@"ASIHttpRequest出错了!%@",error);
    if (error.code==4) { return; }
    if ([request isExecuting]) { [request cancel]; }
    DownFileModel *fileInfo =  [request.userInfo objectForKey:@"File"];
    fileInfo.downloadState = DownLoadStateStop;
    fileInfo.error = YES;
    for (DownFileModel *file in _fileList) {
        if ([file.fileName isEqualToString:fileInfo.fileName]) {
            file.downloadState = DownLoadStateStop;
            file.error = YES;
        }
    }
    [self.downloadDelegate updateCellProgress:request];
}

- (void)requestStarted:(DownHttpRequest *)request
{
    NSLog(@"开始了!");
}

- (void)request:(DownHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    NSLog(@"收到回复了！");
    
    DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    fileInfo.isFirstReceived = YES;
    
    NSString *len = [responseHeaders objectForKey:@"Content-Length"];
    // 这个信息头，首次收到的为总大小，那么后来续传时收到的大小为肯定小于或等于首次的值，则忽略
    if ([fileInfo.fileSize longLongValue] > [len longLongValue]){ return; }
    
    fileInfo.fileSize = [NSString stringWithFormat:@"%lld", [len longLongValue]];
    [self saveDownloadFile:fileInfo];
}

- (void)request:(DownHttpRequest *)request didReceiveBytes:(long long)bytes
{
    DownFileModel *fileInfo = [request.userInfo objectForKey:@"File"];
    // NSLog(@"%@,%lld",fileInfo.fileReceivedSize,bytes);
    if (fileInfo.isFirstReceived) {
        fileInfo.isFirstReceived = NO;
        fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%lld",bytes];
    } else if(!fileInfo.isFirstReceived) {
        fileInfo.fileReceivedSize = [NSString stringWithFormat:@"%lld",[fileInfo.fileReceivedSize longLongValue]+bytes];
    }
    NSUInteger receivedSize = [fileInfo.fileReceivedSize longLongValue];
    NSUInteger expectedSize = [fileInfo.fileSize longLongValue];
    
    // 每秒下载速度
    NSTimeInterval downloadTime = -1 * [fileInfo.startTime timeIntervalSinceNow];
    CGFloat speed = (CGFloat)receivedSize / (CGFloat)downloadTime;
    if (speed == 0) { return; }
    
    CGFloat speedSec = [DownLoadHelper calculateFileSizeInUnit:(unsigned long long)speed];
    NSString *unit = [DownLoadHelper calculateUnit:(unsigned long long)speed];
    NSString *speedStr = [NSString stringWithFormat:@"%.2f%@/s",speedSec,unit];
    fileInfo.speed = speedStr;
    
    // 剩余下载时间
    NSMutableString *remainingTimeStr = [[NSMutableString alloc] init];
    NSUInteger remainingContentLength = expectedSize - receivedSize;
    CGFloat remainingTime = (CGFloat)(remainingContentLength / speed);
    NSInteger hours = remainingTime / 3600;
    NSInteger minutes = (remainingTime - hours * 3600) / 60;
    CGFloat seconds = remainingTime - hours * 3600 - minutes * 60;
    
    if (hours > 0)   {[remainingTimeStr appendFormat:@"%zd小时 ",hours];}
    if (minutes > 0) {[remainingTimeStr appendFormat:@"%zd分 ",minutes];}
    if (seconds > 0) {[remainingTimeStr appendFormat:@"%.1f秒",seconds];}
    fileInfo.remainingTime = remainingTimeStr;
    
    if([self.downloadDelegate respondsToSelector:@selector(updateCellProgress:)]) {
        [self.downloadDelegate updateCellProgress:request];
    }
}

// 将正在下载的文件请求ASIHttpRequest从队列里移除，并将其配置文件删除掉,然后向已下载列表里添加该文件对象
- (void)requestFinished:(DownHttpRequest *)request
{
    DownFileModel *fileInfo = (DownFileModel *)[request.userInfo objectForKey:@"File"];
    [_finishedList addObject:fileInfo];
    NSString *configPath = [fileInfo.tempPath stringByAppendingString:@".plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if([fileManager fileExistsAtPath:configPath]) //如果存在临时文件的配置文件
    {
        [fileManager removeItemAtPath:configPath error:&error];
        if(!error) { NSLog(@"%@",[error description]); }
    }
    
    [_fileList removeObject:fileInfo];
    [_downLoadingList removeObject:request];
    [self saveFinishedFile];
    [self startDownLoadTask];
    
    if([self.downloadDelegate respondsToSelector:@selector(finishedDownLoad:)]) {
        [self.downloadDelegate finishedDownLoad:request];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 确定按钮
    if( buttonIndex == 1 ) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSInteger delindex = -1;
        NSString *path = FILE_PATH(_fileInfo.fileName);
        if([DownLoadHelper isExistFile:path]) { //已经下载过一次该文件
            for (DownFileModel *info in [self.finishedList mutableCopy]) {
                if ([info.fileName isEqualToString:_fileInfo.fileName]) {
                    // 删除文件
                    [self deleteFinishFile:info];
                }
            }
        } else { // 如果正在下载中，择重新下载
            for(DownHttpRequest *request in [self.downLoadingList mutableCopy]) {
                DownFileModel *fileModel = [request.userInfo objectForKey:@"File"];
                if([fileModel.fileName isEqualToString:_fileInfo.fileName])
                {
                    if ([request isExecuting]) {
                        [request cancel];
                    }
                    delindex = [_downLoadingList indexOfObject:request];
                    break;
                }
            }
            [_downLoadingList removeObjectAtIndex:delindex];
            
            for (DownFileModel *file in [self.fileList mutableCopy]) {
                if ([file.fileName isEqualToString:_fileInfo.fileName]) {
                    delindex = [_fileList indexOfObject:file];
                    break;
                }
            }
            [_fileList removeObjectAtIndex:delindex];
            // 存在于临时文件夹里
            NSString * tempfilePath = [_fileInfo.tempPath stringByAppendingString:@".plist"];
            if([DownLoadHelper isExistFile:tempfilePath])
            {
                if (![fileManager removeItemAtPath:tempfilePath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
                
            }
            if([DownLoadHelper isExistFile:_fileInfo.tempPath])
            {
                if (![fileManager removeItemAtPath:_fileInfo.tempPath error:&error]) {
                    NSLog(@"删除临时文件出错:%@",[error localizedDescription]);
                }
            }
            
        }
        
        self.fileInfo.fileReceivedSize = [DownLoadHelper getFileSizeString:@"0"];
        [_fileList addObject:_fileInfo];
        [self startDownLoadTask];
    }
    if (self.vcDelegate!=nil && [self.vcDelegate respondsToSelector:@selector(allowNextRequest)]) {
        [self.vcDelegate allowNextRequest];
    }
}

#pragma mark - setter

- (void)setMaxCount:(NSInteger)maxCount
{
    _maxCount = maxCount;
    [[NSUserDefaults standardUserDefaults] setValue:@(maxCount) forKey:maxRequestCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[DownLoadManager sharedDownLoadManager] startDownLoadTask];
}


@end
