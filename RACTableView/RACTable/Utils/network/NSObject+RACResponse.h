//
//  NSObject+RACResponse.h
//  DavinciGrade
//
//  Created by dzw on 2020/12/25.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (RACResponse)

/**
 解析数据第一步

 @param result 网络请求结果
 @param success 返回数据成功
 @param failure 返回失败
 */
- (void)requestResult:(id)result success:(void (^)(id _Nonnull data))success failure:(void (^)(int code,NSString *message))failure;
/**
 解析数据第一步
 
 @param result 网络请求结果
 @param success 返回数据成功
 @param failure 返回失败
 */
- (void)requestResultTypeTwo:(id)result success:(void (^)(id _Nonnull data))success failure:(void (^)(int code,NSString *message))failure;
@end

NS_ASSUME_NONNULL_END
