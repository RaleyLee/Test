//
//  VideoRecord.m
//  Kinds
//
//  Created by hibor on 2018/8/29.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "VideoRecord.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import <JoyAlert.h>

@interface VideoRecord () <AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic,strong)NSTimer *timer; //定时器，用于计时和时间进度条管理
@property(nonatomic,assign)CGFloat recordTime;  //当前录制时间
@property(nonatomic,assign)CGFloat totalTime;   //总录制时间
@property(nonatomic,strong)AVCaptureDeviceInput *mediaDeviceInput;  //视频输入
@property(nonatomic,strong)AVCaptureDeviceInput *audioDeviceInput;  //音频输入
@property(nonatomic,strong)AVCaptureMovieFileOutput *movieFileOutput;  //视频文件输出
@property(nonatomic,strong)AVCaptureStillImageOutput *stillImageOutput;  //图像输出
@property (strong, nonatomic)AVCaptureVideoDataOutput  *videoDataOutput;           //视频data输出
@property (strong, nonatomic)AVCaptureAudioDataOutput  *audioDataOutput;           //视频data输出
@property (strong, nonatomic)AVCaptureMetadataOutput   *metadataOutput;            //元数据输出
@property (strong, nonatomic)AVCaptureConnection       *captureConnection;
@property (assign,nonatomic)UIBackgroundTaskIdentifier backgroundTaskIdentifier;   //后台任务标识

@end

static const CGFloat KTimerInterval = 0.05;
static const CGFloat KMaxRecordTime = 20;
static const CGFloat KMinRecordTime = 3;

@implementation VideoRecord

