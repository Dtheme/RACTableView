//
//  ZGBaseRequestAPI.m
//  DaVinci
//
//  Created by zego_iOS on 2019/6/21.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import "ZGBaseRequestAPI.h"

@implementation ZGBaseRequestAPI

- (void)start{
    NSString *requestMethod;
    if (self.requestMethod == 0) {
        requestMethod = @"GET";
    }else if (self.requestMethod == 1){
        requestMethod = @"POST";
    }else if (self.requestMethod == 2){
        requestMethod = @"HEAD";
    }else if (self.requestMethod == 3){
        requestMethod = @"PUT";
    }else if (self.requestMethod == 4){
        requestMethod = @"DELETE";
    }else if (self.requestMethod == 5){
        requestMethod = @"PATCH";
    }else{
        requestMethod = @"未知请求类型";
    }
    NSLog(@"网络请求++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n url:%@ requestMethod:%@ parms:%@",[self.baseUrl stringByAppendingString:self.requestUrl],requestMethod,self.requestArgument);
    [super start];
}
/** 请求超时 统一15s */
- (NSTimeInterval)requestTimeoutInterval{
    return 15;
}
#pragma mark - 请求结果回调
/** 失败主线程回调 */
- (void)requestFailedFilter{
    NSString *msg = @"网络异常";
    if (self.error.code == -1001) {//NSURLErrorTimedOut  超时
        msg = @"连接超时";
    }else if (self.error.code == -1003){//NSURLErrorCannotFindHost  找不到服务器
        
    }else if (self.error.code == -1004){//NSURLErrorCannotConnectToHost 连接不上服务器
        
    }else if (self.error.code == -1005){//NSURLErrorNetworkConnectionLost 网络连接异常
        
    }
    self.errorMsg = msg;
    
}
/** 失败子线程回调 */
- (void)requestFailedPreprocessor{
    
}

-(YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

/** 成功主线程回调 */
- (void)requestCompleteFilter{

}

/** 成功子线程回调 */
- (void)requestCompletePreprocessor{
    NSLog(@"%@ %@",self.requestUrl,self.responseObject);
}

@end
