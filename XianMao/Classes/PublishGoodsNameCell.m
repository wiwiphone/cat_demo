//
//  PublishGoodsNameCell.m
//  yuncangcat
//
//  Created by apple on 16/8/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishGoodsNameCell.h"

@interface PublishGoodsNameCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, assign) NSInteger lenght;
@end

@implementation PublishGoodsNameCell

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        _textField.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _textField.font = [UIFont systemFontOfSize:15.f];
    }
    return _textField;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"标题";
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishGoodsNameCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)goodsName cateName:(NSString *)cateName brandName:(NSString *)brandName grade:(NSString *)grade brandEnName:(NSString *)brandEnName
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishGoodsNameCell class]];
    if (goodsName) {
        [dict setObject:goodsName forKey:@"goodsName"];
    }
    if (cateName) {
        [dict setObject:cateName forKey:@"cateName"];
    }
    if (brandName) {
        [dict setObject:brandName forKey:@"brandName"];
    }
    if (grade) {
        [dict setObject:grade forKey:@"grade"];
    }
    if (brandEnName) {
        [dict setObject:brandEnName forKey:@"brandEnName"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.textField];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endEdit) name:@"endEdit" object:nil];
    }
    return self;
}

-(void)endEdit{
    
    [self.contentView endEditing:YES];
    
//    if (self.downGoodsName) {
//        self.downGoodsName(self.textField.text);
//    }
    
//    if ([self.goodsNameDelegate respondsToSelector:@selector(getGoodsName:)]) {
//        [self.goodsNameDelegate getGoodsName:self.textField.text];
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getGoodsName" object:@{@"goodsName":self.textField.text}];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.location < self.lenght) {
        return NO;
    }
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self endEdit];

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self endEdit];
    
    return YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(10);
        make.width.equalTo(@(kScreenWidth-65));
        make.height.equalTo(@25);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *goodsName = dict[@"goodsName"];
    NSString *cateName = dict[@"cateName"];
    NSString *brandName = dict[@"brandName"];
    NSString *grade = dict[@"grade"];
    NSString *brandEnName = dict[@"brandEnName"];
    
    NSMutableString *brandStr = [[NSMutableString alloc] init];
    if (brandEnName) {
        [brandStr appendString:brandEnName];
        [brandStr appendString:@"/"];
        [brandStr appendString:brandName];
    } else {
        [brandStr appendString:brandName];
    }
    NSMutableString *goodsNameStr = [[NSMutableString alloc] init];
    [goodsNameStr appendString:grade];
    [goodsNameStr appendString:@" "];
    [goodsNameStr appendString:brandStr];
    [goodsNameStr appendString:@" "];
    [goodsNameStr appendString:cateName];
    [goodsNameStr appendString:@" "];
    
    self.textField.text = goodsName;
    self.lenght = goodsNameStr.length;
    if (goodsName.length > 0) {
        [self.textField becomeFirstResponder];
    }
    
}

@end
