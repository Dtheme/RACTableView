//
//  UIResponder+DResponderRouter.m
//  DResponderRouter
//
//  Created by zhn on 2017/7/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "UIResponder+DResponderRouter.h"
#import <objc/runtime.h>
#import "ResponderEventManager.h"

@implementation UIResponder (DResponderRouter)
- (instancetype)init {
    if (self = [super init]) {
        [[ResponderEventManager shareInstance].eventInvocationDict addEntriesFromDictionary:[self zg_RouteEventMap]];
    }
    return self;
}

- (void)dzw_RouterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    [self.nextResponder dzw_RouterEventWithName:eventName userInfo:userInfo];
}

- (NSDictionary *)zg_RouteEventMap {

    return nil;
}
@end