-(instancetype)initWithCaptureType:(AVCaptureOutputType)captureType{
    if (self = [super init]) {
        self.captureOutputType = captureType;
        
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

-(CGFloat)totalTime{
    return _totalTime = _totalTime ? : 15;
}

-(AVCaptureSession *)captureSession{
    return _captureSession = _captureSession ? : [[AVCaptureSession alloc] init];
}

#pragma mark - 视频输入
-(AVCaptureDeviceInput *)mediaDeviceInput{
    if (!_mediaDeviceInput) {
        __block AVCaptureDevice *frontCamera = nil;
        __block AVCaptureDevice *backCamera = nil;
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        [cameras enumerateObjectsUsingBlock:^(AVCaptureDevice *camera, NSUInteger idx, BOOL * _Nonnull stop) {
            if (camera.position == AVCaptureDevicePositionFront) {
                frontCamera = camera;
            }else if (camera.position == AVCaptureDevicePositionBack) {
                backCamera = camera;
            }
        }];
        [self setExposureModeWithDevice:backCamera];
        _mediaDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:backCamera error:nil];
    }
    return _mediaDeviceInput;
}

#pragma mark - 音频输入
-(AVCaptureDeviceInput *)audioDeviceInput{
    if (!_audioDeviceInput) {
        NSError *error;
        _audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    }
    return _audioDeviceInput;
}

#pragma mark - 图片输出
-(AVCaptureStillImageOutput *)stillImageOutput{
    if (!_stillImageOutput) {
        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [_stillImageOutput setOutputSettings:[[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG ,AVVideoCodecKey, nil]];
    }
    return _stillImageOutput;
}

#pragma mark - 文件输出
-(AVCaptureMovieFileOutput *)movieFileOutput{
    return _movieFileOutput = _movieFileOutput ? : [[AVCaptureMovieFileOutput alloc] init];
}

#pragma mark - data输出
-(AVCaptureVideoDataOutput *)videoDataOutput{
    if (!_videoDataOutput) {
        _videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
        _videoDataOutput.videoSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCVPixelFormatType_420YpCbCr8BiPlanarFullRange] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
        [_videoDataOutput setSampleBufferDelegate:self queue:videoQueue];
    }
    return _videoDataOutput;
}

#pragma mark - 元数据输出
-(AVCaptureMetadataOutput *)metadataOutput{
    if (!_metadataOutput) {
        _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    }
    return _metadataOutput;
}

#pragma mark - 输入输出对象连接
-(AVCaptureConnection *)captureConnection{
    return _captureConnection = _captureConnection ? : [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
}

#pragma mark - layer层
-(AVCaptureVideoPreviewLayer *)preViewLayer{
    if (!_preViewLayer) {
        _preViewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
        _preViewLayer.masksToBounds = YES;
        _preViewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _preViewLayer;
}

#pragma mark - 设置曝光模式
-(void)setExposureModeWithDevice:(AVCaptureDevice *)device{
    NSError *error = nil;
    [device lockForConfiguration:&error];
    //设置持续曝光模式
    if ([device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure])
        [device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
    [device unlockForConfiguration];
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:KTimerInterval target:self selector:@selector(startTime:) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(void)startTime:(NSTimer *)timer{
    if ([self.delegate respondsToSelector:@selector(joyRecordTImeCurrentTime:totalTime:)]) {
        [self.delegate joyRecordTImeCurrentTime:self.recordTime totalTime:self.totalTime];
    }
    self.recordTime += KTimerInterval;
    if (_recordTime >= KMaxRecordTime) {
        [self stopCurrentVideoRecording];
    }
}

//定时器开启
-(void)startTimer{
    [self.timer invalidate];
    self.timer = nil;
    self.recordTime = 0;
    [self.timer fire];
}

//停止计时
-(void)stopTimer{
    [self.timer invalidate];
    self.timer = nil;
}

//文件视频开始录制代理，也就是小视频的开始录制
#pragma mark - AVCaptureFileOutputRecordingDelegate
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(nonnull NSURL *)fileURL fromConnections:(nonnull NSArray<AVCaptureConnection *> *)connections{
    [self startTimer];
    if ([self.delegate respondsToSelector:@selector(joyCaptureOutput:didStartRecordingToOutputFileAtURL:fromConnections:)]) {
        [self.delegate joyCaptureOutput:captureOutput didStartRecordingToOutputFileAtURL:fileURL fromConnections:connections];
    }
}

#pragma mark - 文件录制结束代理 小视频录制结束
-(void)captureOutput:(AVCaptureFileOutput *)output didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray<AVCaptureConnection *> *)connections error:(NSError *)error{
    [self endBackgroundTask];
    if ([self.delegate respondsToSelector:@selector(captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:)]) {
        RecordResult result = error ? RecordResultFailure : (self.recordTime > KMinRecordTime ? RecordResultSuccess : RecordResultLessThanMinTime);
        [self.delegate joyCaptureOutput:output didFinishRecordingToOutputFileAtURL:outputFileURL fromConnections:connections error:error recordResult:result];
    }
}

#pragma mark - 流数据丢包 流媒体
-(void)captureOutput:(AVCaptureOutput *)output didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
}

#pragma mark - 流数据输出 流媒体
-(void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
}

#pragma mark - 扫描到数据 二维码扫描成功
-(void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if ([self.delegate respondsToSelector:@selector(joyCaptureOutput:didOutputMetadataObjects:fromConnection:)]) {
        [self.delegate joyCaptureOutput:output didOutputMetadataObjects:metadataObjects fromConnection:connection];
    }
}

-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    self.recordTime = 0;
    [self stopCurrentVideoRecording];
    [self.captureSession stopRunning];
    [self.preViewLayer removeFromSuperlayer];
}

-(void)preareRecord{
    [self.captureSession beginConfiguration];
    [self.captureSession canSetSessionPreset:AVCaptureSessionPresetMedium]?[self.captureSession setSessionPreset:AVCaptureSessionPresetHigh]:nil;
    [self.captureSession canAddInput:self.mediaDeviceInput]?[self.captureSession addInput:self.mediaDeviceInput]:nil;
    [self.captureSession canAddInput:self.audioDeviceInput]?[self.captureSession addInput:self.audioDeviceInput]:nil;
    [self.captureSession canAddOutput:self.stillImageOutput]?[self.captureSession addOutput:self.stillImageOutput]:nil;
    switch (self.captureOutputType)
    {
        case AVCaptureOutputTypeVideoData:
            [self.captureSession canAddOutput:self.videoDataOutput]?[self.captureSession addOutput:self.videoDataOutput]:nil;
            break;
        case AVCaptureOutputTypeMetaData:
            [self.captureSession canAddOutput:self.metadataOutput]?[self.captureSession addOutput:self.metadataOutput]:nil;
            if ([_metadataOutput.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode])
            {_metadataOutput.metadataObjectTypes = [NSArray arrayWithObjects:AVMetadataObjectTypeQRCode,AVMetadataObjectTypeUPCECode,
                                                    AVMetadataObjectTypeCode39Code,
                                                    AVMetadataObjectTypeCode39Mod43Code,
                                                    AVMetadataObjectTypeEAN13Code,
                                                    AVMetadataObjectTypeEAN8Code,
                                                    AVMetadataObjectTypeCode93Code,
                                                    AVMetadataObjectTypeCode128Code,
                                                    AVMetadataObjectTypePDF417Code,
                                                    AVMetadataObjectTypeQRCode,
                                                    AVMetadataObjectTypeAztecCode, nil];}
            
            break;
        default:
            [self.captureSession canAddOutput:self.movieFileOutput]?[self.captureSession addOutput:self.movieFileOutput]:nil;
            break;
    }
    //设置输出数据代理
    [self.captureSession commitConfiguration];
    [self openStabilization];
    [self.captureSession startRunning];

}

#pragma mark 移除输入
-(void)removeAVCaptureAudioDeviceInput
{
    self.mediaDeviceInput?[self.captureSession removeInput:self.mediaDeviceInput]:nil;
    self.audioDeviceInput?[self.captureSession removeInput:self.audioDeviceInput]:nil;
    self.stillImageOutput?[self.captureSession removeOutput:self.stillImageOutput]:nil;
    switch (self.captureOutputType)
    {
        case AVCaptureOutputTypeVideoData:
            self.videoDataOutput? [self.captureSession removeOutput:self.videoDataOutput]:nil;
            break;
        case AVCaptureOutputTypeMetaData:
            self.metadataOutput? [self.captureSession removeOutput:self.metadataOutput]:nil;
            break;
        default:
            self.movieFileOutput? [self.captureSession removeOutput:self.movieFileOutput]:nil;
            break;
    }
}

#pragma mark 设置焦距
- (void)updateVideoScaleAndCropFactor:(CGFloat)scale{
    if (scale < self.mediaDeviceInput.device.activeFormat.videoMaxZoomFactor && scale>1)
        [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
            [captureDevice rampToVideoZoomFactor:scale withRate:10];
        }];
}

#pragma mark 防抖功能 并设置缩放比例最大以提高视频质量
- (void)openStabilization{
    if ([self.captureConnection isVideoStabilizationSupported ] &&self.captureConnection.activeVideoStabilizationMode == AVCaptureVideoStabilizationModeOff)
    {
        self.captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;//视频防抖
    }
    self.captureConnection.videoScaleAndCropFactor = _captureConnection.videoMaxScaleAndCropFactor;//镜头缩放最大
}

#pragma mark 开始录制
- (void)startRecordToFile:(NSURL *)outPutFile{
    if (![self.movieFileOutput isRecording]) {  // 如果此时没有在录屏
        if ([[UIDevice currentDevice] isMultitaskingSupported])//如果支持多任务则则开始多任务
        {
            __weak __typeof(&*self)weakSelf = self;
            self.backgroundTaskIdentifier=[[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{[weakSelf endBackgroundTask];}];
        }
        
        if ([self.captureConnection isVideoOrientationSupported])
            self.captureConnection.videoOrientation =[self.preViewLayer connection].videoOrientation;
        self.recordTime = 0.0f;
        [_movieFileOutput startRecordingToOutputFileURL:outPutFile recordingDelegate:self];
    }
    else{[self.movieFileOutput stopRecording];//停止录制
    }
}

#pragma mark - 视频录制
-(void)endBackgroundTask
{
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
    }
    self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
}

#pragma mark 暂停
- (void)stopCurrentVideoRecording
{
    if (self.movieFileOutput.isRecording) {
        [self stopTimer];
        [_movieFileOutput stopRecording];
    }
}
#pragma mark 手电筒
- (void)switchTorch{
    __weak __typeof (&*self)weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        //设备参数修改时要锁定配置，修改后unlock，摄像头也一样
        [device lockForConfiguration:&error];
        if (error) {NSLog(@"error:%@",error.description);}
        //        AVCaptureTorchMode torchMode = device.torchMode == AVCaptureTorchModeOff?AVCaptureTorchModeOn:AVCaptureTorchModeOff;
        
        AVCaptureTorchMode torchMode = AVCaptureTorchModeAuto;
        AVCaptureDevice *currentDevice = [weakSelf.mediaDeviceInput device];
        if(currentDevice.position == AVCaptureDevicePositionFront) torchMode = AVCaptureTorchModeOff;
        [device setTorchMode:torchMode];
        [device unlockForConfiguration];
    });
}
#pragma mark 切换摄像头
- (void)switchCamera{
    [_captureSession beginConfiguration];
    //移除旧的输入设备
    [_captureSession removeInput:_mediaDeviceInput];
    AVCaptureDevice *swithToDevice = [self getSwitchCameraDevice];
    [swithToDevice lockForConfiguration:nil];
    [self setExposureModeWithDevice:swithToDevice];
    self.mediaDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:swithToDevice error:nil];
    //替换更换摄像头后的输入对象
    [_captureSession addInput:_mediaDeviceInput];
    [_captureSession commitConfiguration];
}

