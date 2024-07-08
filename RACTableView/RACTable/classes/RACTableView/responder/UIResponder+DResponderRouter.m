//
//  UIResponder+DResponderRouter.m
//  DResponderRouter
//
//  Created by dzw on 2023/8/22.
//  Copyright © 2023 ZEGO. All rights reserved.
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
