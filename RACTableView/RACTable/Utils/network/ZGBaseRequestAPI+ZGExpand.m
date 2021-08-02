//
//  ZGBaseRequestAPI+ZGExpand.m
//  DaVinci
//
//  Created by hunk on 2019/7/11.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import "ZGBaseRequestAPI+ZGExpand.h"
#import <UIKit/UIKit.h>

@implementation ZGBaseRequestAPI (ZGExpand)
- (void)result:(YTKBaseRequest * _Nonnull)result success:(void (^)(id _Nonnull))success failure:(void (^)(int, NSString * _Nonnull))failure{
    if ([result.responseObject isKindOfClass:[NSDictionary class]]) {
        if ([[result.responseObject allKeys]containsObject:@"code"]) {
            if ([result.responseObject[@"code"] isEqualToString:@"200"]) {
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

- (void)resultTypeTwo:(YTKBaseRequest * _Nonnull)result success:(void (^)(id _Nonnull))success failure:(void (^)(int, NSString * _Nonnull))failure{
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
