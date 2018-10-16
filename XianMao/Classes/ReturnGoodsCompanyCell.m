//
//  ReturnGoodsCompanyCell.m
//  XianMao
//
//  Created by apple on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsCompanyCell.h"
#import "Masonry.h"

@interface ReturnGoodsCompanyCell ()

@property (nonatomic, strong) UIButton *shunfengBtn;
@property (nonatomic, strong) UIButton *EMSBtn;

@end

@implementation ReturnGoodsCompanyCell

-(UIButton *)EMSBtn{
    if (!_EMSBtn) {
        _EMSBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_EMSBtn setTitle:@"EMS" forState:UIControlStateNormal];
        _EMSBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_EMSBtn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
        _EMSBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _EMSBtn.layer.borderWidth = 1.f;
        _EMSBtn.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
    }
    return _EMSBtn;
}

-(UIButton *)shunfengBtn{
    if (!_shunfengBtn) {
        _shunfengBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shunfengBtn setTitle:@"顺丰速运" forState:UIControlStateNormal];
        _shunfengBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_shunfengBtn setTitleColor:[UIColor colorWithHexString:@"bbbbbb"] forState:UIControlStateNormal];
        _shunfengBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _shunfengBtn.layer.borderWidth = 1.f;
        _shunfengBtn.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
    }
    return _shunfengBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReturnGoodsCompanyCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSMutableArray *)reasonArr{
    CGFloat height = 44.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)reasonArr
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReturnGoodsCompanyCell class]];
    if (reasonArr) {
        [dict setObject:reasonArr forKey:@"reasonArr"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLbl.text = @"物流公司";
        self.chooseReasonBtn.hidden = YES;
        self.chooseImageView.hidden = YES;
        
        [self.contentView addSubview:self.shunfengBtn];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.shunfengBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(20);
        make.right.equalTo(self.chooseReasonBtn.mas_centerX).offset(-6);
        make.height.equalTo(@27);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
}

@end
