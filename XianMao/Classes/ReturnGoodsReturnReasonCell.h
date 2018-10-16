//
//  ReturnGoodsReturnReasonCell.h
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"


typedef void(^returnReason)(NSString * reason);

@interface ReturnGoodsReturnReasonCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIButton *chooseReasonBtn;
@property (nonatomic, strong) UIImageView *chooseImageView;
@property (nonatomic,copy) returnReason  returnReason;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSMutableArray*)reasonArr;
+ (NSMutableDictionary*)buildCellDict:(NSMutableArray*)reasonArr;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
