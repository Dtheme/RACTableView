//
//  TestloginView.h
//  DavinciGrade
//
//  Created by dzw on 2020/12/25.
//  Copyright © 2020 ZEGO. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestloginView;
@protocol TestloginViewDelegate <NSObject>
-(void)view:(TestloginView *_Nullable)view didSelectLoginButton:(UIButton *_Nullable)button;
@end

NS_ASSUME_NONNULL_BEGIN

@interface TestloginView : UIView
@property (nonatomic, strong) RACSubject *loginSubject;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UITextField *accTF;
@property (nonatomic, strong) UITextField *passwordTF;
@property (nonatomic, strong) RACSignal * LoginBtnTitleEnabel;

- (void)bindLoginVM:(id)viewModel;
@end

NS_ASSUME_NONNULL_END
 
