//
//  BonusTableViewCell.m
//  XianMao
//
//  Created by simon on 2/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BonusTableViewCell.h"

@implementation BonusTableViewCell {
    UILabel *_descLbl;
    UILabel *_timeLbl;
    CAShapeLayer *_bottomBorder;
    UIImageView *_iconView;
    UIImageView *_seletedIcon;
    UIImageView *_containerView;
    UIButton * _selectButton;
    UILabel *_subLbl;
    UILabel *_priceLbl;
    UILabel *_renminbiLbl;
    UILabel * _conditionLbl;
    UILabel *_notUse;
    UILabel *_unableUse;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BonusTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    BonusInfo *info = dict[[self cellKeyForBonusInfo]];
    CGFloat height = 0;
    if ([info.bonusId isEqualToString:@"-1000"]) {
        height = 74.f;
    } else {
        height = 130.f;
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(BonusInfo*)bonusInfo BonusSeleted:(BOOL)BonusSeleted isHaveUnableLbl:(BOOL)isHaveUnableLbl{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BonusTableViewCell class]];
    if (bonusInfo)[dict setObject:bonusInfo forKey:[self cellKeyForBonusInfo]];
    [dict setObject:[NSNumber numberWithBool:BonusSeleted] forKey:[self cellKeyForBonusSeleted]];
    [dict setObject:[NSNumber numberWithBool:isHaveUnableLbl] forKey:@"isHaveUnableLbl"];
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"bonusContainer"];
        [self.contentView addSubview:_containerView];
        
        
        _descLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _descLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _descLbl.font = [UIFont boldSystemFontOfSize:15.f];
        _descLbl.numberOfLines = 0;
        _descLbl.textAlignment = NSTextAlignmentCenter;
        [_descLbl sizeToFit];
        [_containerView addSubview:_descLbl];
        
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.textColor = [UIColor colorWithHexString:@"a6a6a6"];
        _subLbl.font = [UIFont systemFontOfSize:12.f];
        [_subLbl sizeToFit];
        [_containerView addSubview:_subLbl];
        
        _conditionLbl = [[UILabel alloc] init];
        _conditionLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _conditionLbl.font = [UIFont systemFontOfSize:12];
        [_conditionLbl sizeToFit];
        [_containerView addSubview:_conditionLbl];
        
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _timeLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _timeLbl.font = [UIFont systemFontOfSize:10.f];
        _timeLbl.numberOfLines = 1;
        _timeLbl.textAlignment = NSTextAlignmentCenter;
        [_timeLbl sizeToFit];
        [_containerView addSubview:_timeLbl];
        
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"quan_normal"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"quan_select"] forState:UIControlStateSelected];
        [_containerView addSubview:_selectButton];
        
        _renminbiLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _renminbiLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _renminbiLbl.font = [UIFont systemFontOfSize:16.f];
        [_renminbiLbl sizeToFit];
        _renminbiLbl.text = @"¥";
        [_containerView addSubview:_renminbiLbl];
        
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _priceLbl.font = [UIFont systemFontOfSize:24.f];
        [_priceLbl sizeToFit];
        [_containerView addSubview:_priceLbl];
        
        _notUse = [[UILabel alloc] initWithFrame:CGRectZero];
        _notUse.textColor = [UIColor colorWithHexString:@"434342"];
        _notUse.font = [UIFont systemFontOfSize:15.f];
        [_notUse sizeToFit];
        [_containerView addSubview:_notUse];
        
        _unableUse = [[UILabel alloc] initWithFrame:CGRectZero];
        _unableUse.textColor = [UIColor colorWithHexString:@"434342"];
        _unableUse.font = [UIFont systemFontOfSize:14.f];
        [_unableUse sizeToFit];
        [_containerView addSubview:_unableUse];
        _unableUse.hidden = YES;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
 
    _iconView.hidden = YES;
    _seletedIcon.hidden = YES;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

