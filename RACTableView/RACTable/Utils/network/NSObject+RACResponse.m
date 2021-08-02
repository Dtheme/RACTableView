//
//  NSObject+RACResponse.m
//  DavinciGrade
//
//  Created by dzw on 2020/12/25.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import "NSObject+RACResponse.h"
#import "ZGBaseRequestAPI+ZGExpand.h"
#import <UIKit/UIKit.h>


@implementation NSObject (RACResponse)
- (void)requestResult:(YTKBaseRequest * _Nonnull)result success:(void (^)(id _Nonnull))success failure:(void (^)(int, NSString * _Nonnull))failure{
    if ([result.responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[result.responseObject allKeys]containsObject:@"code"]) {
            if ([result.responseObject[@"code"] integerValue] == 200) {
                if ([[result.responseObject allKeys] containsObject:@"data"]) {
                    if ([result.responseObject[@"data"] isEqual:[NSNull null]]) {//data为空
                        success([NSDictionary dictionary]);
                    }else{
                        success(result.responseObject[@"data"]);
                    }
                }else{
                    failure(kParserErrorDataMissCode,kRequestErrorCommonMsg);
                }
            }else{
                if ([[result.responseObject allKeys]containsObject:@"message"]) {
                    failure([result.responseObject[@"code"]intValue],result.responseObject[@"message"]);
                }else{
                    failure([result.responseObject[@"code"]intValue],kRequestErrorCommonMsg);
                }
            }
        }else{
            failure(kParserErrorDataMissCode,kRequestErrorCommonMsg);
        }
    }else{
        failure(kParserErrorNotDictonaryCode,kRequestErrorCommonMsg);
    }
}

- (void)requestResultTypeTwo:(YTKBaseRequest * _Nonnull)result success:(void (^)(id _Nonnull))success failure:(void (^)(int, NSString * _Nonnull))failure{
    if ([result.responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[result.responseObject allKeys]containsObject:@"code"]) {
            if ([result.responseObject[@"code"] intValue] == 200) {
                if ([[result.responseObject allKeys] containsObject:@"data"]) {
                    success(result.responseObject[@"data"]);
                }else{
                    failure(kParserErrorDataMissCode,kRequestErrorCommonMsg);
                }
            }else{
                if ([[result.responseObject allKeys]containsObject:@"message"]) {
                    failure([result.responseObject[@"code"]intValue],result.responseObject[@"message"]);
                }else{
                    failure([result.responseObject[@"code"]intValue],@"");
                }
            }
        }else{
            failure(kParserErrorDataMissCode,kRequestErrorCommonMsg);
        }
    }else{
        failure(kParserErrorNotDictonaryCode,kRequestErrorCommonMsg);
    }
}

@end
