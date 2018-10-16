//
//  BandcardTableViewCell.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BankCard.h"
#import "WithdrawalsAccountVo.h"

@interface BandcardTableViewCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(WithdrawalsAccountVo *)withdrawaAccount;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface ServerTelCell : BaseTableViewCell


+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end


@interface alipayAccountCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(WithdrawalsAccountVo *)withdrawaAccount;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