- (void)cancleRecord{
    
}

#pragma mark 设置对焦
- (void)setFoucusWithPoint:(CGPoint)point{
    CGPoint cameraPoint= [self.preViewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        //聚焦
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
        //聚焦位置
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        //曝光模式
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
        //曝光点位置
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 * 改变设备属性的统一操作方法
 * @param propertyChange 属性改变操作
 */
- (void)changeDeviceProperty:(IDBLOCK)propertyChange
{
    AVCaptureDevice *captureDevice = [self.mediaDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (AVCaptureDevice *)getSwitchCameraDevice{
    AVCaptureDevice *currentDevice = [self.mediaDeviceInput device];
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    BOOL isUnspecifiedOrFront = (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront);
    AVCaptureDevicePosition  swithToPosition = isUnspecifiedOrFront?AVCaptureDevicePositionBack:AVCaptureDevicePositionFront;
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    __block AVCaptureDevice *swithCameraDevice = nil;
    [cameras enumerateObjectsUsingBlock:^(AVCaptureDevice *camera, NSUInteger idx, BOOL * _Nonnull stop) {
        if(camera.position == swithToPosition){swithCameraDevice = camera;*stop = YES;};
    }];
    return swithCameraDevice;
}

@end

//类别，权限处理、视频裁剪压缩、视频存储
#pragma mark  权限认证、缓存处理 类别🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️🤖️开始
@implementation VideoRecord (JoyRecorderPrivary)
- (BOOL)isAvailableWithCamera
{
    return [self isAvailableWithDeviveMediaType:AVMediaTypeVideo];
}

- (BOOL)isAvailableWithMic
{
    return [self isAvailableWithDeviveMediaType:AVMediaTypeAudio];
}

- (BOOL)isAvailableWithDeviveMediaType:(NSString *)mediaType
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    return !(status == ALAuthorizationStatusDenied||status == ALAuthorizationStatusRestricted);
}

- (void)getVideoAuth:(BOOLBLOCK)videoAuth{
    __weak typeof(self)weakSelf = self;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined)
    {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                 completionHandler:^(BOOL granted) {
                                     granted?[weakSelf authAudio:videoAuth]:videoAuth(NO); }];
    }
    else if (authStatus == AVAuthorizationStatusAuthorized)
    { [self authAudio:videoAuth];}
    else
    {videoAuth(NO);}
}

- (void)authAudio:(BOOLBLOCK)audio {
    if ([[AVAudioSession sharedInstance] respondsToSelector:@selector(requestRecordPermission:)]) {
        [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
            audio(granted);
        }];
    }
}

