//
//  UIResponder+Router.m
//  ResponderChain
//
//  Created by dzw on 2023/9/6.
//  Copyright © 2023 dzw. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo{
    [[self nextResponder] routerEventWithName:eventName userInfo:userInfo];
}
@end
