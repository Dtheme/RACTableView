//
//  DzwTool.m
//  RACTable
//
//  Created by Mac on 2021/7/12.
//

#import "DzwTool.h"

@implementation DzwTool
+ (CGRect)getRectByWidth:(CGFloat)width string:(id)string font:(UIFont *)font{
    CGRect suggestedRect = CGRectZero;
    if ([string isKindOfClass:[NSString class]]) {
        suggestedRect = [string boundingRectWithSize:CGSizeMake(width==0?MAXFLOAT:width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                          attributes:@{NSFontAttributeName :font }
                                             context:nil];
        
    }else if ([string isKindOfClass:[NSMutableAttributedString class]]){
        NSMutableAttributedString *attributedStr = (NSMutableAttributedString *)string;
        [attributedStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedStr.length)];
        suggestedRect = [attributedStr boundingRectWithSize:CGSizeMake(width==0?MAXFLOAT:width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                             context:nil];
    }
    suggestedRect.size.height = ceil(suggestedRect.size.height);
    return suggestedRect;
}
@end
