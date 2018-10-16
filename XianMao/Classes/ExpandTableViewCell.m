//
//  ExpandTableViewCell.m
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExpandTableViewCell.h"
#import "MeasurementButton.h"
#import "PublishAttrInfo.h"
#import "NetworkManager.h"
#import "Error.h"
#import "NSString+URLEncoding.h"

@interface ExpandTableViewCell ()

@property (nonatomic, strong) UILabel *numberLbl;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UIButton *questionBtn;
@property (nonatomic, strong) UIButton *yijianpipeiBtn;
@property (nonatomic, strong) UILabel *seriesLbl;
@property (nonatomic, strong) UITextField *seriesTextField;

@property (nonatomic, strong) UILabel *measurementLbl;
@property (nonatomic, strong) MeasurementButton *measureBtn;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, assign) NSInteger cateId;
@property (nonatomic, assign) NSInteger brandId;
@end

@implementation ExpandTableViewCell

-(UIView *)lineView1{
    if (!_lineView1) {
        _lineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView1.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    }
    return _lineView1;
}

-(MeasurementButton *)measureBtn{
    if (!_measureBtn) {
        _measureBtn = [[MeasurementButton alloc] initWithFrame:CGRectZero];
        _measureBtn.backgroundColor = [UIColor whiteColor];
    }
    return _measureBtn;
}

-(UILabel *)measurementLbl{
    if (!_measurementLbl) {
        _measurementLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _measurementLbl.font = [UIFont systemFontOfSize:15.f];
        _measurementLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_measurementLbl sizeToFit];
        _measurementLbl.text = @"尺寸";
    }
    return _measurementLbl;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    }
    return _lineView;
}

-(UIButton *)yijianpipeiBtn{
    if (!_yijianpipeiBtn) {
        _yijianpipeiBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_yijianpipeiBtn setTitle:@"尝试一键匹配" forState:UIControlStateNormal];
        [_yijianpipeiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _yijianpipeiBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _yijianpipeiBtn.backgroundColor = [UIColor colorWithHexString:@"434342"];
    }
    return _yijianpipeiBtn;
}

-(UIButton *)questionBtn{
    if (!_questionBtn) {
        _questionBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_questionBtn setImage:[UIImage imageNamed:@"Publish_Question"] forState:UIControlStateNormal];
        [_questionBtn sizeToFit];
    }
    return _questionBtn;
}

-(UITextField *)seriesTextField{
    if (!_seriesTextField) {
        _seriesTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _seriesTextField.borderStyle = UITextBorderStyleNone;
        _seriesTextField.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _seriesTextField.layer.borderWidth = 1.f;
    }
    return _seriesTextField;
}

-(UILabel *)seriesLbl{
    if (!_seriesLbl) {
        _seriesLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _seriesLbl.font = [UIFont systemFontOfSize:15.f];
        _seriesLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_seriesLbl sizeToFit];
        _seriesLbl.text = @"系列";
    }
    return _seriesLbl;
}

-(UITextField *)numberTextField{
    if (!_numberTextField) {
        _numberTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _numberTextField.borderStyle = UITextBorderStyleNone;
        _numberTextField.layer.borderColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        _numberTextField.layer.borderWidth = 1.f;
    }
    return _numberTextField;
}

-(UILabel *)numberLbl{
    if (!_numberLbl) {
        _numberLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _numberLbl.font = [UIFont systemFontOfSize:15.f];
        _numberLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_numberLbl sizeToFit];
        _numberLbl.text = @"编号";
    }
    return _numberLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ExpandTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    
    return  150;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)listArr andCateId:(NSInteger)cateId andBrandId:(NSInteger)brandId
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpandTableViewCell class]];
    if (listArr) {
        [dict setObject:listArr forKey:@"listArr"];
    }
    if (cateId>0) {
        [dict setObject:[NSNumber numberWithInteger:cateId] forKey:@"cateId"];
    }
    if (brandId>0) {
        [dict setObject:[NSNumber numberWithInteger:brandId] forKey:@"brandId"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.numberLbl];
        [self.contentView addSubview:self.numberTextField];
        [self.contentView addSubview:self.questionBtn];
        [self.contentView addSubview:self.yijianpipeiBtn];
        [self.contentView addSubview:self.seriesLbl];
        [self.contentView addSubview:self.seriesTextField];
//        [self.contentView addSubview:self.measurementLbl];
//        [self.contentView addSubview:self.measureBtn];
        
        [self.contentView addSubview:self.lineView];
        [self.contentView addSubview:self.lineView1];
        
        [self.measureBtn addTarget:self action:@selector(clickMeasureBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.yijianpipeiBtn addTarget:self action:@selector(clickYijianPP) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
    
}

-(void)clickYijianPP{
    NSDictionary *param = @{@"brand_id":@(7780), @"category_id":@(73), @"number":[self.numberTextField.text URLEncodedString]};//self.brandId  self.cateId
    
    [[CoordinatingController sharedInstance] showProcessingHUD:@""];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_match_product_info" parameters:param completionBlock:^(NSDictionary *data) {
        [[CoordinatingController sharedInstance] hideHUD];
        
    } failure:^(XMError *error) {
        [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)clickMeasureBtn{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.numberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(30);
    }];
    
    [self.numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLbl.mas_right).offset(5);
        make.width.equalTo(@170);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.numberLbl.mas_centerY);
    }];
    
    [self.questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.numberTextField.mas_centerY);
        make.left.equalTo(self.numberTextField.mas_right).offset(5);
    }];
    
    [self.yijianpipeiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.questionBtn.mas_centerY);
        make.left.equalTo(self.questionBtn.mas_right).offset(5);
        make.height.equalTo(@22);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
    }];
    
    [self.seriesLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.numberLbl.mas_bottom).offset(20);
    }];
    
    [self.seriesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.numberLbl.mas_right).offset(5);
        make.width.equalTo(@170);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.seriesLbl.mas_centerY);
    }];
    
//    [self.measurementLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//        make.top.equalTo(self.seriesLbl.mas_bottom).offset(20);
//    }];
//    
//    [self.measureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.measurementLbl.mas_right).offset(5);
//        make.right.equalTo(self.contentView.mas_right).offset(-20);
//        make.height.equalTo(@30);
//        make.centerY.equalTo(self.measurementLbl.mas_centerY);
//    }];
    
    [self.lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.seriesTextField.mas_bottom).offset(20);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@1);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSNumber *cateId = dict[@"cateId"];
    NSNumber *brandId = dict[@"brandId"];
    
    self.cateId = cateId.integerValue;
    self.brandId = brandId.integerValue;
}

@end
