//
//  ResponderEventManager.m
//  DResponderRouter
//
//  Created by dzw on 2023/9/6.
//  Copyright © 2023 dzw. All rights reserved.
//


#import "ResponderEventManager.h"

@implementation ResponderEventManager
+ (instancetype)shareInstance {
    static ResponderEventManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ResponderEventManager alloc]init];
    });
    return manager;
}

- (NSMutableDictionary <NSString *, NSInvocation *> *)eventInvocationDict {
    if (_eventInvocationDict == nil) {
        _eventInvocationDict = [NSMutableDictionary dictionary];
    }
    return _eventInvocationDict;
}

@end
