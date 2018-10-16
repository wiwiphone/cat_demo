//
//  PayDetermineView.m
//  XianMao
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayDetermineView.h"
#import "Command.h"
#import "WCAlertView.h"

@interface PayDetermineView ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;

@property (nonatomic, strong) CommandButton *chooseBtn;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *yuanPriceLbl;
@property (nonatomic, strong) UIView *lineView;
@end

@implementation PayDetermineView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dddddd"];
    }
    return _lineView;
}

-(UILabel *)yuanPriceLbl{
    if (!_yuanPriceLbl) {
        _yuanPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _yuanPriceLbl.font = [UIFont systemFontOfSize:12.f];
        _yuanPriceLbl.textColor = [UIColor colorWithHexString:@"dddddd"];
        [_yuanPriceLbl sizeToFit];
    }
    return _yuanPriceLbl;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:12.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(CommandButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_chooseBtn setImage:[UIImage imageNamed:@"JiangxinWashChoose"] forState:UIControlStateSelected];
        [_chooseBtn setImage:[UIImage imageNamed:@"pay_checkbox_uncheck"] forState:UIControlStateNormal];
        _chooseBtn.layer.masksToBounds = YES;
        _chooseBtn.layer.cornerRadius = 12;
        _chooseBtn.selected = YES;
    }
    return _chooseBtn;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"dddddd"];
        [_contentLbl sizeToFit];
        _contentLbl.text = @"卖家寄给爱丁猫鉴定通过后再寄给我";
    }
    return _contentLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"爱丁猫鉴定服务";
    }
    return _titleLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _iconImageView.image = [UIImage imageNamed:@"Pay_Determine"];
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.chooseBtn];
        [self addSubview:self.priceLbl];
        [self addSubview:self.yuanPriceLbl];
        [self.yuanPriceLbl addSubview:self.lineView];
        
        self.chooseBtn.handleClickBlock = ^(CommandButton *sender){
            
            if (sender.selected == YES) {
                [WCAlertView showAlertWithTitle:@"确认取消" message:@"取消有风险" customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    
                    if (buttonIndex == 0) {
                        
                    } else {
                        sender.selected = !sender.selected;
                        if (weakSelf.chooseDetermine) {
                            weakSelf.chooseDetermine(sender.selected);
                        }
                    }
                    
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            } else {
                sender.selected = !sender.selected;
                if (weakSelf.chooseDetermine) {
                    weakSelf.chooseDetermine(sender.selected);
                }
            }
            
        };
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.height.equalTo(@14);
        make.width.equalTo(@14);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(4);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(4);
        make.left.equalTo(self.iconImageView.mas_left);
    }];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.chooseBtn.mas_left).offset(-10);
        make.bottom.equalTo(self.titleLbl.mas_bottom);
    }];
    
    [self.yuanPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLbl.mas_right);
        make.top.equalTo(self.contentLbl.mas_top);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.yuanPriceLbl.mas_centerY);
        make.left.equalTo(self.yuanPriceLbl.mas_left).offset(-2);
        make.right.equalTo(self.yuanPriceLbl.mas_right).offset(2);
        make.height.equalTo(@1);
    }];
}

@end
