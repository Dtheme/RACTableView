//
//  TestloginView.m
//  DavinciGrade
//
//  Created by dzw on 2020/12/25.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import "TestloginView.h"
#import "TestLoginVM.h"


@interface TestloginView ()
<
UITextFieldDelegate
>

@property (nonatomic, strong) UITextView *loginTextV;
@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) TestLoginVM *loginVM;
@end

@implementation TestloginView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //配置UI
        [self configUI];
    }
    return self;
}

//view绑定vm
- (void)bindLoginVM:(id)viewModel{
    _loginVM = viewModel;
    
    @weakify(self);
    [[_loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        NSLog(@"login");
        if (self.loginSubject) {
            [self.loginSubject sendNext:self.loginButton];
        }
    }];
    
    //按钮的筛选条件
    self.loginVM.LoginBtnEnabel = [RACSignal combineLatest:@[RACObserve(self.loginVM, password),RACObserve(self.loginVM, account),RACObserve(self.loginButton.titleLabel, text)] reduce:^id _Nonnull{
        @strongify(self);
        return
        @(self.loginVM.password.length >5 &&
            self.loginVM.account.length >5 &&
        (![self.loginButton.titleLabel.text isEqualToString:@"拉取数据中..."]));
    }];
    
    [RACObserve(self.loginVM, testModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            self.loginTextV.text = [NSString stringWithFormat:@"%@",((DzwTestModel *)x).time];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                //在此处处理耗时操作
                NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",((DzwTestModel *)x).img]];
                NSData * data = [NSData dataWithContentsOfURL:url];
                UIImage * image = [UIImage imageWithData:data];
                if (image == nil) {
                    NSLog(@"❗️图片加载失败");
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.imageV.image = image;
                    });
                }
            });
        }
    }];
    
#ifdef DEBUG
    self.passwordTF.text = @"a123456";
    self.accTF.text = @"18064021388";
#endif
}

- (void)configUI{
    self.backgroundColor = UIColor.whiteColor;
    [self addSubview:self.accTF];
    [self.accTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(0);
    }];
    [self addSubview:self.passwordTF];
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-100);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.accTF.mas_bottom).offset(10);
    }];
    [self addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(44);
    }];
    [self addSubview:self.loginTextV];
    [self.loginTextV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.passwordTF.mas_bottom).offset(10);
        make.height.mas_equalTo(50);
    }];
    [self addSubview:self.imageV];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.loginTextV.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.loginButton.mas_top).offset(-10);
    }];
}

#pragma mark - getter/setter
- (UIButton *)loginButton{
    if(!_loginButton){
        _loginButton = [[UIButton alloc]init];
        _loginButton.backgroundColor = UIColor.orangeColor;
        [_loginButton setTitle:@"拉取网络数据" forState:UIControlStateNormal];
    }
    return _loginButton;
}

- (UITextView *)loginTextV{
    if(!_loginTextV){
        _loginTextV = [[UITextView alloc]init];
        _loginTextV.editable = NO;
        _loginTextV.text = @"暂无数据";
    }
    return _loginTextV;
}
- (RACSubject *)loginSubject{
    if (!_loginSubject) {
        _loginSubject = [RACSubject subject];
    }
    return _loginSubject;
}

- (UITextField *)accTF{
    if(!_accTF){
        _accTF = [[UITextField alloc]init];
        _accTF.backgroundColor = UIColor.orangeColor;
        _accTF.delegate = self;
        _accTF.placeholder = @"手机号";
    }
    return _accTF;
}

- (UITextField *)passwordTF{
    if(!_passwordTF){
        _passwordTF = [[UITextField alloc]init];
        _passwordTF.backgroundColor = UIColor.orangeColor;
        _passwordTF.delegate = self;
        _passwordTF.placeholder = @"密码";
    }
    return _passwordTF;
}

- (UIImageView *)imageV{
    if(!_imageV){
        _imageV = [[UIImageView alloc]init];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageV;
}
@end
