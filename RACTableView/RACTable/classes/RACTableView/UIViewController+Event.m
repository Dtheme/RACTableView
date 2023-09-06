//
//  UIViewController+Event.m
//  ResponderChain
//
//  Created by dzw on 2023/9/6.
//  Copyright © 2023 dzw. All rights reserved.
//

#import "UIViewController+Event.h"
#import "DzwRACProxy.h"
@implementation UIViewController (Event)

#pragma mark - ResponderEventDeal
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    // 结合Decorator模式,包装userInfo
    NSMutableDictionary * decoratorDic = [NSMutableDictionary dictionaryWithDictionary:userInfo];
    [decoratorDic setObject:@"MoreInfo" forKey:@"Decorator"];
    
    // 响应事件
    [[DzwRACProxy sharedEventProxy] handleEvent:eventName userInfo:decoratorDic withTarget:self];
    //[super routerEventWithName:eventName userInfo:userInfo]; // 如果需要继续往上传递则打开
}

@end
