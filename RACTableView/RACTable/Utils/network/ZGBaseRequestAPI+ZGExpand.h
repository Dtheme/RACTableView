//
//  ZGBaseRequestAPI+ZGExpand.h
//  DaVinci
//
//  Created by hunk on 2019/7/11.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import "ZGBaseRequestAPI.h"

#define kLogonInvalidationNotiCancelKey @"cancel"  //取消
#define kRequestErrorCommonMsg @"请求失败"

#define kParserErrorNotDictonaryCode 9527   //返回的数据不是字典
#define kParserErrorDataMissCode     9528   //字段缺失
NS_ASSUME_NONNULL_BEGIN

@interface ZGBaseRequestAPI (ZGExpand)

/**
 解析数据第一步

 @param result 网络请求结果
 @param success 返回数据成功
 @param failure 返回失败
 */
- (void)result:(id)result success:(void (^)(id _Nonnull data))success failure:(void (^)(int code,NSString *message))failure;
/**
 解析数据第一步
 
 @param result 网络请求结果
 @param success 返回数据成功
 @param failure 返回失败
 */
- (void)resultTypeTwo:(id)result success:(void (^)(id _Nonnull data))success failure:(void (^)(int code,NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
