//
//  FKBaseRequest+Rac.h
//  DavinciGrade
//
//  Created by dzw on 2020/12/22.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import "ZGBaseRequestAPI.h"
#import <ReactiveObjC/ReactiveObjC.h>

@interface ZGBaseRequestAPI (Rac)

- (RACSignal *)rac_requestSignal;
@end
