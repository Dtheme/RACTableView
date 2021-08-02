//
//  ZGPublicTestAPI.m
//  RACTable
//
//  Created by Mac on 2021/7/14.
//

#import "ZGPublicTestAPI.h"
#import "DzwTestModel.h"

@implementation ZGPublicTestAPI
- (void)startRequestWithBlockWithSuccess:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self result:request success:^(id  _Nonnull data) {
            
            success(request.responseObject);
        } failure:^(int code, NSString * _Nonnull message) {
            failure(message);
        }];
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        failure(request.responseObject);
    }];
}

//使用rac的方式请求接口。
- (RACSignal *)rac_startRequestWithBlockWithSuccess:(void (^)(id _Nonnull))success failure:(void (^)(id _Nonnull))failure{
    return [[[self rac_requestSignal] doNext:^(YTKRequest * _Nullable result) {
        if ([result.responseObject[@"code"] integerValue] == 200) {
            NSDictionary *dict = result.responseObject[@"result"];
            NSLog(@"%@",dict);
            success(dict);
        }else{
            failure(result);
        }
    }] materialize];
}
- (NSString *)baseUrl{
    return @"https://api.apiopen.top/getImages";
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

@end