- (void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许%@访问你的摄像头和麦克风。" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark 视频保存相册
+ (void)saveToPhotoWithUrl:(NSURL *)url{
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:url];
    } completionHandler:nil];
}

#pragma mark  视频裁剪   ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️开始
/*
 fileURL :原视频url
 mergeFilePath:新的fileurl
 whScalle:所需裁剪的宽高比
 presetName:压缩视频质量,不传则 AVAssetExportPresetMediumQuality
 */
+ (void)mergeAndExportVideosAtFileURLs:(NSURL *)fileURL newUrl:(NSString *)mergeFilePath widthHeightScale:(CGFloat)whScalle presetName:(NSString *)presetName mergeSucess:(VOIDBLOCK)mergeSucess

{
    NSError *error = nil;
    
    CMTime totalDuration = kCMTimeZero;
    //转换AVAsset
    AVAsset *asset = [AVAsset assetWithURL:fileURL];
    if (!asset) {
        return;
    }
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    //提取音频、视频
    NSArray * assetArray = [asset tracksWithMediaType:AVMediaTypeVideo];
    
    AVAssetTrack *assetTrack;
    if (assetArray.count) {
        assetTrack = [assetArray objectAtIndex:0];
    }
    
    [VideoRecord audioTrackWith:mixComposition assetTrack:assetTrack asset:asset totalDuration:totalDuration error:error];
    
    AVMutableCompositionTrack *videoTrack = [VideoRecord videoTrackWith:mixComposition assetTrack:assetTrack asset:asset totalDuration:totalDuration error:error];
    
    CGFloat renderW = [VideoRecord videoTrackRenderSizeWithassetTrack:assetTrack];
    totalDuration = CMTimeAdd(totalDuration, asset.duration);
    
    NSMutableArray *layerInstructionArray = [VideoRecord assetArrayWith:videoTrack totalDuration:totalDuration assetTrack:assetTrack renderW:renderW widthHeightScale:whScalle];
    
    [VideoRecord mergingVideoWithmergeFilePath:mergeFilePath layerInstructionArray:layerInstructionArray mixComposition:mixComposition totalDuration:totalDuration renderW:renderW widthHeightScale:whScalle presetName:presetName mergeSucess:mergeSucess];
}

