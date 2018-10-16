//
//  BonusNoChooseTableViewCell.m
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BonusNoChooseTableViewCell.h"

@interface BonusNoChooseTableViewCell ()

@property (nonatomic, strong) XMWebImageView *bgImageView;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation BonusNoChooseTableViewCell

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:16.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chooseBtn setImage:[UIImage imageNamed:@"quan_normal"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"quan_select"] forState:UIControlStateSelected];
    }
    return _chooseBtn;
}

-(XMWebImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _bgImageView.image = [UIImage imageNamed:@"Bonus_Bg_N"];
    }
    return _bgImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BonusNoChooseTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    return 74;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)title selected:(BOOL)isYesSelect
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BonusNoChooseTableViewCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    [dict setObject:[NSNumber numberWithBool:isYesSelect] forKey:@"isYesSelected"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.chooseBtn];
        [self.bgImageView addSubview:self.titleLbl];
        
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
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.left.equalTo(self.bgImageView.mas_left).offset(22);
    }];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.right.equalTo(self.bgImageView.mas_right).offset(-20);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSString *title = dict[@"title"];
    BOOL isYesSelected = [dict boolValueForKey:@"isYesSelected"];
    
    self.titleLbl.text = title;
    self.chooseBtn.selected = isYesSelected;
    
}

@end
