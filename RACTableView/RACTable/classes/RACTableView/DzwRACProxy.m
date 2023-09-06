//
//  DzwRACProxy.m
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwRACProxy.h"

@interface DzwRACProxy()
@property (nonatomic,weak) UIViewController *delegate;
@end

@implementation DzwRACProxy

+ (__kindof DzwRACProxy *)sharedEventProxy
{
    static DzwRACProxy * proxy = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        proxy = [DzwRACProxy alloc];
    });
    return proxy;
}
#pragma mark - 事件处理
- (NSInvocation *)createInvocationWithSelector:(SEL)selector {
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[[self.delegate class] instanceMethodSignatureForSelector:selector]];
    invocation.target = self.delegate;
    invocation.selector = selector;
    return invocation;
}
- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo withTarget:(UIViewController*)target {
    if (!_delegate)_delegate = target;
    NSInvocation * invocation = [self createInvocationWithSelector:NSSelectorFromString(eventName)];
    [invocation setArgument:&userInfo atIndex:2];
    [invocation invoke];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.middleman respondsToSelector:aSelector]) return self.middleman;
    if ([self.receiver respondsToSelector:aSelector]) return self.receiver;
    return [super forwardingTargetForSelector:aSelector];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if ([self.middleman respondsToSelector:aSelector]) return YES;
    if ([self.receiver respondsToSelector:aSelector]) return YES;
    return [super respondsToSelector:aSelector];
}

@end
