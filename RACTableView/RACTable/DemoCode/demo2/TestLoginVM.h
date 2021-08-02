//
//  TestLoginVM.h
//  DavinciGrade
//
//  Created by dzw on 2020/12/22.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DzwTestModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestLoginVM : NSObject
@property (nonatomic, strong) RACCommand *loginApiCommand;
@property (nonatomic, strong) DzwTestModel *testModel;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, strong) RACSignal * LoginBtnEnabel;

@end

NS_ASSUME_NONNULL_END
