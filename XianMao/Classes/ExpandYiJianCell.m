//
//  ExpandYiJianCell.m
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ExpandYiJianCell.h"
#import "Command.h"
#import "NSString+URLEncoding.h"
#import "NetworkManager.h"
#import "Error.h"
#import "GoodsEditableInfo.h"

@interface ExpandYiJianCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) CommandButton *yijianBtn;
@property (nonatomic, copy) NSString *numberTextField;

@property (nonatomic, strong) NSMutableDictionary *editDic;

@property (nonatomic, strong) NSNumber *brandId;
@property (nonatomic, strong) NSNumber *cateId;

@property (nonatomic, strong) PublishAttrInfo *attrInfo;
@end

@implementation ExpandYiJianCell

-(NSMutableDictionary *)editDic{
    if (!_editDic) {
        _editDic = [[NSMutableDictionary alloc] init];
    }
    return _editDic;
}

-(CommandButton *)yijianBtn{
    if (!_yijianBtn) {
        _yijianBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_yijianBtn setTitle:@"尝试一键匹配" forState:UIControlStateNormal];
        [_yijianBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _yijianBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        _yijianBtn.backgroundColor = [UIColor colorWithHexString:@"434342"];
    }
    return _yijianBtn;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
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
        __reuseIdentifier = NSStringFromClass([ExpandYiJianCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 55;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo brandId:(NSInteger)brandId cateId:(NSInteger)cateId
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpandYiJianCell class]];
    if (attrInfo) {
        [dict setObject:attrInfo forKey:@"attrInfo"];
    }
    
    if (brandId > 0) {
        [dict setObject:@(brandId) forKey:@"brandId"];
    }
    
    if (cateId > 0) {
        [dict setObject:@(cateId) forKey:@"cateId"];
    }
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF;
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.textField];
        [self.contentView addSubview:self.yijianBtn];
        
        self.yijianBtn.handleClickBlock = ^(CommandButton *sender){
            
            if (weakSelf.numberTextField.length == 0) {
                [[CoordinatingController sharedInstance] showHUD:@"请输入型号" hideAfterDelay:0.8];
                return ;
            }
            
            NSDictionary *param = @{@"brand_id":weakSelf.brandId, @"category_id":weakSelf.cateId, @"number":[weakSelf.numberTextField URLEncodedString]};//[weakSelf.numberTextField URLEncodedString]};//self.brandId  self.cateId
            
            [[CoordinatingController sharedInstance] showProcessingHUD:@""];
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods" path:@"get_match_product_info" parameters:param completionBlock:^(NSDictionary *data) {
                [[CoordinatingController sharedInstance] hideHUD];
                
                if (data[@"get_match_product_info"] == nil) {
                    [[CoordinatingController sharedInstance] showHUD:@"未匹配成功，手动点选剩下的参数吧。" hideAfterDelay:0.8];
                    return ;
                }
                
                GoodsEditableInfo *edit = [[GoodsEditableInfo alloc] initWithDict:data[@"get_match_product_info"]];
//                    [weakSelf.editDic setObject:edit forKey:[NSString stringWithFormat:@"%ld", edit.attrId]];
                for (int i = 0; i < edit.attrInfoList.count; i++) {
                    AttrEditableInfo *attrInfo = edit.attrInfoList[i];
                    [weakSelf.editDic setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", attrInfo.attrId]];
                }
                AttrEditableInfo *attrInfo = [[AttrEditableInfo alloc] init];
                attrInfo.attrId = weakSelf.attrInfo.attr_id;
                attrInfo.attrValue = weakSelf.textField.text;
                [weakSelf.editDic setObject:attrInfo forKey:[NSString stringWithFormat:@"%ld", weakSelf.attrInfo.attr_id]];
                
                if (weakSelf.yijianpipei) {
                    weakSelf.yijianpipei(weakSelf.editDic);
                }
                
            } failure:^(XMError *error) {
                [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
            } queue:nil]];
        };
    }
    return self;
    
}

-(void)endEdit{
    [self.contentView endEditing:YES];
    if (self.textField.text.length > 0) {
        if (self.yijianEndEdit) {
            self.yijianEndEdit(self.textField.text, self.attrInfo.attr_id);
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.numberTextField = textField.text;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
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
        make.width.equalTo(@110);
    }];
    
    [self.yijianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl.mas_centerY);
        make.left.equalTo(self.textField.mas_right).offset(5);
        make.width.equalTo(@100);
        make.height.equalTo(@24);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    PublishAttrInfo *attrInfo = dict[@"attrInfo"];
    self.attrInfo = attrInfo;
    self.titleLbl.text = attrInfo.attr_name;
    
    self.brandId = dict[@"brandId"];
    self.cateId = dict[@"cateId"];
    
    
}

@end
