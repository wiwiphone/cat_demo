//
//  ReturnGoodsAddressCell.m
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsAddressCell.h"
#import "Masonry.h"

@implementation ReturnGoodsAddressCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReturnGoodsAddressCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(AddressInfo *)addressInfo{
    CGFloat height = 70.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReturnGoodsAddressCell class]];
    if (addressInfo) {
        [dict setObject:addressInfo forKey:@"addressInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImageView.hidden = YES;
//        self.name.text = @"安颖";
//        self.areaLbl.text = @"浙江省 杭州市 余杭区 五常街道";
//        self.addressLbl.text = @"文一西路998号海创园1号楼1106杭州爱丁猫科技有限公司";
//        self.phoneNumLbl.text = @"12345678910";
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.areaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(1);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaLbl.mas_bottom).offset(1);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/375*50);
    }];
    
    [self.phoneNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}


+ (NSMutableDictionary*)buildCellModel:(BuybackOrderModel *)model
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderAddressCell class]];
    if (model) {
        [dict setObject:model forKey:@"model"];
    }
    return dict;
}


-(void)updateCellWithDict:(NSDictionary *)dict
{
    AddressInfo * model = dict[@"addressInfo"];

    if (model.receiver) {
        self.name.text = model.receiver;
    }
    
    if (model.areaDetail) {
        self.addressLbl.text = model.areaDetail;
    }
    
    if (model.phoneNumber) {
        self.phoneNumLbl.text = model.phoneNumber;
    }

}

@end
