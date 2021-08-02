//
//  ZGBaseRequestAPI.h
//  DaVinci
//
//  Created by zego_iOS on 2019/6/21.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "NSObject+RACResponse.h"
#import "NSError+ZGCommon.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZGBaseRequestAPI : YTKBaseRequest
/** 错误信息 */
@property (nonatomic,copy) NSString *errorMsg;
@end

NS_ASSUME_NONNULL_END
