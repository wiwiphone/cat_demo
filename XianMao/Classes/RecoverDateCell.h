//
//  RecoverDateCell.h
//  XianMao
//
//  Created by 阿杜 on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"
@interface RecoverDateCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO;

@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIView *HXView;
@property (nonatomic, strong) UILabel *timeLabel;

@end
