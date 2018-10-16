//
//  ExpandInputCell.m
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExpandInputCell.h"
#import "GoodsEditableInfo.h"

@interface ExpandInputCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger attrId;

@end

@implementation ExpandInputCell

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.layer.borderColor = [UIColor colorWithHexString:@"cbcbcb"].CGColor;
        _textField.layer.borderWidth = 1.f;
    }
    return _textField;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ExpandInputCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 55;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo andAttrDict:(NSDictionary *)attrDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpandInputCell class]];
    if (attrInfo) {
        [dict setObject:attrInfo forKey:@"attrInfo"];
    }
    if (attrDict) {
        [dict setObject:attrDict forKey:@"attrDict"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.textField];
        
    }
    return self;

}

-(void)endEdit{
    [self.contentView endEditing:YES];
    if (self.returnInputTextField) {
        self.returnInputTextField(self.text, self.attrId);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.text = textField.text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.text = textField.text;
    [self endEdit];
    return YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.left.equalTo(self.titleLbl.mas_right).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@170);
    }];

}

-(void)updateCellWithDict:(NSDictionary *)dict{
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    NSDictionary *attrDict = dict[@"attrDict"];
    self.attrId = attrInfo.attr_id;
    self.titleLbl.text = attrInfo.attr_name;
    if (attrDict[[NSString stringWithFormat:@"%ld", attrInfo.attr_id]]) {
        AttrEditableInfo *attrEditInfo = attrDict[[NSString stringWithFormat:@"%ld", attrInfo.attr_id]];
        self.textField.text = attrEditInfo.attrValue;
    }
}

@end
