//
//  RequestTool.m
//  WBAPP
//
//  Created by hibor on 2018/3/29.
//  Copyright © 2018年 hibor. All rights reserved.
//

#import "RequestTool.h"

@interface RequestTool()
@property(nonatomic,strong)Reachability *reachabilityManager;
@end


@implementation RequestTool


singleton_implementation(RequestTool)

-(void)HBGETRequestDataWithPath:(NSString *)path isHaveNetWork:(void (^)(void))isWorking failuare:(void (^)(NSError *error))failuare success:(void (^)(id))success{

    self.reachabilityManager = [Reachability reachabilityForInternetConnection];
    if ([self.reachabilityManager currentReachabilityStatus] == NotReachable) {
        isWorking();
        return;
    }
  
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:@"http://zixuanguapp.finance.qq.com" forHTTPHeaderField:@"Referer"];
    //设置超时 20s
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TIMEOUT;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager GET:path parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"%lf",downloadProgress.fractionCompleted);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *Error = nil;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&Error];
        
        if (success && dict) {
            success(dict);
        }else{
            failuare(nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error code = %ld",error.code);
        if (error.code == -1001) {
            failuare(error);
        }
        failuare(nil);
    }];
    
}


-(void)HBGETRequestDataWithPath:(NSString *)path WithParamert:(NSDictionary *)paramert isHaveNetWork:(void (^)(void))isWorking failuare:(void (^)(void))failuare success:(void (^)(id))success{
    
    self.reachabilityManager = [Reachability reachabilityForInternetConnection];
    if ([self.reachabilityManager currentReachabilityStatus] == NotReachable) {
        isWorking();
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:path parameters:paramert progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *resultString = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* data = [resultString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *Error = nil;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&Error];
        
        if (success && dict) {
            success(dict);
        }else{
            failuare();
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failuare();
    }];
    
}
@end
