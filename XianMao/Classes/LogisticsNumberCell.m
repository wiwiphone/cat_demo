//
//  LogisticsNumberCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LogisticsNumberCell.h"



@implementation LogisticsNumberCell

-(UILabel *)LogisticsNum
{
    if (!_LogisticsNum) {
        _LogisticsNum = [[UILabel alloc] initWithFrame:CGRectMake(14, 10, kScreenWidth/375*80, 27)];
        _LogisticsNum.font = [UIFont systemFontOfSize:13.0f];
        _LogisticsNum.textColor = [UIColor colorWithHexString:@"d3d3d3"];
        _LogisticsNum.text = @"*  物流单号";
    }
    return _LogisticsNum;
}

-(UITextField *)LogisticsNumTf
{
    if (!_LogisticsNumTf) {
        _LogisticsNumTf = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, CGRectGetWidth(self.textViewBg.frame)-32, CGRectGetHeight(self.textViewBg.frame))];
        _LogisticsNumTf.delegate = self;
    }
    return _LogisticsNumTf;
}

-(UIView *)textViewBg
{
    if (!_textViewBg) {
        _textViewBg = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.LogisticsNum.frame)+2, self.LogisticsNum.origin.y, kScreenWidth/375*265, 27)];
        _textViewBg.layer.borderWidth = 1.0;
        _textViewBg.layer.borderColor = [UIColor colorWithHexString:@"bbbbbb"].CGColor;
    }
    return _textViewBg;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.logistics) {
        self.logistics(textField.text);
    }
}



-(UIButton *)two_dimensionBtn
{
    if (!_twoDimensionBtn) {
        _twoDimensionBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.textViewBg.frame)-27, 2, 23, 23)];
        [_twoDimensionBtn setBackgroundImage:[UIImage imageNamed:@"scanning"] forState:UIControlStateNormal];
    }
    return _twoDimensionBtn;
}

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([LogisticsNumberCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait
{
    CGFloat height = 60;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[LogisticsNumberCell class]];
    return dict;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.LogisticsNum];
        [self.contentView addSubview:self.textViewBg];
        [self.textViewBg addSubview:self.LogisticsNumTf];
        [self.textViewBg addSubview:self.two_dimensionBtn];
        [self.twoDimensionBtn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

//二维码扫描
-(void)buttonClick
{
    
    ScanningViewController * scanning = [[ScanningViewController alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scannedResultString:) name:@"scannedResult" object:nil];
    if (self.two_dimension_code) {
        self.two_dimension_code(scanning);
    }
}

-(void)scannedResultString:(NSNotification *)n
{
    NSDictionary * dict = n.userInfo;
    self.LogisticsNumTf.text = dict[@"scannedResult"];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    
}

@end
