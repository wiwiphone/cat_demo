//
//  MeasurementView.m
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MeasurementView.h"

@interface MeasurementView ()

@property (nonatomic, strong) UILabel *lbl;

@end

@implementation MeasurementView

-(UILabel *)lbl{
    if (!_lbl) {
        _lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbl.font = [UIFont systemFontOfSize:15.f];
        _lbl.textColor = [UIColor colorWithHexString:@"dddddd"];
        [_lbl sizeToFit];
    }
    return _lbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.lbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

-(void)getText:(NSString *)text{
    self.lbl.text = text;
}

@end