-(void)layoutView:(BonusInfo *)bonusInfo{
    [_containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(14, 17, 0, 17));
    }];
    [_descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(27);
        make.left.equalTo(_containerView.mas_left).offset(20);
    }];
    
    [_subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_descLbl.mas_bottom).offset(20);
        make.left.equalTo(_containerView.mas_left).offset(20);
        make.right.equalTo(_containerView.mas_right).offset(-100);
    }];
    
    [_timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_subLbl.mas_bottom).offset(3);
        make.left.equalTo(_containerView.mas_left).offset(20);
    }];
    
    [_selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_containerView.mas_right).offset(-22);
        make.bottom.equalTo(_containerView.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    if (bonusInfo.canUse == 1) {
        [_unableUse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_selectButton.mas_centerY);
            make.right.equalTo(_selectButton.mas_left).offset(-5);
        }];
    } else {
        [_unableUse mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_selectButton.mas_centerY);
            make.right.equalTo(_containerView.mas_right).offset(-22);
        }];
    }
    
    [_priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_containerView.mas_top).offset(20);
        make.right.equalTo(_containerView.mas_right).offset(-22);
    }];
    
    [_renminbiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_priceLbl.mas_bottom).offset(-2);
        make.right.equalTo(_priceLbl.mas_left).offset(-3);
    }];
    
    [_notUse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_containerView.mas_centerY);
        make.left.equalTo(_containerView.mas_left).offset(20);
    }];
    
    [_conditionLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_priceLbl.mas_bottom).offset(2);
        make.right.equalTo(_containerView.mas_right).offset(-22);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index
{
    BonusInfo *bonusInfo = (BonusInfo*)[dict objectForKey:[[self class] cellKeyForBonusInfo]];
    BOOL isHaveUnableLbl = [dict boolValueForKey:@"isHaveUnableLbl"];
    self.isHaveUnableLbl = isHaveUnableLbl;
    if ([bonusInfo isKindOfClass:[BonusInfo class]]) {
//        self.contentView.backgroundColor = index%2==0?[UIColor colorWithHexString:@"EDCD88"]:[UIColor colorWithHexString:@"F1D392"];
        
        _descLbl.text = bonusInfo.bonusName;
        _subLbl.text = bonusInfo.bonusDesc;
        _priceLbl.text = [NSString stringWithFormat:@"%ld",bonusInfo.amountCent/100];
        _conditionLbl.text = [NSString stringWithFormat:@"满%ld可用",bonusInfo.minPayAmountCent/100];
        _timeLbl.text = [NSString stringWithFormat:@"(%@至%@)",bonusInfo.strUseStartTime,bonusInfo.strUseEndTime];
        
        if ([bonusInfo isExpired]) {
//            self.contentView.backgroundColor = [UIColor colorWithHexString:@"D4C7A9"];
            UIImage *icon = [UIImage imageNamed:@"quan_status_overtime.png"];
            _iconView.image = icon;
            _iconView.frame = CGRectMake(kScreenWidth-icon.size.width, 0, icon.size.width, icon.size.height);
            _iconView.hidden = NO;
        } else if ([bonusInfo isUsed]) {
//            self.contentView.backgroundColor = [UIColor colorWithHexString:@"EDCD88"];
            UIImage *icon = [UIImage imageNamed:@"quan_status_used.png"];
            _iconView.image = icon;
            _iconView.frame = CGRectMake(kScreenWidth-icon.size.width, 0, icon.size.width, icon.size.height);
            _iconView.hidden = NO;
        } else {
            _iconView.hidden = YES;
        }
        
        _selectButton.selected = [dict boolValueForKey:[[self class] cellKeyForBonusSeleted]];
        
        
        _notUse.text = @"不使用优惠券";
        
        if ([bonusInfo.bonusId isEqualToString:@"-1000"]) {
            _notUse.hidden = NO;
            _descLbl.hidden = YES;
            _subLbl.hidden = YES;
            _priceLbl.hidden = YES;
            _timeLbl.hidden = YES;
            _iconView.hidden = YES;
            _renminbiLbl.hidden = YES;
            _conditionLbl.hidden = YES;
        } else {
            _notUse.hidden = YES;
            _descLbl.hidden = NO;
            _subLbl.hidden = NO;
            _priceLbl.hidden = NO;
            _timeLbl.hidden = NO;
            _iconView.hidden = NO;
            _conditionLbl.hidden = NO;
            _renminbiLbl.hidden = NO;
        }
        
        if (self.isHaveUnableLbl) {
            _unableUse.hidden = NO;
            if (![bonusInfo.bonusId isEqualToString:@"-1000"]) {
                if (bonusInfo.canUse == 0) {
                    _unableUse.text = @"本单不可用";
                    _selectButton.hidden = YES;
                    _containerView.image = [UIImage imageNamed:@"Bonus_Bg_S"];
                    
                } else {
                    _unableUse.text = @"本单可用";
                    _selectButton.hidden = NO;
                    _containerView.image = [UIImage imageNamed:@"bonusContainer"];
                    
                }
            } else {
                _unableUse.hidden = YES;
                _selectButton.hidden = NO;
                _containerView.image = [UIImage imageNamed:@"bonusContainer"];
            }
        } else {
            _unableUse.hidden = YES;
            _selectButton.hidden = NO;
            _containerView.image = [UIImage imageNamed:@"bonusContainer"];
        }
        
        [self layoutView:bonusInfo];
        [self setNeedsLayout];
    }
}


@end



