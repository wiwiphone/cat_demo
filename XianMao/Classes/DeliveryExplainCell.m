//
//  DeliveryExplainCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "DeliveryExplainCell.h"

@interface DeliveryExplainCell()<TTTAttributedLabelDelegate>

@property (nonatomic, copy) NSString * url;

@end

@implementation DeliveryExplainCell

-(TTTAttributedLabel *)expectedDeliveryLbl
{
    if (!_expectedDeliveryLbl) {
        _expectedDeliveryLbl = [[TTTAttributedLabel alloc] init];
        _expectedDeliveryLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _expectedDeliveryLbl.font = [UIFont systemFontOfSize:13];
        _expectedDeliveryLbl.textAlignment = NSTextAlignmentLeft;
        _expectedDeliveryLbl.linkAttributes = nil;
        [_expectedDeliveryLbl sizeToFit];
    }
    return _expectedDeliveryLbl;
}


+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([DeliveryExplainCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 16;//78/2;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[DeliveryExplainCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildGoodsGuaranteeCellDict:(GoodsGuarantee *)goodsGuarantee
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[DeliveryExplainCell class]];
    if (goodsGuarantee) {
        [dict setObject:goodsGuarantee forKey:[self goodsGuaranteeCellDictForkey]];
    }
    return dict;
}

+(NSString *)cellDictForkey
{
    return @"DeliveryExplainCell";
}

+(NSString *)goodsGuaranteeCellDictForkey
{
    return @"goodsGuarantee";
}

-(void)updateCellWithDict:(NSDictionary *)dict{
  
    GoodsGuarantee * goodsGuarantee = [dict objectForKey:[DeliveryExplainCell goodsGuaranteeCellDictForkey]];
    NSInteger length = 0;
    WEAKSELF;
    if (goodsGuarantee.name.length > 0) {
        length = goodsGuarantee.name.length;
        [self.expectedDeliveryLbl setText:[NSString stringWithFormat:@"● %@",goodsGuarantee.name]afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-length,length);
            if (goodsGuarantee.url.length > 0) {
                weakSelf.url = goodsGuarantee.url;
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"457FB9"] CGColor] range:stringRange];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(subReplyClick:)];
                [weakSelf.expectedDeliveryLbl addGestureRecognizer:tap];
            }
            return mutableAttributedString;
        }];
    }
    
    if (goodsGuarantee.url.length > 0) {
        [self.expectedDeliveryLbl addLinkToURL:[NSURL URLWithString:goodsGuarantee.url] withRange:NSMakeRange([self.expectedDeliveryLbl.text length]-length,length)];
    }

}

- (void)subReplyClick:(UITapGestureRecognizer *)tgr
{
    if (self.handleWashBlock && [self.url length] > 0) {
        self.handleWashBlock(self.url);
    }
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.expectedDeliveryLbl];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.expectedDeliveryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
}

@end
