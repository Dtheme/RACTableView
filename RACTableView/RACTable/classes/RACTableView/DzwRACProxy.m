//
//  DzwRACProxy.m
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import "DzwRACProxy.h"

@implementation DzwRACProxy

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
