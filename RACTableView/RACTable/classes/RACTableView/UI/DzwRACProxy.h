//
//  DzwRACProxy.h
//  RACTable
//
//  Created by dzw on 2021/1/1.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DzwRACProxy : NSObject

@property (nonatomic, weak) id middleman;
@property (nonatomic, weak) id receiver;
+ (__kindof DzwRACProxy *)sharedEventProxy;
- (void)handleEvent:(NSString *)eventName userInfo:(NSDictionary *)userInfo withTarget:(UIViewController*)target;
- (NSInvocation *)createInvocationWithSelector:(SEL)selector;
@end