//压缩视频
+(void)mergingVideoWithmergeFilePath:(NSString *)mergeFilePath
               layerInstructionArray:(NSMutableArray*)layerInstructionArray
                      mixComposition:(AVMutableComposition *)mixComposition
                       totalDuration:(CMTime)totalDuration
                             renderW:(CGFloat)renderW
                    widthHeightScale:(CGFloat)whScalle
                          presetName:(NSString *)presetName
                         mergeSucess:(VOIDBLOCK)mergeSucess

{
    //get save path
    NSURL *mergeFileURL = [NSURL fileURLWithPath:mergeFilePath];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW/whScalle);//renderW/4*3
    
    __block AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:presetName?:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (exporter.status) {
                case AVAssetExportSessionStatusCompleted:
                    mergeSucess?mergeSucess():nil;
                    break;
                default:
                    break;
            }
        });
    }];
    
}

//合成视频
+ (NSMutableArray *)assetArrayWith:(AVMutableCompositionTrack *)videoTrack
                     totalDuration:(CMTime)totalDuration
                        assetTrack:(AVAssetTrack *)assetTrack
                           renderW:(CGFloat)renderW
                  widthHeightScale:(CGFloat)whScalle

{
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    CGFloat rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
    CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
    layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height/whScalle) / 2.0));//向上移动取中部影响
    layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
    [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
    [layerInstruciton setOpacity:0.0 atTime:totalDuration];
    //data
    [layerInstructionArray addObject:layerInstruciton];
    
    return layerInstructionArray;
}

//视频大小
+(CGFloat)videoTrackRenderSizeWithassetTrack:(AVAssetTrack *)assetTrack{
    
    CGSize renderSize = CGSizeMake(0, 0);
    renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
    renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    return MIN(renderSize.width, renderSize.height);
}

//videoTrack
+(AVMutableCompositionTrack*)videoTrackWith:(AVMutableComposition *)mixComposition
                                 assetTrack:(AVAssetTrack *)assetTrack
                                      asset:(AVAsset *)asset
                              totalDuration:(CMTime)totalDuration
                                      error:(NSError *)error{
    
    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    
    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                        ofTrack:assetTrack
                         atTime:totalDuration
                          error:&error];
    
    
    return videoTrack;
    
}

//audioTrack
+(void)audioTrackWith:(AVMutableComposition *)mixComposition
           assetTrack:(AVAssetTrack *)assetTrack
                asset:(AVAsset *)asset
        totalDuration:(CMTime)totalDuration
                error:(NSError *)error{
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    NSArray *array =  [asset tracksWithMediaType:AVMediaTypeAudio];
    if (array.count > 0) {
        AVAssetTrack *audiok =[array objectAtIndex:0];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:audiok
                             atTime:totalDuration
                              error:nil];
    }
}
#pragma mark  视频裁剪   ⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️⚙️结束

#pragma mark - 视频地址
+ (NSString *)generateFilePathWithType:(NSString *)fileType{
    return  [[[self class] getVideoPathCache] stringByAppendingString:[[self class] getVideoNameWithType:fileType]];
}

+ (NSString *)getVideoPathCache
{
    NSString *videoCache = [NSTemporaryDirectory() stringByAppendingPathComponent:@"videos"] ;
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:videoCache isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        [fileManager createDirectoryAtPath:videoCache withIntermediateDirectories:YES attributes:nil error:nil];
    };
    return videoCache;
}

+ (NSString *)getVideoNameWithType:(NSString *)fileType
{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HHmmss"];
    NSDate * NowDate = [NSDate dateWithTimeIntervalSince1970:now];
    ;
    NSString * timeStr = [formatter stringFromDate:NowDate];
    NSString *fileName = [NSString stringWithFormat:@"/video_%@.%@",timeStr,fileType];
    return fileName;
}

#pragma mark 获取文件大小
+ (CGFloat)getfileSize:(NSString *)filePath
{
    NSFileManager *fm = [NSFileManager defaultManager];
    filePath = [filePath stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    CGFloat fileSize = 0;
    if ([fm fileExistsAtPath:filePath]) {
        fileSize = [[fm attributesOfItemAtPath:filePath error:nil] fileSize];
        NSLog(@"视频 - - - - - %fM,--------- %fKB",fileSize / (1024.0 * 1024.0),fileSize / 1024.0);
    }
    return fileSize/1024/1024;
}

















@end
