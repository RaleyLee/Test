//
//  DownLoadDelegate.h
//  Kinds
//
//  Created by hibor on 2018/8/20.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownHttpRequest.h"

@protocol DownLoadDelegate <NSObject>

@optional

-(void)startDownload:(DownHttpRequest *)request;
-(void)updateCellProgress:(DownHttpRequest *)request;
-(void)finishedDownLoad:(DownHttpRequest *)rquest;
-(void)allowNextRequest; //处理一个窗口内连续下载多个文件切重复下载的情况

@end
