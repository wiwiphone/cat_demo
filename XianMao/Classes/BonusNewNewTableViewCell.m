//
//  BonusNewNewTableViewCell.m
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BonusNewNewTableViewCell.h"

@interface BonusNewNewTableViewCell ()

@property (nonatomic, strong) XMWebImageView *bgImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel *renminbiLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *conditionLbl;
@end

@implementation BonusNewNewTableViewCell


-(UILabel *)conditionLbl
{
    if (!_conditionLbl) {
        _conditionLbl = [[UILabel alloc] init];
        _conditionLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _conditionLbl.font = [UIFont systemFontOfSize:14];
        [_conditionLbl sizeToFit];
    }
    return _conditionLbl;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _priceLbl.font = [UIFont systemFontOfSize:24.f];
        _priceLbl.textAlignment = NSTextAlignmentRight;
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UIImageView *)icon
{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = [UIImage imageNamed:@"bouns_used"];
        _icon.hidden = YES;
    }
    return _icon;
}

-(UILabel *)renminbiLbl{
    if (!_renminbiLbl) {
        _renminbiLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _renminbiLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _renminbiLbl.font = [UIFont systemFontOfSize:15.f];
        _renminbiLbl.textAlignment = NSTextAlignmentRight;
        _renminbiLbl.text = @"¥";
        [_renminbiLbl sizeToFit];
    }
    return _renminbiLbl;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _subLbl.font = [UIFont systemFontOfSize:14.f];
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _contentLbl.font = [UIFont systemFontOfSize:14.f];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _titleLbl.font = [UIFont boldSystemFontOfSize:15.f];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(XMWebImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    }
    return _bgImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BonusNewNewTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 120.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(BonusInfo*)bonusInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BonusNewNewTableViewCell class]];
    if (bonusInfo)[dict setObject:bonusInfo forKey:[self cellKeyForBonusInfo]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellKeyForBonusSeleted]];
    return dict;
}

+ (NSString*)cellKeyForBonusInfo {
    return @"bonusInfo";
}

+ (NSString*)cellKeyForBonusIndex {
    return @"bonusIndex";
}

+ (NSString*)cellKeyForBonusSeleted {
    return @"selected";
}

+ (NSMutableDictionary*)buildCellDict:(UITableView*)tableView title:(NSString*)title {
    return [self buildCellDict:tableView title:title];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.titleLbl];
        [self.bgImageView addSubview:self.contentLbl];
        [self.bgImageView addSubview:self.subLbl];
        [self.bgImageView addSubview:self.priceLbl];
        [self.bgImageView addSubview:self.renminbiLbl];
        [self.bgImageView addSubview:self.icon];
        [self.bgImageView addSubview:self.conditionLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top).offset(20);
        make.right.equalTo(self.bgImageView.mas_right).offset(-22);
    }];
    
    [self.renminbiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLbl.mas_left).offset(-3);
        make.bottom.equalTo(self.priceLbl.mas_bottom).offset(-3);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top).offset(25);
        make.left.equalTo(self.bgImageView.mas_left).offset(20);
        make.right.equalTo(self.bgImageView.mas_right).offset(-100);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(23);
        make.left.equalTo(self.bgImageView.mas_left).offset(20);
        make.right.equalTo(self.bgImageView.mas_right).offset(-100);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLbl.mas_bottom).offset(3);
        make.left.equalTo(self.bgImageView.mas_left).offset(20);
    }];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right);
        make.bottom.equalTo(self.bgImageView.mas_bottom);
    }];
    
    [self.conditionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgImageView.mas_right).offset(-22);
        make.bottom.equalTo(self.subLbl.mas_bottom);
    }];
    
}

- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index
{
    BonusInfo *bonusInfo = (BonusInfo*)[dict objectForKey:[[self class] cellKeyForBonusInfo]];
    if (bonusInfo.status == UNUSED) {
        self.bgImageView.image = [UIImage imageNamed:@"Bonus_Bg_N"];
        self.priceLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        self.renminbiLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        self.icon.hidden = YES;
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"Bonus_Bg_S"];
        self.priceLbl.textColor = [UIColor colorWithHexString:@"333333"];
        self.renminbiLbl.textColor = [UIColor colorWithHexString:@"333333"];
        if (bonusInfo.status == USEING) {
            self.icon.hidden = YES;
        }else{
            self.icon.hidden = NO;
        }
    }
    
    self.titleLbl.text = bonusInfo.bonusName;
    self.contentLbl.text = bonusInfo.bonusDesc;
    self.subLbl.text = [NSString stringWithFormat:@"%@至%@",bonusInfo.strUseStartTime,bonusInfo.strUseEndTime];
    self.priceLbl.text = [NSString stringWithFormat:@"%.f", bonusInfo.amount];
    self.conditionLbl.text = [NSString stringWithFormat:@"满%ld可用",bonusInfo.minPayAmountCent/100];
}

@end
