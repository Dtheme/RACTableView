//
//  UIColor+Hex.h
//  RACTable
//
//  Created by dzw on 2019/7/23.
//  Copyright © 2019 dzw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/**
 16进制web颜色 支持6位和8位显示
 param  hex： 6位： #CFCFCF，8位：#FFCFCFCF，前两位为透明度，后面6位表示颜色，同android。
 return UIColor
 */
+ (UIColor *)hex:(NSString *)hex;

@end
