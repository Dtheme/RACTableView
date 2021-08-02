//
//  TestLoginVM.m
//  DavinciGrade
//
//  Created by dzw on 2020/12/22.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import "TestLoginVM.h"
#import "ZGPublicTestAPI.h"
#import "NSObject+RACResponse.h"

@implementation TestLoginVM

//vm： 1.vm初始化的时候调用初始化信号
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configSignal];
    }
    return self;
}

// vm: 2.信号
- (void)configSignal{
    //拉取数据按钮命令
    @weakify(self);
    _loginApiCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        return [self executeLoginSignal];
    }];
}

- (RACSignal *)executeLoginSignal{
    //测试输入框输入账号密码带过来
    NSLog(@"账号：%@\n密码：%@",self.account,self.password);
    
    // 测试请求发出
    ZGPublicTestAPI *openApi = [[ZGPublicTestAPI alloc]init];
    return [openApi rac_startRequestWithBlockWithSuccess:^(NSArray *  _Nonnull result) {
        
        self.testModel = [DzwTestModel modelWithDictionary:result[arc4random()%(result.count-1)]];
    } failure:^(id  _Nonnull error) {
        NSLog(@"ZGLoginAPI error");
    }];
}

@end
