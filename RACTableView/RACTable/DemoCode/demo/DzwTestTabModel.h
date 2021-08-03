//
//  DzwTestTabModel.h
//  RACTable
//
//  Created by dzw on 2021/1/4.
//  Copyright © 2021 dzw. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DzwTestTabModel : NSObject<ZGRacModelDelegate>
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *titleString;
@property (nonatomic, copy) NSString *detailString;
@property (nonatomic, assign) BOOL isfold;
@end

NS_ASSUME_NONNULL_END
