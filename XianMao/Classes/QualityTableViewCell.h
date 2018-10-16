//
//  QualityTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
@class GoodsEditableInfo;

@protocol QualityTableViewCellDelegate <NSObject>

@optional
-(void)getQuaData:(UIButton *)btn;

@end

@interface QualityTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(GoodsEditableInfo *)editInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, weak) id <QualityTableViewCellDelegate> quaDelegate;

@end
