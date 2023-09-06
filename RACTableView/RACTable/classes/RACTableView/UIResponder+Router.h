//
//  UIResponder+Router.h
//  ResponderChain
//
//  Created by dzw on 2023/9/6.
//  Copyright © 2023 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end
