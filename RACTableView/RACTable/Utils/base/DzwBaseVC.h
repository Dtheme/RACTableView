//
//  DzwBaseVC.h
//  RACTable
//
//  Created by Mac on 2021/7/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DzwBaseVC : UIViewController

/** 手势返回 */
@property (nonatomic,assign) BOOL popGestureRecognizerEnabled;

#pragma mark - public 空方法 预定义方法 减少重复写调用代码 在viewdidload调用
/** 创建UI公共方法 可以不用每个类都写一遍[self xxx]*/
- (void)configUI;
/** 如果模块使用mvvm统一使用这个方法绑定vm*/
- (void)bindData;
/** 绑定tableview的事件信号*/
- (void)excuteCommands;
@end

NS_ASSUME_NONNULL_END
