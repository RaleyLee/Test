//
//  DownHttpRequest.h
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ASIHTTPRequest/ASIHTTPRequest.h>

@class DownHttpRequest;

@protocol DownHttpRequestDelegate <NSObject>

-(void)requestFailed:(DownHttpRequest *)request;
-(void)requestStarted:(DownHttpRequest *)request;
-(void)request:(DownHttpRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
-(void)request:(DownHttpRequest *)request didReceiveBytes:(long long)bytes;
-(void)requestFinished:(DownHttpRequest *)request;

@optional
-(void)request:(DownHttpRequest *)request willRedirectToURL:(NSURL *)newURL;

@end


@interface DownHttpRequest : NSObject

@property(nonatomic,weak) id <DownHttpRequestDelegate> delegate;

@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) NSURL *originalURL;
@property(nonatomic,strong) NSDictionary *userInfo;
@property(nonatomic,assign) NSInteger tag;
@property(nonatomic,copy) NSString *downloadDestinationPath;
@property(nonatomic,copy) NSString *temporaryFileDownloadPath;
@property(nonatomic,strong,readonly) NSError *error;


-(instancetype)initWithURL:(NSURL *)url;
-(void)startAsynchronous;
-(BOOL)isFinished;
-(BOOL)isExecuting;
-(void)cancel;

@end
