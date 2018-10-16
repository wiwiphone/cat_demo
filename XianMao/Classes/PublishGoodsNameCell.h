//
//  PublishGoodsNameCell.h
//  yuncangcat
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

//typedef void(^downGoodsName)(NSString *goodsName);

//@protocol PublishGoodsNameCellDelegate <NSObject>
//
//@optional
//-(void)getGoodsName:(NSString *)goodsName;
//
//@end

@interface PublishGoodsNameCell : BaseTableViewCell

//@property (nonatomic, copy) downGoodsName downGoodsName;
//@property (nonatomic, weak) id<PublishGoodsNameCellDelegate> goodsNameDelegate;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)goodsName cateName:(NSString *)cateName brandName:(NSString *)brandName grade:(NSString *)grade brandEnName:(NSString *)brandEnName;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
