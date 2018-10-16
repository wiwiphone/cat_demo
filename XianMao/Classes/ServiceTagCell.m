//
//  ServiceTagCell.m
//  XianMao
//
//  Created by WJH on 16/10/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ServiceTagCell.h"

@implementation ServiceTagCell

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ServiceTagCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 30;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ServiceTagCell class]];
    if (goodsInfo) {
        [dict setObject:goodsInfo forKey:@"goodsInfo"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    for (UILabel *lbl in self.contentView.subviews) {
        [lbl removeFromSuperview];
    }
    
    GoodsInfo * goodsInfo = [dict objectForKey:@"goodsInfo"];
    if (goodsInfo && [goodsInfo isKindOfClass:[GoodsInfo class]]) {
        CGFloat margin = 20;
        for (int i = 0; i < goodsInfo.serviceIcon.count; i++) {
            NSString *titile = goodsInfo.serviceIcon[i];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
            lbl.font = [UIFont systemFontOfSize:11.f];
            lbl.textColor = [UIColor whiteColor];
            lbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = titile;
            [lbl sizeToFit];
            [self.contentView addSubview:lbl];
            lbl.frame = CGRectMake(margin, 0, lbl.width+4, lbl.height+4);
            margin += lbl.width+5;
        }
    }

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
    }
    return self;
}

@end
