//
//  NSError+ZGCommon.h
//  DaVinci
//
//  Created by hunk on 2019/12/20.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//常用错误提示
#define kErrorNetWorkMsg @"网络异常"

#define kParserErrorCommonCode       1949   //通用错误码
#define kNetErrorCommonCode     1948

//domain
FOUNDATION_EXPORT NSString *const ZGCommonErrorDomain;
FOUNDATION_EXPORT NSString *const ZGRequestErrorDomain;
FOUNDATION_EXPORT NSString *const ZGNetErrorDomain;
FOUNDATION_EXPORT NSString *const ZGRecordErrorDomain;

@interface NSError (ZGCommon)

/** 自定义code  用来接收后台非200的错误等  */
+ (NSError *)requestErrorCode:(int)code userInfo:(nullable NSDictionary*)userInfo;
+ (NSError *)commonNetErrorWithLocalDescription:(NSString *)description;
+ (NSError *)errorCode:(int)code localDescription:(NSString *)description;
/** 通用错误 */
+ (NSError *)commonErrorWithUserInfo:(nullable NSDictionary*)userInfo;
/** 详细描述的错误 */
+ (NSError *)commonErrorWithLocalizedDescription:(NSString *)description;

@end


NS_ASSUME_NONNULL_END
