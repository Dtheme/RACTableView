//
//  NSObject+ZGRac.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewCell+ZGRac.h"
#import "UIView+ZGRac.h"
NS_ASSUME_NONNULL_BEGIN


@protocol ZGRacModelDelegate <NSObject>

@optional


/**❗️cellClass和cellNib只可能有一个生效 要么纯代码布局的cell要么xib的cell
 *  cellClass是注册纯代码的cell
 *
 *  eg:  md.cellClass = [DzwTestCell class];
 */
@property (nonatomic, unsafe_unretained) Class<ZGRacTableViewCellDelegate> cellClass;

/**❗️cellClass和cellNib只可能有一个生效 要么纯代码布局的cell要么xib的cell
 * cellNib是注册带xib的cell
 * eg:  md.cellNib = [DzwTestCell class]
 */
@property (nonatomic, unsafe_unretained) Class<ZGRacTableViewCellDelegate> cellNib;

/**
 * cell重用标志 可以为nil 默认使用cell类名字符串作为重用标志
 */
@property (nonatomic, copy, nullable) NSString *cellReuseIdentifier;

/**缓存 cell 的高度，为 nil 时会调用 [cellClass cellHeightForCellModel:self]
 ❗️  1.如果值为0，将会自动认为cell基于autolayout自动布局进行高度自适应 （eg:masonry等自动布局的一般cell高度自适应）
    2.如果值为@(TableViewAutomaticDimension)，cell高度将会默认使用UITableViewAutomaticDimension进行高度自适应（eg:textView输入动态撑起cell的情况）
    3.如果高度为自定义计算的值，cell高度将会以赋值为准设置高度（eg:cell嵌套tableview 需要手动计算高度的时候）
 */
@property (nonatomic, strong) NSNumber *cellHeight;

/** 缓存是否折叠
 *  YES:cell折叠状态 cellHeight = 0 NO：cell展开状态 高度为cellHeight
 */
@property (nonatomic, assign) BOOL isfold;
@property (nonatomic, unsafe_unretained) Class<ZGRacSectionViewDelegate> sectionHeaderClass;
@property (nonatomic, strong) NSNumber *sectionHeaderHeight;

@property (nonatomic, unsafe_unretained) Class<ZGRacSectionViewDelegate> sectionFooterClass;
@property (nonatomic, strong) NSNumber *sectionFooterHeight;

@end

@interface NSObject (ZGRac)

/// 数据添加数据 因为addobject直接添加 rac会无法触发数组数据变化监听
/// @param arrProperty vm中定义的 数组属性的名字 arrProperty使用SEL是为了防止写入@”models“ 没有提示和拼写问题
///  ❗️：arrProperty 必须是可变数组
/// eg: [self mutableArray:@selector(models) addObject:md];
/// @param obj 添加到数组的对象
-(void)mutableArray:(SEL)arrProperty addObject:(id)obj;

@end

NS_ASSUME_NONNULL_END
