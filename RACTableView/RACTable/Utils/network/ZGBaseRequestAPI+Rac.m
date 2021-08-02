//
//  FKBaseRequest+Rac.m
//  DavinciGrade
//
//  Created by dzw on 2020/12/22.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import "ZGBaseRequestAPI+Rac.h"
#import "NSObject+RACDescription.h"

@implementation ZGBaseRequestAPI (Rac)

- (RACSignal *)rac_requestSignal
{
    [self stop];
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 开始请求
        [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            [subscriber sendNext:request];
            [subscriber sendCompleted];
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            [subscriber sendError:[request error]];
        }];
        
        return [RACDisposable disposableWithBlock:^{
            [self stop];
        }];
    }] takeUntil:[self rac_willDeallocSignal]];
    
    //调试用
    #warning 测试代码
    #ifdef DEBUG
        [signal setNameWithFormat:@"%@ 🌗rac请求：",  RACDescription(self)];
    #endif
    return signal;
}



@end
