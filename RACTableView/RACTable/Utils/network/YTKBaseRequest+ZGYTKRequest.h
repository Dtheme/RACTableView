//
//  YTKBaseRequest+ZGYTKRequest.h
//  DaVinci
//
//  Created by zego_iOS on 2019/6/20.
//  Copyright © 2019 zego_iOS. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import <ReactiveObjC/ReactiveObjC.h>
NS_ASSUME_NONNULL_BEGIN

@interface YTKBaseRequest (ZGYTKRequest)
- (void)startRequestWithBlockWithSuccess:(void (^)(id result))success
                                 failure:(void (^)(id error))failure;

- (RACSignal *)rac_startRequestWithBlockWithSuccess:(void (^)(id _Nonnull result))success
                                            failure:(void (^)(id _Nonnull error))failure;
@end

NS_ASSUME_NONNULL_END
