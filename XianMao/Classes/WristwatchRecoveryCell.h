//
//  WristwatchRecoveryCell.h
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol WristwatchRecoveryCellDelegate <NSObject>

@optional
-(void)showExplain;

@end

@interface WristwatchRecoveryCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;

- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, weak) id<WristwatchRecoveryCellDelegate> wristDelegate;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *rightBtn;

@end
