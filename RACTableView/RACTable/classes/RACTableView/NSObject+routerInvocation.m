//
//  NSObject+routerInvocation.m
//  DResponderRouter
//
//  Created by zhn on 2017/7/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import "NSObject+routerInvocation.h"
#import "ResponderEventManager.h"


@implementation NSObject (routerInvocation)
- (NSInvocation *)dzw_makeInvocationWithSelector:(SEL)selector {
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        return nil;
    }
    NSInvocation*invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    return invocation;
}

- (void)dzw_invoke:(NSInvocation *)invocation userInfo:(NSDictionary *)userInfo{
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
}

- (void)dzw_responderRouterWithName:(NSString *)name userInfo:(NSDictionary *)userInfo {
    NSInvocation *invication = [[ResponderEventManager shareInstance].eventInvocationDict objectForKey:name];
    [self dzw_invoke:invication userInfo:userInfo];
}
@end
