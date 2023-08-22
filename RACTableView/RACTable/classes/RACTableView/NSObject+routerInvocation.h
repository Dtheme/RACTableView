//
//  NSObject+routerInvocation.h
//  DResponderRouter
//
//  Created by zhn on 2017/7/27.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (routerInvocation)
- (NSInvocation *)dzw_makeInvocationWithSelector:(SEL)selector;
- (void)dzw_invoke:(NSInvocation *)invocation userInfo:(NSDictionary *)userInfo;
- (void)dzw_responderRouterWithName:(NSString *)name userInfo:(NSDictionary *)userInfo;
@end
