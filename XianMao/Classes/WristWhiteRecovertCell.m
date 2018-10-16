//
//  WristWhiteRecovertCell.m
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristWhiteRecovertCell.h"

@implementation WristWhiteRecovertCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WristWhiteRecovertCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 40.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)title isReturnGoods:(NSInteger)returnGoods
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WristWhiteRecovertCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    [dict setObject:@(returnGoods) forKey:@"returnGoods"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        self.titleLbl.font = [UIFont systemFontOfSize:15];
        self.iconImageView.image = [UIImage imageNamed:@"WristwatchRecovery_GoodsDetail_Icon_Black_new"];
        [self.rightBtn setImage:[UIImage imageNamed:@"WristwatchRecovery_GoodsDetail_Right_Black"] forState:UIControlStateNormal];
        
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *title = dict[@"title"];
    NSNumber *isReturnGoods = dict[@"returnGoods"];
    self.titleLbl.text = title;
    
    if (isReturnGoods.integerValue == 0) {
        self.rightBtn.hidden = YES;
    } else {
        self.rightBtn.hidden = NO;
    }
}

@end
