//
//  FieldTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsEditableInfo.h"
@protocol FieldTableViewCellDelegate <NSObject>

@optional
-(void)getData:(NSString *)text;

@end

@interface FieldTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(GoodsEditableInfo *)editInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, weak) id <FieldTableViewCellDelegate> fieldDelegate;

@end
