//
//  UIResponder+DResponderRouter.h
//  DResponderRouter
//
//  Created by dzw on 2023/8/22.
//  Copyright © 2023 ZEGO. All rights reserved.
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
