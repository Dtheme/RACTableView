//
//  DzwBaseVC.m
//  RACTable
//
//  Created by Mac on 2021/7/12.
//

#import "DzwBaseVC.h"

@interface DzwBaseVC ()

@end

@implementation DzwBaseVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    [self.view setBackgroundColor:UIColor.whiteColor];
    /** 去掉导航栏下的分割线 */
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    // Do any additional setup after loading the view.
    [self configUI];
    [self bindData];
    [self excuteCommands];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.modalPresentationStyle = UIModalPresentationFullScreen;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
   
    
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
  
}

#pragma mark -
- (void)setPopGestureRecognizerEnabled:(BOOL)popGestureRecognizerEnabled{
    if (self.navigationController.interactivePopGestureRecognizer.isEnabled == popGestureRecognizerEnabled) {
        return;
    }
    _popGestureRecognizerEnabled = popGestureRecognizerEnabled;
    self.navigationController.interactivePopGestureRecognizer.enabled = popGestureRecognizerEnabled;
}


-(BOOL)shouldAutorotate{
    return NO;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;//UIInterfaceOrientationMaskAll;
}

//一开始的方向
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

#pragma mark - public
- (void)configUI{};
- (void)bindData{};
- (void)excuteCommands{};


@end
