//
//  DownLoadManager.h
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DownLoadHelper.h"
#import "DownLoadDelegate.h"
#import "DownFileModel.h"
#import "DownHttpRequest.h"

#define maxRequestCount @"maxRequestCount"

@interface DownLoadManager : NSObject<DownHttpRequestDelegate>

//获得下载时间的VC 用在比如多选图片后批量下载的情况 这时需要配合allowNextRequest协议方法使用
@property(nonatomic,weak) id <DownLoadDelegate> vcDelegate;
//下载列表delegate
@property(nonatomic,weak) id <DownLoadDelegate> downloadDelegate;
//设置最大的并发下载个数
@property(nonatomic,assign) NSInteger maxCount;
//已下载完成的文件列表（文件对象）
@property(atomic,strong,readonly) NSMutableArray *finishedList;
//正在下载的文件列表（ASIHttpRequest对象）
@property(atomic,strong,readonly) NSMutableArray *downLoadingList;
//未下载完成的临时文件数组（文件对象）
@property(atomic,strong,readonly) NSMutableArray *fileList;
//下载文件的模型
@property(nonatomic,strong,readonly) DownFileModel *fileInfo;


//单例
+(DownLoadManager *)sharedDownLoadManager;

//清除所有正在下载的请求
-(void)clearAllRequests;

//清除所有下载完的文件
-(void)clearAllFinished;

//恢复下载
-(void)resumeRequest:(DownHttpRequest *)request;

//删除这个下载请求
-(void)deleteRequest:(DownHttpRequest *)request;

//停止这个下载请求
-(void)stopRequest:(DownHttpRequest *)request;

//保存下载完成的文件信息到plist
-(void)saveFinishedFile;

//删除某一个下载完成的文件
-(void)deleteFinishFile:(DownFileModel *)selectFile;

//下载视频时候调用
-(void)downFileURL:(NSString *)url fileName:(NSString *)name fileImage:(UIImage *)image;

//开始任务
-(void)startDownLoadTask;

//全部开始 （等于最大下载个数，超过的还是等待下载状态）
-(void)startAllDownLoadTasks;

//全部暂停
-(void)pauseAllDownLoadTasks;



@end
