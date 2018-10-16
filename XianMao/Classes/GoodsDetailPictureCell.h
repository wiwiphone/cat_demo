//
//  GoodsDetailPictureCell.h
//  XianMao
//
//  Created by simon on 1/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class GoodsDetailPictureCell;
@class GoodsDetailPicItem;

@interface GoodsDetailPictureCell : BaseTableViewCell
@property(nonatomic,retain) XMWebImageView *picView;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSString*)cellDictKeyForGoodsPicture;
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailPicItem*)item;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface GoodsDetailTitleCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString*)title isOpen:(NSInteger)isOpen b2cOrc2c:(NSInteger)b2cOrc2c;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
