//
//  ImageDescTableViewCell.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ImageDescDO.h"


@interface ImageDescGroupTitleTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(ImageDescGroup*)imageDescGroup;
+ (NSString*)cellDictKeyForImageDescGroup;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface ImageDescTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(ImageDescDO*)imageDescDO;
+ (NSString*)cellDictKeyForImageDescDO;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
