//
//  OrderAddressCell.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AddressInfo.h"



@interface OrderAddressCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) UILabel *areaLbl;
@property (nonatomic, strong) UILabel *addressLbl;
@property (nonatomic, strong) UILabel *phoneNumLbl;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
