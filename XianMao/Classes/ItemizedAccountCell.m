//
//  ItemizedAccountCell.m
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ItemizedAccountCell.h"
#import "NSDate+Additions.h"

@interface ItemizedAccountCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *priceLbl;

@end

@implementation ItemizedAccountCell

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:13.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:11.f];
        _timeLbl.textColor = [UIColor colorWithHexString:@"c4c4c4"];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ItemizedAccountCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 60;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(AccountLogVo *)logVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ItemizedAccountCell class]];
    if (logVo)[dict setObject:logVo forKey:@"logVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.timeLbl];
        [self.contentView addSubview:self.priceLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        make.left.equalTo(self.contentView.mas_left).offset(13);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(13);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    AccountLogVo *logVo = dict[@"logVo"];
    self.titleLbl.text = logVo.title;
    self.priceLbl.text = logVo.amount_text;//[NSString stringWithFormat:@"+%ld", logVo.amount_cent/100];
    
    NSDate *date = [NSDate dateFromLongLongSince1970:logVo.createtime];;
    self.timeLbl.text = [date formattedDateRelativeToNow];
}

@end
