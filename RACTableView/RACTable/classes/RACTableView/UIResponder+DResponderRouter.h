//
//  UIResponder+DResponderRouter.h
//  DResponderRouter
//
//  Created by zhn on 2017/7/26.
//  Copyright © 2017年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (DResponderRouter)
- (void)dzw_RouterEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;

/// 响应链事件映射
/// - (NSDictionary *)zg_RouteEventMap {
///     return @{@"test1":[self zhn_createInvocationWithSelector:@selector(test:)],
///              @"container":[self zhn_createInvocationWithSelector:@selector(container:)]
///              };
/// }
- (NSDictionary *)dzw_RouteEventMap;
@end
