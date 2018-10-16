//
//  GoodsGalleryGridCell.h
//  XianMao
//
//  Created by simon on 1/17/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsTableViewCell.h"

@class GoodsInfo;
@interface GoodsGalleryGridCell : BaseTableViewCell //先不继承GoodsTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item;
+ (NSString*)cellDictKeyForGoodsInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end

@interface GoodsGalleryGridView : UIView

+ (CGFloat)heightForOrientationPortrait:(GoodsInfo*)goodsInfo;
- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo;

@end

