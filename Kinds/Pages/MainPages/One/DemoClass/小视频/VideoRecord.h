//
//  VideoRecord.h
//  Kinds
//
//  Created by hibor on 2018/8/29.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef void (^IDBLOCK) (id obj);
typedef void (^BOOLBLOCK)(BOOL boolValue);
typedef void (^VOIDBLOCK)();

typedef NS_ENUM(NSInteger,RecordResult){
    RecordResultSuccess,
    RecordResultLessThanMinTime,
    RecordResultFailure
};

typedef NS_ENUM(NSUInteger,AVCaptureOutputType){
    AVCaptureOutputTypeMovieFile,    //文件输出
    AVCaptureOutputTypeVideoData,    //data输出
    AVCaptureOutputTypeMetaData      //元数据输出
};

@protocol RecordPlayProtocol <NSObject>

@optional
-(void)joyRecordTImeCurrentTime:(CGFloat)currentTime totalTime:(CGFloat)totalTime;
-(void)joyCaptureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connectons;
-(void)joyCaptureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error recordResult:(RecordResult)recordResult;
-(void)joyCaptureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataobjects fromConnection:(AVCaptureConnection *)connection;
@end

@interface VideoRecord : NSObject

@property(nonatomic,strong)AVCaptureSession *captureSession;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *preViewLayer;

@property(nonatomic,weak)id <RecordPlayProtocol> delegate;
@property(nonatomic,assign)AVCaptureOutputType captureOutputType;


//初始化类型，默认录制文件
-(instancetype)initWithCaptureType:(AVCaptureOutputType)captureType;

//准备录制
-(void)preareRecord;

//设置焦距
-(void)updateVideoScaleAndCropFactor:(CGFloat)scale;

//防抖功能
-(void)openStabilization;

//开始录制
-(void)startRecordToFile:(NSURL *)outPutFile;

//停止录制
-(void)stopCurrentVideoRecording;

//移除输入
-(void)removeAVCaptureAudioDeviceInput;

//手电筒
-(void)switchTorch;

//切换摄像头
-(void)switchCamera;

//设置聚焦点
-(void)setFoucusWithPoint:(CGPoint)point;


@end


@interface VideoRecord (JoyRecorderPrivary)

-(BOOL)isAvailableWithCamera;

-(BOOL)isAvailableWithMic;

-(void)getVideoAuth:(BOOLBLOCK)videoAuth;

-(void)showAlert;

//视频裁剪压缩
+(void)mergeAndExportVideosAtFileURLs:(NSURL *)fileURL newURL:(NSString *)mergeFilePath widthHeightScale:(CGFloat)whScale presetName:(NSString *)presetName mergeSuccess:(void)mergeSuccess;

//视频保存相册
+(void)saveToPhotoWithURL:(NSURL *)url;

//视频地址
+(NSString *)generateFilePathWithType:(NSString *)fileType;

//获取文件大小
+(CGFloat)getFileSize:(NSString *)filePath;

@end
