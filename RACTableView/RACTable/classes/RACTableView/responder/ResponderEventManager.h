//
//  ResponderEventManager.h
//  DResponderRouter
//
//  Created by dzw on 2023/9/6.
//  Copyright © 2023 dzw. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface ResponderEventManager : NSObject
@property (nonatomic,strong) NSMutableDictionary <NSString *, NSInvocation *> *eventInvocationDict;
+ (instancetype)shareInstance;
@end
