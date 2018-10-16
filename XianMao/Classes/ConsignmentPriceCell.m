//
//  ConsignmentPriceCell.m
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ConsignmentPriceCell.h"

@interface ConsignmentPriceCell()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UITextField * priceTf;

@end


@implementation ConsignmentPriceCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ConsignmentPriceCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 40.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ConsignmentPriceCell class]];
    return dict;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _title.text = @"期望价格            ¥";

        [_title sizeToFit];
    }
    return _title;
}

- (UITextField *)priceTf{
    if (!_priceTf) {
        _priceTf = [[UITextField alloc] init];
        _priceTf.placeholder = @"请输入期望价格";
        _priceTf.font = [UIFont systemFontOfSize:15];
        _priceTf.textAlignment = NSTextAlignmentLeft;
        _priceTf.keyboardType = UIKeyboardTypeNumberPad;
        _priceTf.delegate = self;
    }
    return _priceTf;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.priceTf];
        
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.handleConsignmentPriceBlcok) {
        self.handleConsignmentPriceBlcok([textField.text doubleValue]);
    }
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",self.title.text]];
    NSRange range=[[hintString string] rangeOfString:@"¥"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    self.title.attributedText = hintString;
}


- (void)layoutSubviews{
    self.title.frame = CGRectMake(14, self.contentView.height/2 - self.title.height/2, self.title.width, self.title.height);
    
    [self.priceTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_top);
        make.bottom.equalTo(self.title.mas_bottom);
        make.left.equalTo(self.title.mas_right).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

@end
