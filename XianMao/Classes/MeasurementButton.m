//
//  MeasurementButton.m
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MeasurementButton.h"
#import "MeasurementView.h"

@interface MeasurementButton ()

@property (nonatomic, strong) MeasurementView *heightView;
@property (nonatomic, strong) UILabel *chengLbl;
@property (nonatomic, strong) MeasurementView *widthView;
@property (nonatomic, strong) UILabel *chengLbl2;
@property (nonatomic, strong) MeasurementView *longView;
@property (nonatomic, strong) UILabel *mmLbl;

@end

@implementation MeasurementButton

-(UILabel *)mmLbl{
    if (!_mmLbl) {
        _mmLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _mmLbl.font = [UIFont systemFontOfSize:13.f];
        _mmLbl.textColor = [UIColor colorWithHexString:@"dddddd"];
        [_mmLbl sizeToFit];
        _mmLbl.text = @"mm";
    }
    return _mmLbl;
}

-(MeasurementView *)longView{
    if (!_longView) {
        _longView = [[MeasurementView alloc] initWithFrame:CGRectZero];
        _longView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _longView.layer.borderWidth = 1.f;
    }
    return _longView;
}

-(UILabel *)chengLbl2{
    if (!_chengLbl2) {
        _chengLbl2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _chengLbl2.font = [UIFont systemFontOfSize:13.f];
        _chengLbl2.textColor = [UIColor colorWithHexString:@"dddddd"];
        [_chengLbl2 sizeToFit];
        _chengLbl2.text = @"×";
    }
    return _chengLbl2;
}

-(MeasurementView *)widthView{
    if (!_widthView) {
        _widthView = [[MeasurementView alloc] initWithFrame:CGRectZero];
        _widthView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _widthView.layer.borderWidth = 1.f;
    }
    return _widthView;
}

-(UILabel *)chengLbl{
    if (!_chengLbl) {
        _chengLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _chengLbl.font = [UIFont systemFontOfSize:13.f];
        _chengLbl.textColor = [UIColor colorWithHexString:@"dddddd"];
        [_chengLbl sizeToFit];
        _chengLbl.text = @"×";
    }
    return _chengLbl;
}

-(MeasurementView *)heightView{
    if (!_heightView) {
        _heightView = [[MeasurementView alloc] initWithFrame:CGRectZero];
        _heightView.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _heightView.layer.borderWidth = 1.f;
    }
    return _heightView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.heightView];
        [self.heightView getText:@"长"];
        [self addSubview:self.chengLbl];
        [self addSubview:self.widthView];
        [self.widthView getText:@"宽"];
        [self addSubview:self.chengLbl2];
        [self addSubview:self.longView];
        [self.longView getText:@"高"];
        [self addSubview:self.mmLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.heightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@70);
    }];
    
    [self.chengLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.heightView.mas_centerY);
        make.left.equalTo(self.heightView.mas_right).offset(5);
    }];
    
    [self.widthView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.chengLbl.mas_right).offset(5);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@70);
    }];
    
    [self.chengLbl2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.heightView.mas_centerY);
        make.left.equalTo(self.widthView.mas_right).offset(5);
    }];
    
    [self.longView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.chengLbl2.mas_right).offset(5);
        make.bottom.equalTo(self.mas_bottom);
        make.width.equalTo(@70);
    }];
    
    [self.mmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.longView.mas_centerY);
        make.left.equalTo(self.longView.mas_right).offset(5);
    }];

}

@end
