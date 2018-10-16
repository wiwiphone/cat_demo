//
//  BonusNewTableViewCell.m
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BonusNewTableViewCell.h"
#import "Masonry.h"
#import "TTTAttributedLabel.h"

@interface BonusNewTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) TTTAttributedLabel *priceLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *desLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UIImageView *stateImageView;

@end

@implementation BonusNewTableViewCell{
    UIImageView *_seletedIcon;
}

-(UIImageView *)stateImageView{
    if (!_stateImageView) {
        _stateImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _stateImageView;
}

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:10.f];
        _timeLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

-(UILabel *)desLbl{
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLbl.font = [UIFont systemFontOfSize:10.f];
        _desLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_desLbl sizeToFit];
    }
    return _desLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:10.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(TTTAttributedLabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        _priceLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BonusNewTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 80.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(BonusInfo*)bonusInfo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BonusNewTableViewCell class]];
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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.priceLbl];
        [self.bgView addSubview:self.lineView];
        [self.bgView addSubview:self.titleLbl];
        [self.bgView addSubview:self.desLbl];
        [self.bgView addSubview:self.timeLbl];
        [self.bgView addSubview:self.stateImageView];
        _seletedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"quan_chosen.png"]];
        _seletedIcon.backgroundColor = [UIColor clearColor];
        _seletedIcon.hidden = YES;
        [self.bgView addSubview:_seletedIcon];
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(kScreenWidth/320*1.17*15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(18);
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-18);
        make.centerX.equalTo(self.bgView.mas_centerX).offset(-60);
        make.width.equalTo(@1);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_right).offset(15);
        make.top.equalTo(self.lineView.mas_top).offset(3);
    }];
    
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_left).offset(15);
        make.centerY.equalTo(self.lineView.mas_centerY);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lineView.mas_left).offset(15);
        make.bottom.equalTo(self.lineView.mas_bottom).offset(-3);
    }];
    
    [self.stateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right);
        make.bottom.equalTo(self.bgView.mas_bottom);
    }];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _seletedIcon.frame = CGRectMake(self.contentView.width-20-_seletedIcon.width, (self.height-_seletedIcon.height)/2, _seletedIcon.width, _seletedIcon.height);

   
}

- (void)updateCellWithDict:(NSDictionary *)dict index:(NSInteger)index
{
    BonusInfo *bonusInfo = (BonusInfo*)[dict objectForKey:[[self class] cellKeyForBonusInfo]];
    if ([bonusInfo isKindOfClass:[BonusInfo class]]) {
        
        NSString *strLbl = [NSString stringWithFormat:@"¥ %.f", bonusInfo.amount];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", strLbl]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:NSMakeRange(0,str.length)];
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(2,str.length-2)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(0, 1)];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:26.f] range:NSMakeRange(2, str.length-2)];
        self.priceLbl.attributedText = str;
        self.desLbl.text = bonusInfo.bonusDesc;
        self.timeLbl.text = [NSString stringWithFormat:@"%@至%@",bonusInfo.strUseStartTime,bonusInfo.strUseEndTime];
        
        if ([bonusInfo isExpired]) {
            self.bgView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
            UIImage *icon = [UIImage imageNamed:@"Un_Use_MF"];
            self.stateImageView.image = icon;
            self.stateImageView.hidden = NO;
        } else if ([bonusInfo isUsed]) {
            self.bgView.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
            UIImage *icon = [UIImage imageNamed:@"Al_Use_MF"];
            self.stateImageView.image = icon;
            self.stateImageView.hidden = NO;
        } else {
            UIImage *icon = [UIImage imageNamed:@"Be_Use_MF"];
            self.stateImageView.image = icon;
            self.stateImageView.hidden = NO;
        }
        _seletedIcon.hidden = ![dict boolValueForKey:[[self class] cellKeyForBonusSeleted]];
        [self setNeedsLayout];
    }
}


@end
