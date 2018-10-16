//
//  RewardTableViewCell.m
//  XianMao
//
//  Created by simon cai on 25/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RewardTableViewCell.h"

@implementation RewardTitleTableViewCell {
    UILabel *_codeLbl;
    UILabel *_typeDescLbl;
    UILabel *_rewardLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RewardTitleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 58.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(RewardRecordItem*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RewardTitleTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellKeyForRewardRecord]];
    return dict;
}

+ (NSString*)cellKeyForRewardRecord {
    return @"rewardRecord";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _codeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _codeLbl.font = [UIFont systemFontOfSize:12.f];
        _codeLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _codeLbl.text = @"用户";
        _codeLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_codeLbl];
        
        _typeDescLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeDescLbl.font = [UIFont systemFontOfSize:12.f];
        _typeDescLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _typeDescLbl.text = @"方式";
        _typeDescLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_typeDescLbl];
        
        _rewardLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rewardLbl.font = [UIFont systemFontOfSize:12.f];
        _rewardLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _rewardLbl.text = @"金额";
        _rewardLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rewardLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_codeLbl sizeToFit];
    [_typeDescLbl sizeToFit];
    [_rewardLbl sizeToFit];
    
    _codeLbl.frame = CGRectMake(40, 34, self.contentView.width-80, _codeLbl.height);
    _typeDescLbl.frame = CGRectMake(40, 34, self.contentView.width-80, _codeLbl.height);
    _rewardLbl.frame = CGRectMake(40, 34, self.contentView.width-80, _rewardLbl.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    [self setNeedsLayout];
}

@end

@implementation RewardTableViewCell {
    CALayer *_topLine;
    UILabel *_codeLbl;
    UILabel *_typeDescLbl;
    UILabel *_rewardLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RewardTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 52.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(RewardRecordItem*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RewardTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellKeyForRewardRecord]];
    return dict;
}

+ (NSString*)cellKeyForRewardRecord {
    return @"rewardRecord";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"AAAAAA"].CGColor;
        [self.contentView.layer addSublayer:_topLine];
        
        _codeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _codeLbl.font = [UIFont systemFontOfSize:12.f];
        _codeLbl.textColor = [UIColor colorWithHexString:@"282828"];
        _codeLbl.text = @"";
        _codeLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_codeLbl];
        
        _typeDescLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeDescLbl.font = [UIFont systemFontOfSize:12.f];
        _typeDescLbl.textColor = [UIColor colorWithHexString:@"282828"];
        _typeDescLbl.text = @"";
        _typeDescLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_typeDescLbl];
        
        _rewardLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rewardLbl.font = [UIFont systemFontOfSize:12.f];
        _rewardLbl.textColor = [UIColor colorWithHexString:@"D9A22B"];
        _rewardLbl.text = @"";
        _rewardLbl.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_rewardLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topLine.frame = CGRectMake(40, 0, self.contentView.width-80, 0.5f);
    
    [_codeLbl sizeToFit];
    [_typeDescLbl sizeToFit];
    [_rewardLbl sizeToFit];
    
    _codeLbl.frame = CGRectMake(40, 0, self.contentView.width-80, self.contentView.height);
    _typeDescLbl.frame = CGRectMake(40, 0, self.contentView.width-80, self.contentView.height);
    _rewardLbl.frame = CGRectMake(40, 0, self.contentView.width-80, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RewardRecordItem *item = [dict objectForKey:[[self class] cellKeyForRewardRecord]];
    if ([item isKindOfClass:[RewardRecordItem class]]) {
        _codeLbl.text = item.username;
        _typeDescLbl.text = item.type_desc;
        _rewardLbl.text = [NSString stringWithFormat:@"¥%@",formatRewardMoney(item.reward_money)];
        [self setNeedsLayout];
    }
}

@end

@implementation RewardRecordItem
@end

NSString *formatRewardMoney(double money) {
    NSString *strMoney = nil;
    if ((NSInteger)(money*100)%100>0) {
        if ((NSInteger)(money*100)%10>0) {
            strMoney = [NSString stringWithFormat:@"%.2f",money];
        } else {
            strMoney = [NSString stringWithFormat:@"%.1f",money];
        }
    } else {
        strMoney = [NSString stringWithFormat:@"%ld",(long)money];
    }
    return strMoney;
}
