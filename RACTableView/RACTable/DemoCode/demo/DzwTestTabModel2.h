//
//  DzwTestTabModel2.h
//  RACTable
//
//  Created by dzw on 2021/1/21.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DzwTestTabModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DzwTestTabModel2 : NSObject<ZGRacModelDelegate>

@property (nonatomic, copy) NSString *titleString;
//cell内嵌tableview的cell上显示的文字
@property (nonatomic, strong) NSArray <DzwTestTabModel *>*subCellData;
@property (nonatomic, assign) BOOL isfold;
@end

NS_ASSUME_NONNULL_END
