//
//  NSError+ZGCommon.m
//  DaVinci
//
//  Created by hunk on 2019/12/20.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import "NSError+ZGCommon.h"

//domain
NSString *const ZGCommonErrorDomain = @"ZGCommonErrorDomain";
NSString *const ZGRequestErrorDomain = @"ZGRequestErrorDomain";
NSString *const ZGNetErrorDomain = @"ZGNetErrorDomain";
NSString *const ZGRecordErrorDomain = @"ZGRecordErrorDomain";

@implementation NSError (ZGCommon)

+ (NSError *)requestErrorCode:(int)code userInfo:(NSDictionary *)userInfo{
    return [NSError errorWithDomain:ZGRequestErrorDomain code:code userInfo:userInfo];
}
+ (NSError *)commonNetErrorWithLocalDescription:(NSString *)description{
    return [NSError errorWithDomain:ZGNetErrorDomain code:kNetErrorCommonCode userInfo:@{NSLocalizedDescriptionKey:kISNullString(description)?@"未知错误":description}];
}
+ (NSError *)errorCode:(int)code localDescription:(NSString *)description{
    return [NSError errorWithDomain:ZGCommonErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:kISNullString(description)?@"未知错误":description}];
}
+ (NSError *)commonErrorWithUserInfo:(NSDictionary *)userInfo{
    return [NSError errorWithDomain:ZGCommonErrorDomain code:kParserErrorCommonCode userInfo:userInfo];
}
+ (NSError *)commonErrorWithLocalizedDescription:(NSString *)description{
    return [NSError errorWithDomain:ZGCommonErrorDomain code:kParserErrorCommonCode userInfo:@{NSLocalizedDescriptionKey:kISNullString(description)?@"未知错误":description}];
}

@end
