//
//  TestLoginVC.m
//  DavinciGrade
//
//  Created by dzw on 2020/12/22.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import "TestLoginVC.h"
#import "TestLoginVM.h"
#import "TestloginView.h"

@interface TestLoginVC ()

@property (nonatomic, strong) TestLoginVM *loginVM;
@property (nonatomic, strong) TestloginView *loginView;
 
@end

@implementation TestLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self bindVM];
    [self rac_subjects];
}

-(void)configUI{
    [self.view addSubview:self.loginView];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64+20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-48);
    }];

}

- (void)bindVM{
    [self.loginView bindLoginVM:self.loginVM];
    RAC(_loginVM,account) = _loginView.accTF.rac_textSignal;
    RAC(_loginVM,password) = _loginView.passwordTF.rac_textSignal;
    RAC(_loginView.loginButton,enabled) = _loginVM.LoginBtnEnabel;
    //按钮的筛选条件
    @weakify(self);
    [self.loginVM.LoginBtnEnabel subscribeNext:^(id  _Nullable enable) {
        @strongify(self);
        NSLog(@"vc --- %@",enable);
        BOOL buttonEnable = [enable boolValue];
        if (buttonEnable == NO) {
            self.loginView.loginButton.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:0.1];
        }else{
            self.loginView.loginButton.backgroundColor = [UIColor.orangeColor colorWithAlphaComponent:1];
        }
    }];
}

#pragma mark - rac subject替代代理
- (void)rac_subjects{
    //拉数据按钮事件
    @weakify(self);
    [self.loginView.loginSubject subscribeNext:^(UIButton * _Nullable loginButton) {
        @strongify(self);
//        // vc：1.调用信号
//        [self.loginVM.loginApiCommand execute:nil];
        [loginButton setTitle:@"拉取数据中..." forState:UIControlStateNormal];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [loginButton setTitle:@"获取数据成功（再试一次）" forState:UIControlStateNormal];
            // vc：1.调用信号 拉接口数据
            [self.loginVM.loginApiCommand execute:nil];
        });
    }];

}

- (TestloginView *)loginView{
    if(!_loginView){
        _loginView = [[TestloginView alloc]init];
    }
    return _loginView;
}
- (TestLoginVM *)loginVM{
    if(!_loginVM){
        _loginVM = [[TestLoginVM alloc]init];
    }
    return _loginVM;
}
@end
